# Database Design Document (DDD)

# Masakanku - AI Kitchen Assistant

Version: 1.0

Status: Proposed

Database Engine: PostgreSQL (Supabase)

---

# 1. Purpose

Dokumen ini mendefinisikan:

* Database schema
* Entity relationship
* Table definitions
* Constraints
* Index strategy
* Future scalability considerations

---

# 2. Design Principles

## DP-001 User Isolation

Semua data dimiliki oleh user.

```text
User
 ├── Pantry
 ├── Recipes
 ├── Favorites
 └── Preferences
```

---

## DP-002 AI Is Not Source of Truth

AI hanya menghasilkan data.

Semua hasil AI disimpan sebagai data terstruktur.

---

## DP-003 Normalized First

Menggunakan normalisasi hingga level yang masih mudah dikelola.

Target:

* Readability
* Maintainability
* Scalability

---

# 3. ERD Overview

```text
users
 │
 ├── user_preferences
 │
 ├── pantry_items
 │        │
 │        └── ingredients
 │
 ├── recipes
 │      │
 │      ├── recipe_ingredients
 │      │          │
 │      │          └── ingredients
 │      │
 │      ├── recipe_steps
 │      │
 │      ├── recipe_nutrition
 │      │
 │      └── recipe_images
 │
 └── favorite_recipes
```

---

# 4. Table Definitions

---

# 4.1 users

Owner information.

## Columns

| Column     | Type         | Nullable | Description   |
| ---------- | ------------ | -------- | ------------- |
| id         | uuid         | No       | Primary Key   |
| email      | varchar(255) | No       | User email    |
| full_name  | varchar(255) | Yes      | Display name  |
| avatar_url | text         | Yes      | Profile image |
| created_at | timestamptz  | No       | Created date  |
| updated_at | timestamptz  | No       | Updated date  |

## Constraints

```sql
PRIMARY KEY(id)

UNIQUE(email)
```

---

# 4.2 user_preferences

User personalization settings.

## Columns

| Column            | Type         |
| ----------------- | ------------ |
| id                | uuid         |
| user_id           | uuid         |
| spicy_level       | smallint     |
| preferred_cuisine | varchar(100) |
| diet_type         | varchar(100) |
| created_at        | timestamptz  |
| updated_at        | timestamptz  |

## Example Values

spicy_level

```text
1 = Mild
2 = Medium
3 = Spicy
```

diet_type

```text
normal
vegetarian
vegan
keto
high_protein
```

---

# 4.3 ingredients

Master ingredient table.

## Purpose

Single source of truth untuk semua bahan.

## Columns

| Column        | Type          |
| ------------- | ------------- |
| id            | uuid          |
| name          | varchar(255)  |
| category      | varchar(100)  |
| default_unit  | varchar(50)   |
| calories_100g | numeric(10,2) |
| protein_100g  | numeric(10,2) |
| fat_100g      | numeric(10,2) |
| carbs_100g    | numeric(10,2) |
| fiber_100g    | numeric(10,2) |
| created_at    | timestamptz   |
| updated_at    | timestamptz   |

## Example

```text
Telur
Ayam
Tempe
Tahu
Bawang Merah
Cabai
```

---

# 4.4 pantry_items

Ingredient inventory milik user.

## Columns

| Column        | Type          |
| ------------- | ------------- |
| id            | uuid          |
| user_id       | uuid          |
| ingredient_id | uuid          |
| quantity      | numeric(10,2) |
| unit          | varchar(50)   |
| expired_at    | date          |
| notes         | text          |
| created_at    | timestamptz   |
| updated_at    | timestamptz   |

## Example

```text
Telur
12
pcs
2026-06-15
```

---

# 4.5 recipes

Recipe master.

## Columns

| Column               | Type         |
| -------------------- | ------------ |
| id                   | uuid         |
| user_id              | uuid         |
| title                | varchar(255) |
| description          | text         |
| servings             | integer      |
| cooking_time_minutes | integer      |
| difficulty           | varchar(50)  |
| source               | varchar(50)  |
| ai_prompt            | text         |
| created_at           | timestamptz  |
| updated_at           | timestamptz  |

## Source

```text
manual
ai
```

## Difficulty

```text
easy
medium
hard
```

---

# 4.6 recipe_ingredients

Many-to-many relationship.

## Columns

