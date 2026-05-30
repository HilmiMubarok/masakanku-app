# Technical Architecture Document (TAD)

# Masakanku - AI Kitchen Assistant

Version: 1.0

Status: Proposed

Author: Engineering Team

---

# 1. Purpose

Dokumen ini mendefinisikan arsitektur teknis Masakanku MVP, termasuk:

* Mobile architecture
* Backend architecture
* Database design
* AI orchestration
* Nutritional engine
* Security model
* Scalability strategy

---

# 2. Architecture Principles

## AP-001 AI First

AI merupakan core domain, bukan fitur tambahan.

Semua workflow utama berpusat pada:

```text
User Input
    ↓
AI Analysis
    ↓
Structured Result
    ↓
Application Experience
```

---

## AP-002 Mobile First

Produk dioptimalkan untuk mobile.

Platform:

* Android
* iOS

Single codebase digunakan untuk mengurangi maintenance cost.

---

## AP-003 Backend Thin Layer

Business logic ditempatkan pada service layer.

Backend hanya bertugas:

* Authentication
* Data persistence
* AI orchestration
* File storage

---

## AP-004 Structured AI Output

LLM tidak boleh mengembalikan free text.

Semua AI response wajib menggunakan JSON schema.

---

# 3. Technology Stack

## Mobile

| Layer            | Technology             |
| ---------------- | ---------------------- |
| Framework        | Flutter                |
| Language         | Dart                   |
| State Management | Riverpod               |
| Routing          | GoRouter               |
| Networking       | Dio                    |
| Local Database   | Hive                   |
| Secure Storage   | Flutter Secure Storage |

---

## Backend

| Layer                | Technology              |
| -------------------- | ----------------------- |
| Backend Platform     | Supabase                |
| Database             | PostgreSQL              |
| Auth                 | Supabase Auth           |
| Storage              | Supabase Storage        |
| Serverless Functions | Supabase Edge Functions |

---

## AI Layer

| Component          | Technology      |
| ------------------ | --------------- |
| LLM                | OpenAI GPT      |
| Future Alternative | Gemini          |
| Prompt Management  | Backend Service |
| Output Validation  | JSON Schema     |

---

## Infrastructure

| Component  | Technology           |
| ---------- | -------------------- |
| Hosting    | Supabase Cloud       |
| CDN        | Supabase Storage CDN |
| Monitoring | Sentry               |
| Analytics  | PostHog              |

---

# 4. High Level Architecture

```text
+----------------------+
|    Flutter Mobile    |
+----------+-----------+
           |
           |
           v
+----------------------+
|   Supabase Backend   |
+----------+-----------+
           |
           +--------------------+
           |                    |
           v                    v
+----------------+    +----------------+
| PostgreSQL DB  |    | Supabase Auth  |
+----------------+    +----------------+

           |
           v

+----------------------+
|   AI Orchestrator    |
+----------+-----------+
           |
           v

+----------------------+
|      OpenAI API      |
+----------------------+
```

---

# 5. Domain Architecture

## User Domain

Responsible for:

* Authentication
* Profile
* Preferences

---

## Pantry Domain

Responsible for:

* Ingredients
* Stock tracking
* Expiration tracking

---

## Recipe Domain

Responsible for:

* User recipes
* AI recipes
* Favorites

---

## AI Domain

Responsible for:

* Recipe generation
* Ingredient analysis
* Nutrition generation

---

# 6. Database Design

---

## users

```sql
id uuid pk
email varchar
created_at timestamp
updated_at timestamp
```

---

## user_preferences

```sql
id uuid pk
user_id uuid fk

spicy_level integer
preferred_cuisine varchar
diet_type varchar

created_at timestamp
updated_at timestamp
```

---

## ingredients

```sql
id uuid pk
name varchar
category varchar

created_at timestamp
updated_at timestamp
```

---

## pantry_items

```sql
id uuid pk
user_id uuid fk
ingredient_id uuid fk

quantity numeric
unit varchar

expired_at timestamp

created_at timestamp
updated_at timestamp
```

---

## recipes

```sql
id uuid pk
user_id uuid fk

title varchar
description text

servings integer
cooking_time integer

source varchar

created_at timestamp
updated_at timestamp
```

