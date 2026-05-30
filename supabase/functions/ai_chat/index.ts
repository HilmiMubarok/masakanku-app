import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { GLOBAL_SYSTEM_PROMPT, INTENT_PROMPTS } from "./prompts.ts";

const DEEPSEEK_API_KEY = Deno.env.get("DEEPSEEK_API_KEY");

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    if (!DEEPSEEK_API_KEY) {
      throw new Error("Missing DEEPSEEK_API_KEY environment variable");
    }

    const body = await req.json();
    const { intent, payload } = body;

    if (!intent || !payload) {
      return new Response(
        JSON.stringify({ error: "Missing intent or payload" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const intentPrompt = INTENT_PROMPTS[intent as keyof typeof INTENT_PROMPTS];
    if (!intentPrompt) {
      return new Response(
        JSON.stringify({ error: "Unsupported intent" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const userMessage = `${intentPrompt}\n\nInput Payload:\n${JSON.stringify(payload, null, 2)}`;

    // Call DeepSeek API
    const response = await fetch("https://api.deepseek.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${DEEPSEEK_API_KEY}`,
      },
      body: JSON.stringify({
        model: "deepseek-chat", // or appropriate deepseek model
        messages: [
          { role: "system", content: GLOBAL_SYSTEM_PROMPT },
          { role: "user", content: userMessage },
        ],
        response_format: { type: "json_object" }, // if supported by DeepSeek, else rely on prompt
      }),
    });

    if (!response.ok) {
      console.error(`DeepSeek API error: ${response.status} ${response.statusText}`);
      const errText = await response.text();
      console.error(errText);
      return new Response(
        JSON.stringify({ error: "AI_TIMEOUT" }), // General error based on AI_DESIGN_DOCUMENT
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const data = await response.json();
    const aiContent = data.choices[0]?.message?.content;

    if (!aiContent) {
      return new Response(
        JSON.stringify({ error: "AI_EMPTY_RESULT" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Try to parse the JSON output from AI to ensure it's valid
    let parsedResult;
    try {
      parsedResult = JSON.parse(aiContent);
    } catch (e) {
      return new Response(
        JSON.stringify({ error: "AI_INVALID_RESPONSE" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Basic validation based on AI_DESIGN_DOCUMENT (Required Fields for recipe generation)
    if (intent === "recipe_generation") {
      if (!parsedResult.title || !parsedResult.ingredients || !parsedResult.steps) {
        return new Response(
          JSON.stringify({ error: "AI_INVALID_RESPONSE" }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
      if (parsedResult.ingredients.length < 1 || parsedResult.steps.length < 3) {
        return new Response(
          JSON.stringify({ error: "AI_INVALID_RESPONSE" }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    return new Response(
      JSON.stringify(parsedResult),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error(error);
    return new Response(
      JSON.stringify({ error: "Internal Server Error", details: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