| Column        | Type          |
| ------------- | ------------- |
| id            | uuid          |
| recipe_id     | uuid          |
| ingredient_id | uuid          |
| quantity      | numeric(10,2) |
| unit          | varchar(50)   |

## Example

```text
Nasi Goreng

Telur 2 pcs
Nasi 200 gram
Bawang 20 gram
```

---

# 4.7 recipe_steps

Cooking instructions.

## Columns

| Column                     | Type    |
| -------------------------- | ------- |
| id                         | uuid    |
| recipe_id                  | uuid    |
| step_number                | integer |
| instruction                | text    |
| estimated_duration_minutes | integer |

## Example

```text
1. Panaskan minyak
2. Tumis bawang
3. Masukkan telur
```

---

# 4.8 recipe_nutrition

Calculated nutrition result.

## Columns

| Column        | Type          |
| ------------- | ------------- |
| id            | uuid          |
| recipe_id     | uuid          |
| calories      | numeric(10,2) |
| protein       | numeric(10,2) |
| fat           | numeric(10,2) |
| carbohydrates | numeric(10,2) |
| fiber         | numeric(10,2) |
| serving_size  | integer       |
| calculated_at | timestamptz   |

---

# 4.9 recipe_images

Recipe photos.

## Columns

| Column     | Type        |
| ---------- | ----------- |
| id         | uuid        |
| recipe_id  | uuid        |
| image_url  | text        |
| created_at | timestamptz |

---

# 4.10 favorite_recipes

Favorite bookmark.

## Columns

| Column     | Type        |
| ---------- | ----------- |
| id         | uuid        |
| user_id    | uuid        |
| recipe_id  | uuid        |
| created_at | timestamptz |

---

# 5. Relationship Matrix

| Parent      | Child              | Type  |
| ----------- | ------------------ | ----- |
| users       | user_preferences   | 1 : 1 |
| users       | pantry_items       | 1 : N |
| users       | recipes            | 1 : N |
| users       | favorite_recipes   | 1 : N |
| ingredients | pantry_items       | 1 : N |
| ingredients | recipe_ingredients | 1 : N |
| recipes     | recipe_ingredients | 1 : N |
| recipes     | recipe_steps       | 1 : N |
| recipes     | recipe_nutrition   | 1 : 1 |
| recipes     | recipe_images      | 1 : N |

---

# 6. Index Strategy

## ingredients

```sql
CREATE INDEX idx_ingredients_name
ON ingredients(name);
```

---

## pantry_items

```sql
CREATE INDEX idx_pantry_user
ON pantry_items(user_id);

CREATE INDEX idx_pantry_expired
ON pantry_items(expired_at);
```

---

## recipes

```sql
CREATE INDEX idx_recipe_user
ON recipes(user_id);

CREATE INDEX idx_recipe_title
ON recipes(title);
```

---

## favorite_recipes

```sql
CREATE INDEX idx_favorite_user
ON favorite_recipes(user_id);
```

---

# 7. Row Level Security (RLS)

All user-owned tables must enforce:

```sql
user_id = auth.uid()
```

Tables:

* user_preferences
* pantry_items
* recipes
* favorite_recipes

---

# 8. Future Tables (V2)

## ai_conversations

AI chat history.

```sql
id uuid
user_id uuid

role varchar
message text

created_at timestamptz
```

---

## shopping_lists

Generated grocery list.

```sql
id uuid
user_id uuid

name varchar

created_at timestamptz
```

---

## shopping_list_items

```sql
id uuid

shopping_list_id uuid
ingredient_id uuid

quantity numeric
unit varchar
```

---

## meal_plans

Weekly planning.

```sql
id uuid

user_id uuid
plan_date date

recipe_id uuid
meal_type varchar
```

---

# 9. Naming Convention

## Table

snake_case

```text
recipe_steps
recipe_nutrition
favorite_recipes
```

## Column

snake_case

```text
created_at
updated_at
user_id
```

---

# 10. Migration Strategy

Versioned migrations.

```text
001_create_users.sql

002_create_ingredients.sql

003_create_pantry.sql

004_create_recipes.sql

005_create_nutrition.sql
```

Never modify historical migration files.

Always create new migration files.

---

# 11. MVP Database Scope

Tables required for release:

* users
* user_preferences
* ingredients
* pantry_items
* recipes
* recipe_ingredients
* recipe_steps
* recipe_nutrition
* recipe_images
* favorite_recipes

Everything else belongs to future releases.