source:

* manual
* ai

---

## recipe_ingredients

```sql
id uuid pk

recipe_id uuid fk
ingredient_id uuid fk

quantity numeric
unit varchar
```

---

## recipe_steps

```sql
id uuid pk

recipe_id uuid fk
step_number integer

instruction text
```

---

## recipe_nutrition

```sql
id uuid pk

recipe_id uuid fk

calories numeric
protein numeric
fat numeric
carbohydrate numeric
```

---

# 7. AI Architecture

## Why AI Orchestrator?

Directly calling OpenAI from mobile introduces:

* API key leakage
* Prompt inconsistency
* No caching
* No validation

Therefore all AI requests pass through backend.

---

## Recipe Generation Flow

```text
User
  ↓

Pantry Ingredients
  ↓

Backend
  ↓

Prompt Builder
  ↓

OpenAI
  ↓

JSON Validation
  ↓

Save Recipe
  ↓

Return Response
```

---

# 8. Prompt Strategy

## System Prompt

AI acts as:

```text
Professional Nutritionist
+
Professional Chef
+
Recipe Generator
```

---

## Output Format

```json
{
  "title": "",
  "description": "",
  "servings": 2,
  "cooking_time": 20,
  "ingredients": [],
  "steps": [],
  "nutrition": {}
}
```

No markdown allowed.

No prose allowed.

Only valid JSON.

---

# 9. Nutritional Engine

## MVP Approach

Recommendation:

Do NOT use AI to calculate nutrition.

Reason:

* expensive
* inaccurate
* non deterministic

Instead:

```text
Recipe Ingredients
        ↓
Nutrition Database
        ↓
Calculation Engine
        ↓
Nutrition Result
```

---

## Nutrition Sources

Future options:

* USDA FoodData Central
* Open Food Facts
* Custom Nutrition Dataset

---

# 10. Offline Strategy

## Offline Supported

* View recipes
* View pantry
* Create recipe draft

---

## Online Required

* AI generation
* Authentication
* Synchronization

---

# 11. Security

## Authentication

Supabase JWT

---

## Secrets

Stored only in:

```text
Supabase Edge Functions
```

Never stored in:

```text
Flutter Client
```

---

## Database Security

Use Row Level Security (RLS)

Example:

```sql
user_id = auth.uid()
```

User can only access own data.

---

# 12. Performance Requirements

## Mobile

Startup:

```text
< 3 sec
```

---

## API

```text
< 2 sec
```

---

## AI Generation

```text
< 10 sec
```

---

# 13. Observability

## Crash Monitoring

Sentry

Track:

* App crashes
* API failures
* AI failures

---

## Product Analytics

PostHog

Track:

* Recipe generated
* Recipe saved
* Pantry updated
* Cooking mode started

---

# 14. Cost Optimization

## AI Response Cache

Before calling OpenAI:

```text
Same ingredients?
Same prompt?
```

If yes:

Return cached result.

---

## Recipe Storage

Save AI recipes.

Avoid regenerating identical recipes.

---

# 15. Future Architecture

## V2

Add:

* OCR
* Fridge Scanner
* Image Recognition

```text
Camera
  ↓
Vision Model
  ↓
Ingredient Detection
```

---

## V3

Add:

* Meal Planner
* Recommendation Engine

```text
Pantry
+
Nutrition Goals
+
History
+
Preferences
        ↓
Recommendation Engine
```

---

# 16. Architecture Decision Records

## ADR-001

Decision:

Flutter

Reason:

Single codebase with mature ecosystem.

---

## ADR-002

Decision:

Supabase

Reason:

Fastest path to MVP.

---

## ADR-003

Decision:

OpenAI

Reason:

Highest quality recipe generation.

---

## ADR-004

Decision:

Nutrition Database over AI Calculation

Reason:

Deterministic and accurate.

---

# 17. MVP Definition

The MVP is considered complete when:

* User authentication works
* Pantry management works
* Recipe management works
* AI recipe generation works
* Nutrition calculation works
* Favorite recipe works
* Cooking mode works

Everything else belongs to future releases.