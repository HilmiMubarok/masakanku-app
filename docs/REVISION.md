# RFC-001

# Single User Architecture Revision

Project: Masakanku

Version: 1.0

Status: Accepted

Date: 2026-05-30

---

# 1. Background

Pada desain awal, Masakanku dirancang sebagai aplikasi multi-user menggunakan authentication, user management, dan data isolation.

Setelah evaluasi kebutuhan aktual, aplikasi akan digunakan hanya oleh satu pengguna (owner) pada fase awal pengembangan.

Karena itu kompleksitas multi-user dianggap premature optimization dan tidak memberikan nilai bisnis pada tahap validasi produk.

---

# 2. Decision

Masakanku V0 dan V1 akan menggunakan arsitektur single-user.

Authentication dan user management dihapus dari scope MVP.

Aplikasi langsung dapat digunakan setelah instalasi tanpa proses login.

---

# 3. Objectives

Tujuan perubahan ini:

* Mempercepat development.
* Mengurangi kompleksitas backend.
* Mengurangi jumlah tabel database.
* Mengurangi jumlah API.
* Fokus pada validasi fitur utama.
* Mengurangi maintenance cost.

---

# 4. Architecture Impact

## Previous Architecture

```text
Flutter
    ↓
Authentication
    ↓
Business Layer
    ↓
Database
```

---

## New Architecture

```text
Flutter
    ↓
Business Layer
    ↓
Database
```

---

## AI Flow

```text
Flutter
    ↓
Supabase Edge Function
    ↓
DeepSeek API
    ↓
JSON Response
    ↓
Flutter
```

---

# 5. Scope Changes

## Removed

### Authentication

Removed:

* Register
* Login
* Logout
* Refresh Token
* Password Reset

---

### User Management

Removed:

* User Profile
* User Session
* User Preferences per Account

---

### Security Layer

Removed:

* JWT
* User Authorization
* User Ownership Validation

---

# 6. Database Changes

---

## Remove Table

### users

Reason:

Single user application.

---

### user_preferences

Reason:

No user context required.

---

### favorite_recipes

Reason:

Can be simplified into recipe flag.

---

# 7. New Database Model

## ingredients

Master ingredient data.

---

## pantry_items

User pantry inventory.

---

## recipes

Saved recipes.

---

## recipe_ingredients

Recipe composition.

---

## recipe_steps

Recipe instructions.

---

## recipe_nutrition

Nutrition calculation results.

---

# 8. Recipe Table Revision

## Previous

```sql
id
user_id
title
description
```

---

## New

```sql
id
title
description
```

---

# 9. Pantry Table Revision

## Previous

```sql
id
user_id
ingredient_id
quantity
```

---

## New

```sql
id
ingredient_id
quantity
```

---

# 10. Favorite Recipe Revision

## Previous

Table:

```sql
favorite_recipes
```

---

## New

Column:

```sql
is_favorite boolean
```

Added into:

```sql
recipes
```

---

# 11. Settings Strategy

Instead of user preferences:

Create:

```sql
app_settings
```

---

Columns

```sql
id
setting_key
setting_value
updated_at
```

---

Examples

```text
spicy_level

preferred_cuisine

diet_type
```

---

# 12. API Changes

---

## Remove APIs

Authentication APIs removed.

### Removed Endpoints

```http
POST /auth/register

POST /auth/login

POST /auth/logout

POST /auth/refresh
```

---

## Keep APIs

### Pantry

```http
GET /pantry

POST /pantry

PUT /pantry/{id}

DELETE /pantry/{id}
```

---

### Recipe

```http
GET /recipes

GET /recipes/{id}

POST /recipes

PUT /recipes/{id}

DELETE /recipes/{id}
```

---

### AI

```http
POST /ai/chat
```

---

### Ingredient

```http
GET /ingredients
```

---

# 13. Revised MVP Scope

## Core Features

### Pantry Management

* Add ingredient
* Edit ingredient
* Delete ingredient
* Expiration tracking

---

### Recipe Management

* Save recipe
* Edit recipe
* Delete recipe
* Favorite recipe

---

### AI Recipe Generation

* Generate recipe from pantry
* Generate recipe from manual ingredients

---

### Ingredient Substitution

* Alternative ingredient recommendation

---

### Cooking Assistant

* Ask cooking-related questions

---

### Nutritional Analysis

* Calories
* Protein
* Fat
* Carbohydrate

---

# 14. Revised Release Plan

## V0.1

### Goal

Validate pantry-to-recipe workflow.

Features:

* Ingredient CRUD
* Pantry CRUD
* AI Recipe Generation
* Save Recipe
* Recipe List

---

## V0.2

### Goal

Improve recipe management.

Features:

* Favorite Recipe
* Nutrition Analysis
* Recipe Search

---

## V0.3

### Goal

Improve cooking experience.

Features:

* Cooking Mode
* Recipe Modification
* Ingredient Substitution

---

## V1.0

### Goal

Daily usable application.

Features:

* Dashboard
* Expiration Reminder
* Settings
* Performance Improvements

---

# 15. Future Migration Path

If public release is required:

Reintroduce:

```text
Authentication

Users

Preferences

Authorization
```

Because all domain entities remain separated, migration to multi-user architecture can be performed without major schema redesign.

---

# 16. Final Decision

Masakanku will remain a single-user application until product-market fit and daily usability have been validated.

Authentication is intentionally deferred to a future release.

```
```
