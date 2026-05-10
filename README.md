# triple-a-bar
Site for bartending recipes and information

## Challenge

Create a web application that allows users to browse and search for bartending recipes and information.

---

## The 3 Search Modes

| Search | Example | Returns |
|---|---|---|
| By **cocktail name** | "Martini" | Recipe with ingredients + amounts + garnish |
| By **spirit type** | "Vodka" | All cocktails that use vodka + their recipes |
| By **brand/alternative** | "Vodka brands" | All vodka brands with ABV%, proof, taste notes |

---

## Database Entities

### 1. `SpiritCategory` — the type of spirit or liqueur

Split into two categories by **type**:

| Type | Examples |
|---|---|
| `spirit` (hard liquor) | Vodka, Gin, Rum, Whiskey, Tequila, Brandy |
| `liqueur` (cordial) | Triple Sec, Amaretto, Kahlúa, Baileys, Grand Marnier |

> **Difference:** Hard liquors are distilled with little to no added sugar (~40%+ ABV). Liqueurs/cordials are sweetened and flavored, typically 15–30% ABV.

### 2. `Brand` — a specific product of a spirit type
```
Grey Goose (Vodka), Smirnoff (Vodka), Bombay Sapphire (Gin)...
```
- belongs to a `SpiritCategory`
- has ABV %, proof, origin country

### 3. `TastingNote` — crowd-sourced flavor descriptions per brand
```
Brand: Grey Goose → "smooth, slightly sweet, clean finish" ★4.2
```

### 4. `Ingredient` — generic recipe building block
```
"Vodka"        (type: spirit → links to SpiritCategory)
"Dry Vermouth" (type: mixer)
"Olive"        (type: garnish)
"Lemon twist"  (type: garnish)
"Lime juice"   (type: juice)
```
> Recipes use **generic ingredients** (not brands), but a spirit ingredient links to a `SpiritCategory` so searching "vodka" finds all recipes using it.

### 5. `Cocktail` — the drink itself
```
Martini, Highball, Cape Cod, Sea Breeze...
```
- has glass type, description, tags, image

### 6. `CocktailIngredient` — junction table (recipe rows)
```
Martini → 2oz     → Gin (spirit ingredient)
Martini → 1oz     → Dry Vermouth (mixer)
Martini → garnish → Olive OR Lemon Twist
```

### 7. `AlternativeName` — for fuzzy/alias search
```
Martini  → also known as: "Dirty Martini", "Classic Martini"
Cape Cod → also known as: "Cape Codder", "Vodka Cranberry"
```

---

## Relationship Diagram

```
SpiritCategory (Vodka)
   ├── Brand (Grey Goose, Smirnoff)  ←── TastingNote
   └── Ingredient (Vodka, generic)
            └── CocktailIngredient (2oz Vodka)
                     └── Cocktail (Cape Cod)
                               └── AlternativeName (Vodka Cranberry)
```

---

## How Each Search Works

**Search "Martini":**
```
AlternativeName | Cocktail.name → Cocktail → CocktailIngredients → Ingredients
```

**Search "Vodka":**
```
SpiritCategory.name = "Vodka"
  → Ingredient (where spirit_category = Vodka)
    → CocktailIngredient
      → Cocktail (with all its other ingredients for the full recipe)
```

**Search "Vodka brands" / alternatives:**
```
SpiritCategory.name = "Vodka"
  → Brand[]
    → TastingNote[] (ABV, proof, flavor profile)
```

---

## Key Design Decisions

1. **Ingredient ≠ Brand** — recipes always use generic ingredients ("Vodka"), never brand names. Keeps recipes brand-agnostic and lets brand search stay separate.
2. **`spiritCategoryId` on Ingredient is the bridge** — connects "searching for vodka" → "finding cocktails that use vodka".
3. **`AlternativeName` table** — lets you search "Cosmo" and find Cosmopolitan, "Cape Codder" and find Cape Cod, etc.
4. **`TastingNote` is separate from `Brand`** — one brand can have many reviews/sources.
5. **`SpiritCategory.type`** — distinguishes hard liquors (`spirit`) from cordials/liqueurs (`liqueur`), enabling filtered browsing (e.g. "show me only liqueurs" or "what cocktails use cordials").
