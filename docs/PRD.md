# Product Requirements Document (PRD)

## Masakanku - AI Kitchen Assistant

| Attribute    | Value              |
| ------------ | ------------------ |
| Product Name | Masakanku          |
| Version      | MVP v1.0           |
| Status       | Draft              |
| Product Type | Mobile Application |
| Platform     | Android & iOS      |
| Owner        | Product Team       |
| Last Updated | 2026-05-29         |

---

# 1. Overview

## 1.1 Background

Many users struggle to decide what to cook based on available ingredients. Existing recipe applications focus on recipe collections rather than helping users make daily cooking decisions.

Masakanku aims to become an AI-native kitchen assistant that helps users manage ingredients, generate personalized recipes, analyze nutritional values, and reduce food waste.

## 1.2 Product Vision

Become a personal AI cooking assistant that helps users decide what to cook based on available ingredients, nutritional goals, and cooking preferences.

## 1.3 Product Mission

Transform cooking from a recipe-searching activity into a decision-support experience powered by artificial intelligence.

---

# 2. Problem Statement

Users commonly experience the following challenges:

1. Uncertainty about what to cook using available ingredients.
2. Food ingredients expiring before being utilized.
3. Difficulty estimating nutritional content of homemade meals.
4. Recipe information scattered across multiple platforms.
5. Lack of a structured personal recipe management system.

---

# 3. Goals

## 3.1 Product Goals

* Build a usable AI-native cooking assistant.
* Validate pantry-based recipe recommendation workflows.
* Establish a foundation for future public release.

## 3.2 User Goals

* Discover meal ideas quickly.
* Reduce ingredient waste.
* Store personal recipes efficiently.
* Understand nutritional information of meals.
* Simplify meal planning decisions.

---

# 4. Success Metrics

| Metric                         | Target           |
| ------------------------------ | ---------------- |
| Daily Active Usage             | 1+ session/day   |
| Pantry Updates                 | 3+ times/week    |
| Generated Recipes              | 10+ recipes/week |
| Saved Recipes                  | 20+ recipes      |
| Recipe Generation Success Rate | >95%             |
| AI Response Time               | <10 seconds      |
| User Retention (30 Days)       | >70%             |

---

# 5. User Persona

## Primary Persona

### Home Cook

| Attribute         | Description                    |
| ----------------- | ------------------------------ |
| Age               | 20-45                          |
| Cooking Skill     | Beginner to Intermediate       |
| Cooking Frequency | 3-7 times/week                 |
| Device            | Smartphone                     |
| Goal              | Quickly determine what to cook |

### Pain Points

* Unsure what to cook daily.
* Ingredients often remain unused.
* Difficulty maintaining balanced nutrition.
* Recipe search consumes too much time.

---

# 6. Scope

## In Scope (MVP)

### Authentication

* User registration
* Login
* Logout
* Password reset

### Pantry Management

* Add ingredient
* Update ingredient
* Delete ingredient
* Quantity tracking
* Expiration date tracking

### Recipe Management

* Create recipe
* Edit recipe
* Delete recipe
* Categorize recipe
* Save recipe as favorite

### AI Recipe Generation

Generate recipes based on:

* Available ingredients
* Serving size
* Cooking duration
* Cuisine preference

### Nutritional Analysis

Display:

* Calories
* Protein
* Carbohydrates
* Fat

### Cooking Mode

* Step-by-step cooking guidance
* Progress tracking
* Cooking timer

---

## Out of Scope (MVP)

* Social sharing
* Community recipes
* Video content
* Marketplace integration
* Grocery delivery integration
* Smart kitchen IoT integration
* Subscription plans

---

# 7. User Stories

## Pantry Management

### US-001

As a user, I want to add ingredients into my pantry so that I can track available ingredients.

### US-002

As a user, I want to update ingredient quantities so that pantry information remains accurate.

### US-003

As a user, I want to track expiration dates so that I can reduce food waste.

---

## Recipe Management

### US-004

As a user, I want to save my personal recipes so that I can reuse them later.

### US-005

As a user, I want to organize recipes by category so that recipes are easier to find.

---

## AI Features

### US-006

As a user, I want AI to generate recipes from available ingredients so that I can decide what to cook quickly.

### US-007

As a user, I want nutritional information for generated recipes so that I can make healthier choices.

### US-008

As a user, I want step-by-step cooking guidance so that I can cook confidently.

---

# 8. Functional Requirements

---

## FR-001 User Authentication

### Description

The system shall allow users to register and authenticate.

### Acceptance Criteria

* User can register using email and password.
* User can login using valid credentials.
* User session persists after successful login.
* User can logout successfully.

---

