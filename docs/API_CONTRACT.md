# API Contract Specification

# Masakanku - AI Kitchen Assistant

Version: 1.0

Status: Proposed

API Style: REST

Authentication: Bearer JWT

Content-Type: application/json

---

# 1. API Standards

## Base URL

```text
/api/v1
```

---

## Authentication Header

```http
Authorization: Bearer <jwt_token>
```

---

## Success Response

```json
{
  "success": true,
  "data": {}
}
```

---

## Error Response

```json
{
  "success": false,
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Recipe not found"
  }
}
```

---

# 2. Authentication APIs

---

## POST /auth/register

### Request

```json
{
  "email": "user@email.com",
  "password": "password123",
  "full_name": "Hilmi"
}
```

### Response

```json
{
  "success": true,
  "data": {
    "user_id": "uuid"
  }
}
```

---

## POST /auth/login

### Request

```json
{
  "email": "user@email.com",
  "password": "password123"
}
```

### Response

```json
{
  "success": true,
  "data": {
    "access_token": "",
    "refresh_token": "",
    "user": {}
  }
}
```

---

## POST /auth/logout

### Response

```json
{
  "success": true
}
```

---

# 3. Pantry APIs

---

## GET /pantry

### Description

Get all pantry items.

### Response

```json
{
  "success": true,
  "data": [
    {
      "id": "",
      "ingredient_name": "Telur",
      "quantity": 12,
      "unit": "pcs",
      "expired_at": "2026-06-01"
    }
  ]
}
```

---

## POST /pantry

### Request

```json
{
  "ingredient_id": "",
  "quantity": 12,
  "unit": "pcs",
  "expired_at": "2026-06-01"
}
```

### Response

```json
{
  "success": true,
  "data": {
    "id": ""
  }
}
```

---

## PUT /pantry/{id}

### Request

```json
{
  "quantity": 6
}
```

---

## DELETE /pantry/{id}

### Response

```json
{
  "success": true
}
```

---

# 4. Ingredient APIs

---

## GET /ingredients

### Query

```text
?search=telur
```

### Response

```json
{
  "success": true,
  "data": [
    {
      "id": "",
      "name": "Telur"
    }
  ]
}
```

---

# 5. Recipe APIs

---

## GET /recipes

### Query

```text
?page=1
&limit=20
```

### Response

```json
{
  "success": true,
  "data": {
    "items": [],
    "total": 0
  }
}
```

---

## GET /recipes/{id}

### Response

```json
{
  "success": true,
  "data": {
    "id": "",
    "title": "",
    "description": "",
    "servings": 2,
    "cooking_time_minutes": 20,
    "ingredients": [],
    "steps": [],
    "nutrition": {}
  }
}
```

---

## POST /recipes

### Request

```json
{
  "title": "Nasi Goreng",
  "description": "",
  "servings": 2,
  "cooking_time_minutes": 20,
  "ingredients": [],
  "steps": []
}
```

### Response

```json
{
  "success": true,
  "data": {
    "id": ""
  }
}
```

---

## PUT /recipes/{id}

### Request

```json
{
  "title": "Nasi Goreng Spesial"
}
```

---

## DELETE /recipes/{id}

### Response

```json
{
  "success": true
}
```

---

# 6. Favorite APIs

---

## POST /recipes/{id}/favorite

### Response

```json
{
  "success": true
}
```

---

## DELETE /recipes/{id}/favorite

### Response

```json
{
  "success": true
}
```

---

## GET /favorites

### Response

```json
{
  "success": true,
  "data": []
}
```

---

# 7. AI APIs

---

## POST /ai/chat

Single AI endpoint.

---

### Supported Intents

```text
recipe_generation

recipe_modification

ingredient_substitution

cooking_assistant
```

---

# 7.1 Recipe Generation

### Request

```json
{
  "intent": "recipe_generation",
  "payload": {
    "ingredients": [
      "telur",
      "tempe",
      "cabai"
    ],
    "servings": 2,
    "difficulty": "easy",
    "cooking_time_minutes": 20
  }
}
```

---

### Response

```json
{
  "success": true,
  "data": {
    "title": "Tempe Telur Pedas",
    "description": "",
    "servings": 2,
    "cooking_time_minutes": 20,
    "difficulty": "easy",
    "ingredients": [],
    "steps": []
  }
}
```

---

# 7.2 Recipe Modification

### Request

```json
{
  "intent": "recipe_modification",
  "payload": {
    "recipe": {},
    "instruction": "make it more spicy"
  }
}
```

---

### Response

```json
{
  "success": true,
  "data": {
    "title": "",
    "ingredients": [],
    "steps": []
  }
}
```

---

# 7.3 Ingredient Substitution

### Request

```json
{
  "intent": "ingredient_substitution",
  "payload": {
    "ingredient": "santan"
  }
}
```

---

### Response

```json
{
  "success": true,
  "data": {
    "ingredient": "santan",
    "alternatives": [
      "susu evaporasi",
      "krim oat"
    ]
  }
}
```

---

# 7.4 Cooking Assistant

### Request

```json
{
  "intent": "cooking_assistant",
  "payload": {
    "question": "Bagaimana agar tempe tetap renyah?"
  }
}
```

---

### Response

```json
{
  "success": true,
  "data": {
    "answer": "..."
  }
}
```

---

# 8. Recipe Save Flow

Important Decision:

AI-generated recipes are NOT automatically saved.

---

Flow:

```text
Generate Recipe
       ↓
View Result
       ↓
Save Recipe?
       ↓
YES
       ↓
POST /recipes
```

---

# 9. Pagination Standard

Request

```text
?page=1
&limit=20
```

Response

```json
{
  "items": [],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "total_pages": 5
  }
}
```

---

# 10. Error Codes

| Code                  | Description        |
| --------------------- | ------------------ |
| UNAUTHORIZED          | Invalid token      |
| FORBIDDEN             | No access          |
| VALIDATION_ERROR      | Invalid request    |
| RESOURCE_NOT_FOUND    | Data not found     |
| AI_TIMEOUT            | AI request timeout |
| AI_INVALID_RESPONSE   | Invalid AI output  |
| INTERNAL_SERVER_ERROR | Unknown error      |

---

# 11. MVP API Scope

Required APIs:

* Authentication
* Pantry
* Ingredients
* Recipes
* Favorites
* AI Chat

Everything else belongs to future releases.

```
```
