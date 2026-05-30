# AI Design Document (AIDD)

# Masakanku - AI Kitchen Assistant

Version: 1.0

Status: Proposed

---

# 1. Purpose

Dokumen ini mendefinisikan:

* AI architecture
* AI responsibilities
* Prompt strategy
* Output schemas
* Validation rules
* Cost optimization
* Future AI roadmap

---

# 2. AI Philosophy

## Principle 1

AI generates.

Database stores.

Application controls.

AI is never the source of truth.

---

## Principle 2

AI provides recommendations.

Application provides decisions.

---

## Principle 3

All AI outputs must be structured.

Never depend on free-form responses.

---

# 3. AI Scope

## MVP Responsibilities

AI is responsible for:

### Recipe Generation

Input:

```text
Available ingredients
```

Output:

```text
Recipe recommendation
```

---

### Recipe Improvement

Input:

```text
Existing recipe
```

Output:

```text
Improved recipe
```

Examples:

* More spicy
* Less spicy
* High protein
* Vegetarian

---

### Ingredient Substitution

Input:

```text
Missing ingredient
```

Output:

```text
Alternative ingredients
```

---

### Cooking Assistant

Input:

```text
Recipe step
```

Output:

```text
Cooking explanation
```

---

# 4. Out of Scope

AI must NOT perform:

### Nutrition Calculation

Reason:

Non-deterministic

Risk of inaccurate values

---

### User Authentication

---

### Pantry Management

---

### Recipe Persistence

---

### Business Logic

---

# 5. AI Architecture

## High-Level Flow

```text
Flutter
   ↓
Supabase Edge Function
   ↓
Prompt Builder
   ↓
DeepSeek
   ↓
Response Validator
   ↓
JSON Parser
   ↓
Application
```

---

# 6. AI Modules

## Module 1

Recipe Generator

Purpose:

Generate recipes from available ingredients.

---

## Module 2

Recipe Modifier

Purpose:

Modify existing recipes.

---

## Module 3

Ingredient Advisor

Purpose:

Provide substitutions and alternatives.

---

## Module 4

Cooking Assistant

Purpose:

Answer cooking-related questions.

---

# 7. Single Endpoint Strategy

MVP uses:

```http
POST /ai/chat
```

Single entry point.

---

Request:

```json
{
  "intent": "",
  "payload": {}
}
```

---

Supported Intents:

```text
recipe_generation

recipe_modification

ingredient_substitution

cooking_assistant
```

---

# 8. Intent Definitions

---

## recipe_generation

Generate recipes from pantry ingredients.

---

Input

```json
{
  "ingredients": [],
  "servings": 2,
  "cooking_time": 20,
  "difficulty": "easy"
}
```

---

Output

```json
{
  "title": "",
  "description": "",
  "ingredients": [],
  "steps": []
}
```

---

## recipe_modification

Modify existing recipes.

---

Input

```json
{
  "recipe_id": "",
  "instruction": "make it spicier"
}
```

---

Output

```json
{
  "title": "",
  "ingredients": [],
  "steps": []
}
```

---

## ingredient_substitution

---

Input

```json
{
  "ingredient": "santan"
}
```

---

Output

```json
{
  "ingredient": "santan",
  "alternatives": []
}
```

---

## cooking_assistant

---

Input

```json
{
  "question": ""
}
```

---

Output

```json
{
  "answer": ""
}
```

---

# 9. System Prompt Strategy

## Global System Prompt

AI Role:

```text
You are an experienced Indonesian chef and nutrition-aware cooking assistant.

Your job is to generate practical recipes using available ingredients.

Always prioritize:
- ingredient availability
- realistic cooking methods
- Indonesian cooking culture
- simplicity

Never invent unavailable ingredients unless clearly marked as optional.

Always return valid JSON.
```

---

# 10. Recipe Generation Prompt

## Inputs

User Pantry

```json
{
  "ingredients": [
    "telur",
    "tempe",
    "cabai",
    "bawang merah"
  ]
}
```

---

Prompt Builder:

```text
Generate a realistic recipe using the provided ingredients.

Return:
- title
- description
- ingredients
- steps

Return valid JSON only.
```

---

# 11. Recipe JSON Schema

```json
{
  "title": "",
  "description": "",
  "servings": 2,
  "cooking_time_minutes": 20,
  "difficulty": "easy",
  "ingredients": [
    {
      "name": "",
      "quantity": 0,
      "unit": ""
    }
  ],
  "steps": [
    {
      "step": 1,
      "instruction": ""
    }
  ]
}
```

---

# 12. Validation Rules

Before response reaches client:

Validate:

### Required Fields

```text
title
ingredients
steps
```

---

### Minimum Requirements

```text
ingredients >= 1

steps >= 3
```

---

### Reject If

```text
Invalid JSON

Missing title

Missing ingredients

Missing steps
```

---

# 13. Error Handling

## AI Timeout

Response:

```json
{
  "error": "AI_TIMEOUT"
}
```

---

## Invalid Output

Response:

```json
{
  "error": "AI_INVALID_RESPONSE"
}
```

---

## Empty Recipe

Response:

```json
{
  "error": "AI_EMPTY_RESULT"
}
```

---

# 14. Cost Optimization

## Rule 1

Only call AI when necessary.

---

Bad:

```text
Open recipe
↓
Call AI
```

---

Good:

```text
Open recipe
↓
Database
```

---

## Rule 2

Cache AI results.

---

Cache Key

```text
ingredients
+
servings
+
difficulty
```

---

## Rule 3

Save generated recipes.

Avoid repeated generation.

---

# 15. Observability

Log:

### Request

```text
intent
```

---

### Metadata

```text
token count

response time

success
```

---

Never log:

```text
API key
```

---

# 16. Future AI Roadmap

---

## V2

Vision AI

Input:

```text
Photo
```

Output:

```text
Ingredient detection
```

---

## V3

Meal Planning AI

Input:

```text
Pantry
+
Preferences
+
Nutrition Goals
```

Output:

```text
Weekly meal plan
```

---

## V4

Personal Cooking Agent

Input:

```text
History
+
Preferences
+
Pantry
```

Output:

```text
Personalized cooking recommendations
```

---

# 17. ADR

## ADR-001

Decision:

Single LLM

Choice:

DeepSeek

Reason:

Lowest complexity.

---

## ADR-002

Decision:

Single Endpoint

Reason:

Simple architecture.

---

## ADR-003

Decision:

Structured JSON Output

Reason:

Reliable frontend integration.

---

## ADR-004

Decision:

Nutrition calculated by application.

Reason:

Deterministic results.

---

# 18. MVP AI Definition

AI MVP is complete when:

* Recipe generation works.
* Recipe modification works.
* Ingredient substitution works.
* Cooking assistant works.
* Structured JSON validation works.
* Error handling works.
* Caching works.

Everything else belongs to future releases.

```
```