## FR-002 Pantry Management

### Description

The system shall provide ingredient inventory management.

### Acceptance Criteria

* User can add ingredients.
* User can edit ingredients.
* User can delete ingredients.
* User can specify quantity.
* User can specify measurement units.
* User can specify expiration dates.

### Data Fields

| Field           | Required |
| --------------- | -------- |
| Name            | Yes      |
| Category        | Yes      |
| Quantity        | Yes      |
| Unit            | Yes      |
| Expiration Date | No       |

---

## FR-003 Recipe Management

### Description

The system shall provide personal recipe management.

### Acceptance Criteria

* User can create recipes.
* User can edit recipes.
* User can delete recipes.
* User can upload recipe images.
* User can organize recipes by category.

### Recipe Structure

* Recipe Name
* Description
* Ingredients
* Cooking Steps
* Serving Size
* Cooking Duration
* Image

---

## FR-004 AI Recipe Generator

### Description

The system shall generate recipes based on pantry ingredients.

### Inputs

* Ingredient List
* Serving Size
* Cooking Time
* Cuisine Preference

### Outputs

* Recipe Name
* Ingredients
* Cooking Instructions
* Nutritional Summary

### Acceptance Criteria

* AI returns at least one recipe.
* Generated recipe contains ingredients.
* Generated recipe contains cooking instructions.
* Generated recipe includes nutritional information.

---

## FR-005 Nutritional Analysis

### Description

The system shall calculate estimated nutrition values.

### Outputs

* Calories
* Protein
* Fat
* Carbohydrates

### Acceptance Criteria

* Nutritional information displayed per serving.
* Values displayed consistently across generated recipes.

---

## FR-006 Favorite Recipe

### Description

The system shall allow users to save favorite recipes.

### Acceptance Criteria

* User can mark recipe as favorite.
* User can remove favorite status.
* User can view favorite recipe list.

---

## FR-007 Cooking Mode

### Description

The system shall provide guided cooking experience.

### Acceptance Criteria

* User can view cooking steps sequentially.
* User can mark completed steps.
* User can navigate between steps.
* User can use cooking timer.

---

# 9. Non-Functional Requirements

## Performance

| Requirement        | Target  |
| ------------------ | ------- |
| App Launch Time    | <3 sec  |
| API Response Time  | <2 sec  |
| AI Generation Time | <10 sec |

---

## Availability

| Requirement          | Target |
| -------------------- | ------ |
| Service Availability | 99%    |

---

## Security

* JWT-based authentication
* Secure password hashing
* HTTPS communication only
* User data isolation
* Secure API access

---

## Scalability

Support future growth including:

* 100,000+ recipes
* 10,000+ ingredients per user
* Multi-device synchronization

---

# 10. Information Architecture

```text
Home
├── Pantry
│   ├── Ingredient List
│   ├── Ingredient Detail
│   └── Add Ingredient
│
├── Recipes
│   ├── Recipe List
│   ├── Recipe Detail
│   └── Create Recipe
│
├── AI Assistant
│   ├── Generate Recipe
│   └── Generated Result
│
├── Cooking Mode
│
└── Profile
    └── Settings
```

---

# 11. User Flow

## Pantry-Based Recipe Generation

```text
Launch App
    ↓
Open Pantry
    ↓
Review Available Ingredients
    ↓
Generate Recipe
    ↓
AI Analysis
    ↓
Recipe Generated
    ↓
Review Nutrition
    ↓
Start Cooking Mode
```

---

# 12. Risks

| Risk                          | Impact | Mitigation                        |
| ----------------------------- | ------ | --------------------------------- |
| AI Hallucination              | High   | Structured JSON output            |
| Invalid Nutrition Data        | High   | Nutrition database validation     |
| High AI Cost                  | Medium | Caching generated results         |
| Poor Recipe Quality           | High   | Prompt engineering and evaluation |
| Ingredient Recognition Errors | Medium | User confirmation flow            |

---

# 13. Dependencies

## External Services

* Authentication Provider
* AI Provider (OpenAI/Gemini)
* Nutrition Database
* Cloud Storage

## Internal Components

* Mobile Application
* Backend API
* AI Orchestration Layer
* Database

---

# 14. Future Roadmap

## V1.5

* Shopping List
* Recipe Search
* Ingredient Categories

## V2.0

* Fridge Scanner
* OCR Ingredient Detection
* AI Cooking Chat

## V3.0

* Weekly Meal Planner
* Pantry Health Score
* Grocery Prediction
* Cost Per Serving Calculator

## V4.0

* Family Accounts
* Community Recipes
* Recipe Sharing
* AI Nutrition Coach

```
```
