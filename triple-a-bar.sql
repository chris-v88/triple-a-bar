-- Run this script connected to the triple_a_bar database.
-- To create the database, run once: CREATE DATABASE triple_a_bar;
-- To connect in psql:               \c triple_a_bar

-- =====================================================================
-- DROP TABLES (reverse dependency order; CASCADE cleans up FKs)
-- =====================================================================
DROP TABLE IF EXISTS "DrinkTasteNotes"  CASCADE;
DROP TABLE IF EXISTS "DrinkIngredients" CASCADE;
DROP TABLE IF EXISTS "Drinks"           CASCADE;
DROP TABLE IF EXISTS "Bottles"          CASCADE;
DROP TABLE IF EXISTS "Brands"           CASCADE;
DROP TABLE IF EXISTS "Ingredients"      CASCADE;
DROP TABLE IF EXISTS "TasteNotes"       CASCADE;
DROP TABLE IF EXISTS "Glass"            CASCADE;
DROP TABLE IF EXISTS "SpiritCategories" CASCADE;
DROP TABLE IF EXISTS "SpiritTypes"      CASCADE;

-- =====================================================================
-- REFERENCE TABLES
-- =====================================================================

CREATE TABLE "SpiritTypes" (
    "id"   SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE "Glass" (
    "id"   SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL UNIQUE
);

-- Predefined taste descriptors, sourced from online guides (e.g. Difford's, Liquor.com)
CREATE TABLE "TasteNotes" (
    "id"   SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL UNIQUE
);

-- =====================================================================
-- BRAND & BOTTLE TABLES
-- =====================================================================

CREATE TABLE "Brands" (
    "id"   SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL UNIQUE
);

-- A Bottle is a specific product from a Brand in a SpiritCategory
CREATE TABLE "Bottles" (
    "id"          SERIAL PRIMARY KEY,
    "brand_id"    INT NOT NULL REFERENCES "Brands"("id"),
    "category_id" INT NOT NULL REFERENCES "SpiritTypes"("id"),
    "name"        VARCHAR(255) NOT NULL,
    "abv"         DECIMAL(5,2),
    "proof"       DECIMAL(5,2)
);

-- =====================================================================
-- INGREDIENT TABLE
-- Covers all drink components: spirits, mixers, juices, syrups, etc.
-- If the ingredient is a specific bottled spirit, bottle_id links to Bottles.
-- =====================================================================

CREATE TABLE "Ingredients" (
    "id"        SERIAL PRIMARY KEY,
    "name"      VARCHAR(255) NOT NULL UNIQUE,
    "bottle_id" INT REFERENCES "Bottles"("id")  -- NULL for non-spirit ingredients
);

-- =====================================================================
-- DRINK TABLES
-- =====================================================================

CREATE TABLE "Drinks" (
    "id"       SERIAL PRIMARY KEY,
    "name"     VARCHAR(255) NOT NULL,
    "glass_id" INT NOT NULL REFERENCES "Glass"("id"),
    "method"   TEXT NOT NULL,
    "garnish"  TEXT
);

-- Links each Drink to its Ingredients, with quantity, unit, and display order
CREATE TABLE "DrinkIngredients" (
    "id"            SERIAL PRIMARY KEY,
    "drink_id"      INT NOT NULL REFERENCES "Drinks"("id"),
    "ingredient_id" INT NOT NULL REFERENCES "Ingredients"("id"),
    "quantity"      DECIMAL(6,2),           -- NULL = "fill" / "to taste"
    "unit"          VARCHAR(50),            -- oz, ml, dashes, leaves, etc.
    "note"          VARCHAR(255),           -- e.g. 'float', 'optional', 'rinse glass'
    "sort_order"    INT NOT NULL DEFAULT 0
);

-- Taste tags per drink, sourced from online descriptions
CREATE TABLE "DrinkTasteNotes" (
    "drink_id"      INT NOT NULL REFERENCES "Drinks"("id"),
    "taste_note_id" INT NOT NULL REFERENCES "TasteNotes"("id"),
    "source"        VARCHAR(255),           -- e.g. 'Difford''s Guide', 'Liquor.com'
    PRIMARY KEY ("drink_id", "taste_note_id")
);

-- =====================================================================
-- REFERENCE DATA
-- =====================================================================

INSERT INTO "SpiritTypes" ("name") VALUES
('Whiskey'),   -- 1
('Vodka'),     -- 2
('Rum'),       -- 3
('Tequila'),   -- 4
('Gin'),       -- 5
('Brandy'),    -- 6
('Liqueur'),   -- 7
('Schnapps'),          -- 8
('Scotch'),            -- 9
('Beer/Malt'),         -- 10
('Bourbon'),           -- 11
('American Whiskey'),  -- 12
('Irish Whiskey'),     -- 13
('Canadian Whiskey'),  -- 14
('Cognac'),            -- 15
('Sparkling Wine');    -- 16

INSERT INTO "Glass" ("name") VALUES
('Highball'),           -- 1
('Rocks'),              -- 2
('Old Fashioned'),      -- 3
('Pint'),               -- 4
('Collins'),            -- 5
('Footed Mug'),         -- 6
('Champagne - Tulip'),  -- 7
('Champagne - Flute'),  -- 8
('Champagne - Saucer'), -- 9
('Cocktail'),           -- 10
('Fishbowl'),           -- 11
('Margarita'),          -- 12
('Brandy Snifter'),     -- 13
('Shot Glass'),         -- 14
('Hurricane'),          -- 15
('Wine - Sherry'),      -- 16
('Wine - House'),       -- 17
('Wine - Red'),         -- 18
('Wine - White'),       -- 19
('Wine - Carafe'),      -- 20
('Wine - Decanter');    -- 21

INSERT INTO "TasteNotes" ("name") VALUES
('Sweet'),    -- 1
('Sour'),     -- 2
('Bitter'),   -- 3
('Salty'),    -- 4
('Smoky'),    -- 5
('Spicy'),    -- 6
('Herbal'),   -- 7
('Fruity'),   -- 8
('Citrusy'),  -- 9
('Floral'),   -- 10
('Earthy'),   -- 11
('Creamy'),   -- 12
('Dry');      -- 13

-- =====================================================================
-- BRANDS
-- =====================================================================

INSERT INTO "Brands" ("name") VALUES
('Maker''s Mark'),      -- 1
('Bacardi'),            -- 2
('Jose Cuervo'),        -- 3
('Cointreau'),          -- 4
('Captain Morgan'),     -- 5
('Seagram''s'),         -- 6
('Malibu'),             -- 7
('Kahlúa'),             -- 8
('Baileys'),            -- 9
('Peachtree'),          -- 10  (DeKuyper Peach Schnapps)
('Midori'),             -- 11
('Chambord'),           -- 12
('Crown Royal'),        -- 13
('DeKuyper'),           -- 14  (Apple Pucker, Blue Curacao, Triple Sec, Melon, Banana, Butterscotch, Crème de Cacao, Blackberry)
('Grand Marnier'),      -- 15
('Drambuie'),           -- 16
('Campari'),            -- 17
('Jack Daniel''s'),     -- 18
('Amaretto di Saronno'),-- 19
('Noilly Prat'),        -- 20  (Dry Vermouth)
('Martini & Rossi'),    -- 21  (Sweet Vermouth)
('Meyers''s'),          -- 22  (Dark Rum)
('Hendrick''s'),        -- 23  (Gin)
('Absolut'),            -- 24  (Vodka)
('Smirnoff'),           -- 25  (Vodka)
('Olmeca'),             -- 26  (Gold Tequila)
('E&J'),                -- 27  (Brandy)
('Ketel One'),             -- 28  (Vodka - Vanilla)
('Prosecco House'),        -- 29
-- Vodka
('Tito''s Handmade Vodka'),-- 30
('Belvedere'),             -- 31
('Three Olives'),          -- 32
('Finlandia'),             -- 33
('Grey Goose'),            -- 34
('Skyy'),                  -- 35
('Stolichnaya'),           -- 36
('Cîroc'),                 -- 37
-- Bourbon
('Heaven Hill'),           -- 38
('Jim Beam'),              -- 39
('Knob Creek'),            -- 40
('Old Grand-Dad'),         -- 41
('Pappy Van Winkle'),      -- 42
('Wild Turkey'),           -- 43
-- Gin
('Beefeater'),             -- 44
('Bombay'),                -- 45
('Tanqueray'),             -- 46
('Gordon''s'),             -- 47
-- Scotch
('Chivas Regal'),          -- 48
('Cutty Sark'),            -- 49
('Dewar''s'),              -- 50
('Glenfiddich'),           -- 51
('Glenlivet'),             -- 52
('Glenmorangie'),          -- 53
('J & B'),                 -- 54
('Johnnie Walker'),        -- 55
('Macallan'),              -- 56
-- Brandy
('Christian Brothers'),    -- 57
('Coronet'),               -- 58
('Paul Masson'),           -- 59
('Metaxa'),                -- 60
-- Rum
('Appleton Estate'),       -- 61
('Cruzan'),                -- 62
('Mount Gay'),             -- 63
-- Irish Whiskey
('Jameson'),               -- 64
('Bushmills'),             -- 65
('Tullamore Dew'),         -- 66
-- Cognac
('Courvoisier'),           -- 67
('D''Ussé'),               -- 68
('Hennessy'),              -- 69
('Martell'),               -- 70
('Rémy Martin'),           -- 71
-- Tequila
('Cabo Wabo'),             -- 72
('Casamigos'),             -- 73
('Don Julio'),             -- 74
('1800 Tequila'),          -- 75
('Patrón'),                -- 76
('Sauza'),                 -- 77
-- Canadian Whiskey
('Canadian Club'),         -- 78
('Windsor'),               -- 79
-- New specialty brands
('Blackhaus'),             -- 80
('Fireball'),              -- 81
('RumChata'),              -- 82
('Jägermeister'),          -- 83
('Aperol'),                -- 84
('Moët & Chandon');        -- 85

-- =====================================================================
-- BOTTLES
-- =====================================================================
-- category_id: 1=Whiskey,2=Vodka,3=Rum,4=Tequila,5=Gin,6=Brandy,7=Liqueur,8=Schnapps,9=Scotch,10=Beer/Malt

INSERT INTO "Bottles" ("brand_id", "category_id", "name", "abv", "proof") VALUES
-- Whiskey variants (Bourbon / American / Canadian / Scotch)
(1,  11, 'Maker''s Mark Bourbon',          45.00,  90.00),  -- 1
(6,  12, 'Seagram''s 7 Crown Whiskey',     40.00,  80.00),  -- 2
(13, 14, 'Crown Royal Canadian Whisky',    40.00,  80.00),  -- 3
(18, 12, 'Jack Daniel''s Old No.7',        40.00,  80.00),  -- 4
(9,  9, 'Laphroaig 10yr Scotch',           40.00,  80.00),  -- 5  (using Baileys slot -- fix: Scotch brand needed; generic stand-in)
-- Vodka
(24, 2, 'Absolut Vodka',                   40.00,  80.00),  -- 6
(25, 2, 'Smirnoff No.21 Vodka',            37.50,  75.00),  -- 7
(28, 2, 'Ketel One Botanical Vodka',       40.00,  80.00),  -- 8
-- Rum
(2,  3, 'Bacardi Superior White Rum',      40.00,  80.00),  -- 9
(5,  3, 'Captain Morgan Original Spiced',  35.00,  70.00),  -- 10
(7,  3, 'Malibu Coconut Rum',              21.00,  42.00),  -- 11
(22, 3, 'Myers''s Dark Rum',               40.00,  80.00),  -- 12
-- Tequila
(3,  4, 'Jose Cuervo Especial Silver',     40.00,  80.00),  -- 13
(26, 4, 'Olmeca Gold Tequila',             38.00,  76.00),  -- 14
-- Gin
(23, 5, 'Hendrick''s Gin',                 41.40,  82.80),  -- 15
-- Brandy
(27, 6, 'E&J VS Brandy',                   40.00,  80.00),  -- 16
-- Liqueurs & Cordials
(4,  7, 'Cointreau Orange Liqueur',        40.00,  80.00),  -- 17
(8,  7, 'Kahlúa Coffee Liqueur',           20.00,  40.00),  -- 18
(9,  7, 'Baileys Irish Cream',             17.00,  34.00),  -- 19
(11, 7, 'Midori Melon Liqueur',            20.00,  40.00),  -- 20
(12, 7, 'Chambord Black Raspberry',        16.50,  33.00),  -- 21
(15, 7, 'Grand Marnier Cordon Rouge',      40.00,  80.00),  -- 22
(16, 7, 'Drambuie Scotch Liqueur',         40.00,  80.00),  -- 23
(17, 7, 'Campari Aperitivo',               24.00,  48.00),  -- 24
(19, 7, 'Amaretto di Saronno',             28.00,  56.00),  -- 25
(14, 7, 'DeKuyper Triple Sec',             30.00,  60.00),  -- 26
(14, 7, 'DeKuyper Blue Curacao',           30.00,  60.00),  -- 27
(14, 7, 'DeKuyper Apple Pucker',           15.00,  30.00),  -- 28
(14, 7, 'DeKuyper Melon Cordial',          15.00,  30.00),  -- 29
(14, 7, 'DeKuyper Banana Cordial',         15.00,  30.00),  -- 30
(14, 7, 'DeKuyper Blackberry Brandy',      24.00,  48.00),  -- 31
(14, 7, 'DeKuyper Butterscotch Schnapps',  15.00,  30.00),  -- 32
(14, 7, 'DeKuyper Brown Crème de Cacao',   25.00,  50.00),  -- 33
-- Schnapps
(10, 8, 'DeKuyper Peach Schnapps',         15.00,  30.00),  -- 34
-- Vermouth
(20, 7, 'Noilly Prat Dry Vermouth',        18.00,  36.00),  -- 35
(21, 7, 'Martini & Rossi Sweet Vermouth',  15.00,  30.00),  -- 36
-- Prosecco
(29, 16, 'Prosecco',                             11.00,  22.00),  -- 37
-- =====================================================================
-- EXPANDED BOTTLE CATALOG
-- =====================================================================
-- Vodka (category_id = 2)
(30, 2,  'Tito''s Handmade Vodka',               40.00,  80.00),  -- 38
(31, 2,  'Belvedere Vodka',                       40.00,  80.00),  -- 39
(32, 2,  'Three Olives Vodka',                    40.00,  80.00),  -- 40
(33, 2,  'Finlandia Vodka',                       40.00,  80.00),  -- 41
(34, 2,  'Grey Goose Vodka',                      40.00,  80.00),  -- 42
(35, 2,  'Skyy Vodka',                            40.00,  80.00),  -- 43
(36, 2,  'Stolichnaya Vodka',                     40.00,  80.00),  -- 44
(37, 2,  'Cîroc Vodka',                           40.00,  80.00),  -- 45
-- Bourbon (category_id = 11)
(38, 11, 'Heaven Hill Kentucky Straight Bourbon', 40.00,  80.00),  -- 46
(39, 11, 'Jim Beam White Bourbon',                40.00,  80.00),  -- 47
(40, 11, 'Knob Creek Kentucky Straight Bourbon',  50.00, 100.00),  -- 48
(41, 11, 'Old Grand-Dad Bourbon',                 43.00,  86.00),  -- 49
(42, 11, 'Pappy Van Winkle''s Family Reserve 15yr',53.50,107.00),  -- 50
(43, 11, 'Wild Turkey 101 Bourbon',               50.50, 101.00),  -- 51
-- American Whiskey (category_id = 12)
(18, 12, 'Gentleman Jack Tennessee Whiskey',      40.00,  80.00),  -- 52
-- Gin (category_id = 5)
(44, 5,  'Beefeater London Dry Gin',              40.00,  80.00),  -- 53
(45, 5,  'Bombay Sapphire Gin',                   47.00,  94.00),  -- 54
(46, 5,  'Tanqueray London Dry Gin',              47.30,  94.60),  -- 55
(47, 5,  'Gordon''s London Dry Gin',              37.50,  75.00),  -- 56
-- Scotch (category_id = 9)
(48, 9,  'Chivas Regal 12yr Blended Scotch',      40.00,  80.00),  -- 57
(49, 9,  'Cutty Sark Blended Scotch',             40.00,  80.00),  -- 58
(50, 9,  'Dewar''s White Label Scotch',           40.00,  80.00),  -- 59
(51, 9,  'Glenfiddich 12yr Single Malt',          40.00,  80.00),  -- 60
(52, 9,  'Glenlivet 12yr Single Malt',            40.00,  80.00),  -- 61
(53, 9,  'Glenmorangie 10yr Single Malt',         40.00,  80.00),  -- 62
(54, 9,  'J & B Rare Scotch',                     40.00,  80.00),  -- 63
(55, 9,  'Johnnie Walker Red Label',              40.00,  80.00),  -- 64
(55, 9,  'Johnnie Walker Black Label',            40.00,  80.00),  -- 65
(55, 9,  'Johnnie Walker Gold Label Reserve',     40.00,  80.00),  -- 66
(55, 9,  'Johnnie Walker Blue Label',             43.80,  87.60),  -- 67
(56, 9,  'Macallan 12yr Single Malt',             40.00,  80.00),  -- 68
-- Brandy (category_id = 6)
(57, 6,  'Christian Brothers VS Brandy',          40.00,  80.00),  -- 69
(58, 6,  'Coronet VSQ Brandy',                    40.00,  80.00),  -- 70
(59, 6,  'Paul Masson Grande Amber VS',           40.00,  80.00),  -- 71
(60, 6,  'Metaxa 5 Star Brandy',                  38.00,  76.00),  -- 72
-- Rum (category_id = 3)
(61, 3,  'Appleton Estate Signature Rum',         40.00,  80.00),  -- 73
(62, 3,  'Cruzan Estate Light Rum',               40.00,  80.00),  -- 74
(63, 3,  'Mount Gay Eclipse Rum',                 40.00,  80.00),  -- 75
-- Irish Whiskey (category_id = 13)
(64, 13, 'Jameson Irish Whiskey',                 40.00,  80.00),  -- 76
(65, 13, 'Bushmills Original Irish Whiskey',      40.00,  80.00),  -- 77
(66, 13, 'Tullamore Dew Irish Whiskey',           40.00,  80.00),  -- 78
-- Cognac (category_id = 15)
(67, 15, 'Courvoisier VS Cognac',                 40.00,  80.00),  -- 79
(68, 15, 'D''Ussé VSOP Cognac',                   43.00,  86.00),  -- 80
(69, 15, 'Hennessy VS Cognac',                    40.00,  80.00),  -- 81
(70, 15, 'Martell VS Cognac',                     40.00,  80.00),  -- 82
(71, 15, 'Rémy Martin VSOP Cognac',               40.00,  80.00),  -- 83
-- Tequila (category_id = 4)
(3,  4,  'Jose Cuervo Especial Gold Tequila',     40.00,  80.00),  -- 84
(72, 4,  'Cabo Wabo Blanco Tequila',              40.00,  80.00),  -- 85
(73, 4,  'Casamigos Blanco Tequila',              40.00,  80.00),  -- 86
(74, 4,  'Don Julio Blanco Tequila',              40.00,  80.00),  -- 87
(75, 4,  '1800 Silver Tequila',                   40.00,  80.00),  -- 88
(76, 4,  'Patrón Silver Tequila',                 40.00,  80.00),  -- 89
(77, 4,  'Sauza Silver Tequila',                  40.00,  80.00),  -- 90
-- Canadian Whiskey (category_id = 14)
(78, 14, 'Canadian Club Classic Whisky',          40.00,  80.00),  -- 91
(6,  14, 'Seagram''s V.O. Canadian Whisky',       40.00,  80.00),  -- 92
(79, 14, 'Windsor Canadian Whisky',               40.00,  80.00),  -- 93
-- Specialty Liqueurs / Schnapps for new drinks
(80, 8,  'Blackhaus Blackberry Schnapps',         15.00,  30.00),  -- 94
(81, 7,  'Fireball Cinnamon Whisky',              33.00,  66.00),  -- 95
(82, 7,  'RumChata Cream Liqueur',                13.75,  27.50),  -- 96
(83, 7,  'J\u00e4germeister Herbal Liqueur',          35.00,  70.00),  -- 97
(84, 7,  'Aperol Aperitivo',                      11.00,  22.00),  -- 98
(14, 7,  'DeKuyper Green Cr\u00e8me de Menthe',        24.00,  48.00),  -- 99
(14, 7,  'DeKuyper White Cr\u00e8me de Cacao',         24.00,  48.00),  -- 100
-- Champagne
(85, 16, 'Mo\u00ebt & Chandon Brut Imp\u00e9rial',         12.00,  24.00),  -- 101
-- Flavored Vodkas (Three Olives)
(32, 2,  'Three Olives Grape Vodka',              35.00,  70.00),  -- 102
(32, 2,  'Three Olives Cherry Vodka',             35.00,  70.00);  -- 103

-- =====================================================================
-- INGREDIENTS
-- Non-spirit: bottle_id = NULL
-- Spirit shorthand (generic): links to the most common bottle
-- =====================================================================

INSERT INTO "Ingredients" ("name", "bottle_id") VALUES
-- Generic spirit shorthands (point to canonical bottle)
('Vodka',                  6),   -- 1  → Absolut
('Gin',                    15),  -- 2  → Hendrick's
('Light Rum',              9),   -- 3  → Bacardi Superior
('Dark Rum',               12),  -- 4  → Myers's
('Tequila',                13),  -- 5  → Jose Cuervo Silver
('Gold Tequila',           14),  -- 6  → Olmeca Gold
('Bourbon',                1),   -- 7  → Maker's Mark
('Whiskey',                1),   -- 8  → Maker's Mark
('Scotch',                 5),   -- 9  → Laphroaig
('Brandy',                 16),  -- 10 → E&J VS
('Coconut Rum',            11),  -- 11 → Malibu
('Orange Vodka',           8),   -- 12 → Ketel One Botanical (stand-in)
('Vanilla Vodka',          8),   -- 13 → Ketel One Botanical (stand-in)
-- Named spirits / liqueurs
('Captain Morgan Spiced Rum', 10),  -- 14
('Seagram''s 7 Whiskey',     2),   -- 15
('Malibu Coconut Rum',        11),  -- 16
('Kahlúa',                    18),  -- 17
('Baileys Irish Cream',        19),  -- 18
('Midori',                    20),  -- 19
('Chambord',                  21),  -- 20
('Grand Marnier',              22),  -- 21
('Drambuie',                  23),  -- 22
('Campari',                   24),  -- 23
('Amaretto',                  25),  -- 24
('Cointreau',                 17),  -- 25
('Triple Sec',                26),  -- 26
('Blue Curacao',               27),  -- 27
('Apple Pucker / Apple Schnapps', 28), -- 28
('Melon Cordial',             29),  -- 29
('Banana Cordial',            30),  -- 30
('Blackberry Brandy',         31),  -- 31
('Butterscotch Schnapps',     32),  -- 32
('Brown Crème de Cacao',      33),  -- 33
('Peach Schnapps',            34),  -- 34
('Dry Vermouth',              35),  -- 35
('Sweet Vermouth',            36),  -- 36
('Prosecco',                  37),  -- 37
('Crown Royal',               3),   -- 38
('Jack Daniel''s',            4),   -- 39
-- Mixers / juices / modifiers (no bottle link)
('Ginger Ale',             NULL),  -- 40
('Red Bull',               NULL),  -- 41
('Tonic Water',            NULL),  -- 42
('Coke',                   NULL),  -- 43
('7-Up',                   NULL),  -- 44
('Cranberry Juice',        NULL),  -- 45
('Grapefruit Juice',       NULL),  -- 46
('Pineapple Juice',        NULL),  -- 47
('Orange Juice',           NULL),  -- 48
('Lime Juice',             NULL),  -- 49
('Sour Mix',               NULL),  -- 50
('Simple Syrup',           NULL),  -- 51
('Lime Syrup',             NULL),  -- 52
('Grenadine',              NULL),  -- 53
('Club Soda',              NULL),  -- 54
('Ginger Beer',            NULL),  -- 55
('Cream / Half & Half',    NULL),  -- 56
('Angostura Bitters',      NULL),  -- 57
('Fresh Mint Leaves',      NULL),  -- 58
('Ice Tea',                NULL),  -- 59
('Lemonade',               NULL),  -- 60
('Bloody Mary Mix',        NULL),  -- 61
('Espresso',               NULL),  -- 62
('Olive Juice',            NULL),  -- 63
('Sprite',                 NULL),  -- 64
('Salt',                   NULL),  -- 65
('Orange Slice',           NULL),  -- 66
('Cherry',                 NULL),  -- 67
('Cocktail Onion',         NULL),  -- 68
('Soda Water',             NULL);  -- 69

-- New spirit / liqueur ingredients
('Grape Vodka',            102),  -- 70 → Three Olives Grape
('Jameson',                76),   -- 71 → Jameson Irish Whiskey
('Green Crème de Menthe',  99),   -- 72 → DeKuyper Green
('White Crème de Cacao',   100),  -- 73 → DeKuyper White
('Blackhaus',              94),   -- 74 → Blackhaus Blackberry Schnapps
('Fireball',               95),   -- 75 → Fireball Cinnamon Whisky
('RumChata',               96),   -- 76 → RumChata Cream Liqueur
('Jägermeister',           97),   -- 77 → Jägermeister
('Cherry Vodka',           103),  -- 78 → Three Olives Cherry
-- New mixers / modifiers
('Pickle Juice',           NULL), -- 79
('Aperol',                 98),   -- 80 → Aperol Aperitivo
('Champagne',              101),  -- 81 → Moët & Chandon
('Whipped Cream',          NULL); -- 82

-- =====================================================================
-- DRINKS
-- glass_id: 1=Highball,2=Rocks,3=Old Fashioned,4=Pint,5=Collins,10=Cocktail,12=Margarita
-- =====================================================================

INSERT INTO "Drinks" ("name", "glass_id", "method", "garnish") VALUES
-- HIGHBALL DRINKS
('Highball',              1, 'On ice',                                    NULL),                           -- 1
('Vodka & Red Bull',      1, 'On ice',                                    NULL),                           -- 2
('Vodka & Tonic',         1, 'On ice',                                    'Lime'),                         -- 3
('Gin & Tonic',           1, 'On ice',                                    'Lime'),                         -- 4
('Captain & Coke',        1, 'On ice',                                    'Lime'),                         -- 5
('7 & 7',                 1, 'On ice',                                    NULL),                           -- 6
('Cape Codder',           1, 'On ice',                                    'Lime'),                         -- 7
('Sea Breeze',            1, 'On ice',                                    NULL),                           -- 8
('Bay Breeze',            1, 'On ice',                                    NULL),                           -- 9
('Madras',                1, 'On ice',                                    NULL),                           -- 10
('Malibu Bay Breeze',     1, 'On ice',                                    NULL),                           -- 11
('Salty Dog',             1, 'On ice',                                    'Salt Rim'),                     -- 12
('Greyhound',             1, 'On ice',                                    NULL),                           -- 13
('Screwdriver',           1, 'On ice',                                    NULL),                           -- 14
('Tequila Sunrise',       1, 'On ice',                                    NULL),                           -- 15
('Paloma',                1, 'On ice',                                    NULL),                           -- 16
('Kahlúa & Cream',        1, 'On ice',                                    NULL),                           -- 17
('Fuzzy Navel',           1, 'On ice',                                    NULL),                           -- 18
('Toasted Almond',        1, 'On ice',                                    NULL),                           -- 19
('Melon Ball',            1, 'On ice',                                    NULL),                           -- 20
('Woo Woo',               1, 'On ice',                                    NULL),                           -- 21
('Kool-Aid',              1, 'On ice',                                    NULL),                           -- 22
('Iced Tea',              1, 'On ice',                                    'Lemon'),                        -- 23
('John Daly',             1, 'On ice',                                    'Lemon'),                        -- 24
('Bloody Mary',           1, 'On ice',                                    'Lime, celery, salt rim'),       -- 25
('Dark & Stormy',         1, 'On ice',                                    'Lime'),                         -- 26
('Moscow Mule',           1, 'On ice',                                    'Lime'),                         -- 27
('Whiskey Sour',          1, 'One Ice',                                   'Flag'),                         -- 28
('Amaretto Sour',         1, 'One Ice',                                   'Flag'),                         -- 29
('Midori Sour',           1, 'One Ice',                                   'Flag'),                         -- 30
-- COCKTAIL GLASS (Shake & Strain)
('Martini',               10,'Shake & Strain / On Ice',                   'Olive/Lemon Twist'),            -- 31
('Dry Martini',           10,'Shake & Strain / On Ice',                   'Olive/Lemon Twist'),            -- 32
('Extra Dry Martini',     10,'Shake & Strain / On Ice',                   'Olive/ Lemon Twist'),           -- 33
('Gibson Martini',        10,'Shake & Strain / On Ice',                   'Cocktail Onion'),               -- 34
('Dirty Martini',         10,'Shake & Strain / On Ice',                   'Olive'),                        -- 35
('In and Out Martini',    10,'Shake & Strain / On Ice',                   'Olive/Lemon Twist'),            -- 36
('Manhattan',             10,'Shake & Strain / On Ice',                   'Cherry'),                       -- 37
('Dry Manhattan',         10,'Shake & Strain / On Ice',                   'Lemon Twist'),                  -- 38
('Perfect Manhattan',     10,'Shake & Strain / On Ice',                   'Cherry/Lemon Twist'),           -- 39
('Rob Roy',               10,'Shake & Strain / On Ice',                   'Cherry'),                       -- 40
('Dry Rob Roy',           10,'Shake & Strain / On Ice',                   'Lemon Twist'),                  -- 41
('Perfect Rob Roy',       10,'Shake & Strain / On Ice',                   'Cherry/Lemon Twist'),           -- 42
('Appletini',             10,'Shake & Strain',                            'Cherry'),                       -- 43
('Cosmopolitan',          10,'Shake & Strain',                            'Lime'),                         -- 44
('Chocolate Martini',     10,'Shake & Strain',                            'Chocolate'),                    -- 45
('Espresso Martini',      10,'Shake & Strain',                            'Espresso Beans'),               -- 46
('Lemon Drop Martini',    10,'Shake & Strain',                            'Sugar Rim & Lemon'),            -- 47
('Melontini',             10,'Shake & Strain',                            'Flag'),                         -- 48
('Washington Apple',      10,'Shake & Strain',                            'Cherry'),                       -- 49
('French Martini',        10,'Shake & Strain',                            NULL),                           -- 50
('Sidecar',               10,'Shake & Strain',                            'Sugar Rim'),                    -- 51
('Traditional Daiquiri',  10,'Shake & Strain',                            'Lime'),                         -- 52
-- MARGARITA GLASS
('Margarita',             12,'Shake & Strain / On Ice / Blend',           'Lime, Salt/Sugar Rim (optional)'), -- 53
('Blue Margarita',        12,'Shake & Strain / On Ice / Blend',           'Lime, Salt/Sugar Rim (optional)'), -- 54
('Golden Margarita',      12,'Shake & Strain/One Ice/ Blend',             'Lime, Salt/Sugar Rim (optional)'), -- 55
('Perfect Margarita',     12,'Shake & Strain / On ice / Blend',           'Lime, Salt/Sugar Rim (optional)'), -- 56
-- PINT / COLLINS
('Tom Collins',           5, 'One Ice & Shake',                           'Flag'),                         -- 57
('Blue Hawaiian',         4, 'One Ice & Shake',                           'Flag'),                         -- 58
('Rum Runner',            4, 'One Ice & Shake',                           'Flag'),                         -- 59
('Sex on the Beach',      4, 'One Ice & Shake',                           'Flag'),                         -- 60
('Bahama Mama',           4, 'One Ice & Shake',                           'Flag'),                         -- 61
('Hurricane',             4, 'One Ice & Shake',                           'Flag'),                         -- 62
('Lynchburg Lemonade',    4, 'One Ice & Shake',                           'Lemon'),                        -- 63
('Long Island Iced Tea',  4, 'One Ice & Shake',                           'Lemon'),                        -- 64
('Blue Long Island',      4, 'One Ice & Shake',                           'Lemon'),                        -- 65
('Irish Trash Can',       4, 'One Ice, Dump Red bull can and all into glass', NULL),                      -- 66
('Mojito',                4, 'Slap mint, Muddle mint, Sugar, and Lime, Add ice, liquid ingredients & Shake', 'Lime & Mint'), -- 67
('Orange Crush',          4, 'Muddle orange slice & Sugar. Add ice, liquid ingredient & Shake', 'Orange Slice'), -- 68
-- ROCKS GLASS
('Old Fashioned',         2, 'Muddle fruit, sugar & bitters. Add ice, liquor & Soda or water', NULL),     -- 69
('Gimlet',                2, 'On Ice',                                    'Lime'),                         -- 70
('Buttery Nipple',        2, 'On Ice',                                    NULL),                           -- 71
('Black Russian',         2, 'On Ice',                                    NULL),                           -- 72
('White Russian',         2, 'On Ice',                                    NULL),                           -- 73
('Rusty Nail',            2, 'On Ice',                                    NULL),                           -- 74
('Godfather',             2, 'On Ice',                                    NULL),                           -- 75
('Godmother',             2, 'On Ice',                                    NULL),                           -- 76
('Negroni',               2, 'On Ice',                                    'Orange Twist'),                 -- 77
('Negroni Sbagliato',     2, 'On Ice',                                    'Orange Twist'),                -- 78
-- BRANDY SNIFTER
('Snifter Drink',         13,'Straight/Neat',                             NULL),                           -- 79
-- SHOT GLASS
('Blow Job',              14,'Layer in the order listed',                 'Whipped Cream'),                 -- 80
-- ROCKS — SHAKE & STRAIN SHOTS/COCKTAILS
('Kamikaze',              2, 'Shake & Strain',                            'Lime'),                          -- 81
('Grape Gatorade',        2, 'Shake & Strain',                            NULL),                            -- 82
('Green Tea',             2, 'Shake & Strain',                            NULL),                            -- 83
('White Tea',             2, 'Shake & Strain',                            NULL),                            -- 84
('Lemon Drop',            2, 'Shake & Strain',                            'Sugar & Lemon'),                 -- 85
('Jolly Rancher',         2, 'Shake & Strain',                            NULL),                            -- 86
('Swedish Fish',          2, 'Shake & Strain',                            NULL),                            -- 87
('Cinnamon Toast Crunch', 2, 'Shake & Strain',                            NULL),                            -- 88
-- ROCKS — BOMB SHOTS
('Skittle Bomb',          2, 'Guest drops shot into Red Bull',            NULL),                            -- 89
('Jager Bomb',            2, 'Guest drops shot into Red Bull',            NULL),                            -- 90
('Cherry Bomb',           2, 'Guest drops shot into Red Bull',            NULL),                            -- 91
-- ROCKS — MORE SHAKE & STRAIN
('Dirty Girl Scout',      2, 'Shake & Strain',                            NULL),                            -- 92
('White Gummy Bear',      2, 'Shake & Strain',                            NULL),                            -- 93
-- ROCKS — STRAIGHT/NEAT
('Pickle Back',           2, 'Straight/Neat',                             NULL),                            -- 94
-- COCKTAIL GLASS
('Grasshopper',           10,'Shake & Strain / Blend',                   NULL),                            -- 95
('Brandy Alexander',      10,'Shake & Strain / Blend',                   NULL),                            -- 96
('Mudslide',              10,'Shake & Strain / Blend',                   'Chocolate Drizzle'),             -- 97
-- WINE GLASS
('Aperol Spritz',         17,'On Ice',                                    'Orange'),                        -- 98
-- CHAMPAGNE TULIP
('Mimosa',                7, 'Build',                                     'Orange');                        -- 99

-- =====================================================================
-- DRINK INGREDIENTS
-- quantity NULL = "fill to top" or "to taste"
-- =====================================================================

INSERT INTO "DrinkIngredients" ("drink_id", "ingredient_id", "quantity", "unit", "note", "sort_order") VALUES
-- 1 Highball
(1,  8,  1.00, 'oz',  NULL,       1),  -- Whiskey
(1,  40, NULL, NULL,  'fill',     2),  -- Ginger Ale
-- 2 Vodka & Red Bull
(2,  1,  1.00, 'oz',  NULL,       1),  -- Vodka
(2,  41, NULL, NULL,  'fill',     2),  -- Red Bull
-- 3 Vodka & Tonic
(3,  1,  1.00, 'oz',  NULL,       1),  -- Vodka
(3,  42, NULL, NULL,  'fill',     2),  -- Tonic Water
-- 4 Gin & Tonic
(4,  2,  1.00, 'oz',  NULL,       1),  -- Gin
(4,  42, NULL, NULL,  'fill',     2),  -- Tonic Water
-- 5 Captain & Coke
(5,  14, 1.00, 'oz',  NULL,       1),  -- Captain Morgan
(5,  43, NULL, NULL,  'fill',     2),  -- Coke
-- 6 7 & 7
(6,  15, 1.00, 'oz',  NULL,       1),  -- Seagram's 7
(6,  44, NULL, NULL,  'fill',     2),  -- 7-Up
-- 7 Cape Codder
(7,  1,  1.00, 'oz',  NULL,       1),  -- Vodka
(7,  45, NULL, NULL,  'fill',     2),  -- Cranberry Juice
-- 8 Sea Breeze
(8,  1,  1.00, 'oz',  NULL,       1),  -- Vodka
(8,  45, NULL, NULL,  'fill',     2),  -- Cranberry Juice
(8,  46, NULL, NULL,  'splash',   3),  -- Grapefruit Juice
-- 9 Bay Breeze
(9,  1,  1.00, 'oz',  NULL,       1),  -- Vodka
(9,  45, NULL, NULL,  'fill',     2),  -- Cranberry Juice
(9,  47, NULL, NULL,  'splash',   3),  -- Pineapple Juice
-- 10 Madras
(10, 1,  1.00, 'oz',  NULL,       1),  -- Vodka
(10, 45, NULL, NULL,  'fill',     2),  -- Cranberry Juice
(10, 48, NULL, NULL,  'splash',   3),  -- Orange Juice
-- 11 Malibu Bay Breeze
(11, 16, 1.00, 'oz',  NULL,       1),  -- Malibu
(11, 45, NULL, NULL,  'fill',     2),  -- Cranberry Juice
(11, 47, NULL, NULL,  'splash',   3),  -- Pineapple Juice
-- 12 Salty Dog
(12, 1,  1.00, 'oz',  NULL,       1),  -- Vodka
(12, 46, NULL, NULL,  'fill',     2),  -- Grapefruit Juice
-- 13 Greyhound
(13, 1,  1.00, 'oz',  NULL,       1),  -- Vodka
(13, 46, NULL, NULL,  'fill',     2),  -- Grapefruit Juice
-- 14 Screwdriver
(14, 1,  1.00, 'oz',  NULL,       1),  -- Vodka
(14, 48, NULL, NULL,  'fill',     2),  -- Orange Juice
-- 15 Tequila Sunrise
(15, 5,  1.00, 'oz',  NULL,       1),  -- Tequila
(15, 48, NULL, NULL,  'fill',     2),  -- Orange Juice
(15, 53, NULL, NULL,  'float',    3),  -- Grenadine
-- 16 Paloma
(16, 5,  1.00, 'oz',  NULL,       1),  -- Tequila
(16, 46, NULL, NULL,  'fill',     2),  -- Grapefruit Juice
(16, 54, NULL, NULL,  'splash',   3),  -- Club Soda
-- 17 Kahlúa & Cream
(17, 17, 1.00, 'oz',  NULL,       1),  -- Kahlúa
(17, 56, NULL, NULL,  'fill',     2),  -- Cream
-- 18 Fuzzy Navel
(18, 34, 1.00, 'oz',  NULL,       1),  -- Peach Schnapps
(18, 48, NULL, NULL,  'fill',     2),  -- Orange Juice
-- 19 Toasted Almond
(19, 17, 0.50, 'oz',  NULL,       1),  -- Kahlúa
(19, 24, 0.50, 'oz',  NULL,       2),  -- Amaretto
(19, 56, NULL, NULL,  'fill',     3),  -- Cream
-- 20 Melon Ball
(20, 1,  0.50, 'oz',  NULL,       1),  -- Vodka
(20, 29, 0.50, 'oz',  NULL,       2),  -- Melon Cordial
(20, 48, NULL, NULL,  'fill',     3),  -- Orange Juice
-- 21 Woo Woo
(21, 1,  0.50, 'oz',  NULL,       1),  -- Vodka
(21, 34, 0.50, 'oz',  NULL,       2),  -- Peach Schnapps
(21, 45, NULL, NULL,  'fill',     3),  -- Cranberry Juice
-- 22 Kool-Aid
(22, 29, 0.50, 'oz',  NULL,       1),  -- Melon Cordial
(22, 24, 0.50, 'oz',  NULL,       2),  -- Amaretto
(22, 45, NULL, NULL,  'fill',     3),  -- Cranberry Juice
-- 23 Iced Tea
(23, 1,  1.00, 'oz',  NULL,       1),  -- Vodka
(23, 59, NULL, NULL,  'fill',     2),  -- Ice Tea
-- 24 John Daly
(24, 1,  1.00, 'oz',  NULL,       1),  -- Vodka
(24, 59, NULL, NULL,  'half fill',2),  -- Ice Tea
(24, 60, NULL, NULL,  'half fill',3),  -- Lemonade
-- 25 Bloody Mary
(25, 1,  1.00, 'oz',  NULL,       1),  -- Vodka
(25, 61, NULL, NULL,  'fill',     2),  -- Bloody Mary Mix
-- 26 Dark & Stormy
(26, 55, NULL, NULL,  'fill',     1),  -- Ginger Beer
(26, 4,  1.00, 'oz',  'float',    2),  -- Dark Rum (Myers's)
-- 27 Moscow Mule
(27, 1,  1.00, 'oz',  NULL,       1),  -- Vodka
(27, 55, NULL, NULL,  'fill',     2),  -- Ginger Beer
-- 28 Whiskey Sour
(28, 8,  1.00, 'oz',  NULL,       1),  -- Whiskey
(28, 50, NULL, NULL,  'fill',     2),  -- Sour Mix
-- 29 Amaretto Sour
(29, 24, 1.00, 'oz',  NULL,       1),  -- Amaretto
(29, 50, NULL, NULL,  'fill',     2),  -- Sour Mix
-- 30 Midori Sour
(30, 19, 1.00, 'oz',  NULL,       1),  -- Midori
(30, 50, NULL, NULL,  'fill',     2),  -- Sour Mix
-- 31 Martini (Vodka or Gin)
(31, 1,  2.00, 'oz',  'vodka or gin', 1),  -- Vodka
(31, 35, 1.00, 'oz',  NULL,           2),  -- Dry Vermouth
-- 32 Dry Martini
(32, 1,  2.00, 'oz',  'vodka or gin', 1),
(32, 35, 0.50, 'oz',  NULL,           2),
-- 33 Extra Dry Martini
(33, 35, NULL, NULL,  'rinse glass, discard', 1),
(33, 1,  2.00, 'oz',  'vodka or gin',         2),
-- 34 Gibson Martini
(34, 1,  2.00, 'oz',  'vodka or gin', 1),
(34, 35, 1.00, 'oz',  NULL,           2),
-- 35 Dirty Martini
(35, 1,  2.00, 'oz',  'vodka or gin', 1),
(35, 35, 0.50, 'oz',  NULL,           2),
(35, 63, 0.50, 'oz',  NULL,           3),  -- Olive Juice
-- 36 In and Out Martini
(36, 35, NULL, NULL,  'rinse glass, discard', 1),
(36, 1,  2.00, 'oz',  'vodka or gin',         2),
-- 37 Manhattan
(37, 8,  2.00, 'oz',  NULL,  1),  -- Whiskey
(37, 36, 1.00, 'oz',  NULL,  2),  -- Sweet Vermouth
(37, 57, 2.00, 'dashes', NULL, 3),  -- Bitters
-- 38 Dry Manhattan
(38, 8,  2.00, 'oz',  NULL,  1),
(38, 35, 1.00, 'oz',  NULL,  2),
(38, 57, 2.00, 'dashes', NULL, 3),
-- 39 Perfect Manhattan
(39, 8,  2.00, 'oz',  NULL,  1),
(39, 35, 0.50, 'oz',  NULL,  2),
(39, 36, 0.50, 'oz',  NULL,  3),
(39, 57, 2.00, 'dashes', NULL, 4),
-- 40 Rob Roy
(40, 9,  2.00, 'oz',  NULL,  1),  -- Scotch
(40, 36, 1.00, 'oz',  NULL,  2),
(40, 57, 2.00, 'dashes', NULL, 3),
-- 41 Dry Rob Roy
(41, 9,  2.00, 'oz',  NULL,  1),
(41, 35, 1.00, 'oz',  NULL,  2),
(41, 57, 2.00, 'dashes', NULL, 3),
-- 42 Perfect Rob Roy
(42, 9,  2.00, 'oz',  NULL,  1),
(42, 35, 0.50, 'oz',  NULL,  2),
(42, 36, 0.50, 'oz',  NULL,  3),
(42, 57, 2.00, 'dashes', NULL, 4),
-- 43 Appletini
(43, 1,  1.50, 'oz',  NULL,       1),  -- Vodka
(43, 28, 0.50, 'oz',  NULL,       2),  -- Apple Pucker
(43, 50, NULL, NULL,  'optional', 3),  -- Sour Mix
-- 44 Cosmopolitan
(44, 1,  1.50, 'oz',  NULL,   1),  -- Vodka
(44, 25, 0.50, 'oz',  NULL,   2),  -- Cointreau
(44, 52, 0.50, 'oz',  NULL,   3),  -- Lime Syrup
(44, 45, NULL, NULL,  'splash',4), -- Cranberry Juice
-- 45 Chocolate Martini
(45, 13, 1.50, 'oz',  NULL,       1),  -- Vanilla Vodka
(45, 33, 0.50, 'oz',  NULL,       2),  -- Brown Crème de Cacao
(45, 18, 0.50, 'oz',  'optional', 3),  -- Baileys
-- 46 Espresso Martini
(46, 1,  1.50, 'oz',  NULL,       1),  -- Vodka
(46, 17, 0.50, 'oz',  NULL,       2),  -- Kahlúa
(46, 62, 1.00, 'oz',  NULL,       3),  -- Espresso
(46, 18, NULL, NULL,  'optional', 4),  -- Baileys
-- 47 Lemon Drop Martini
(47, 1,  1.50, 'oz',  NULL,   1),  -- Vodka
(47, 25, 0.50, 'oz',  NULL,   2),  -- Cointreau
(47, 50, NULL, NULL,  'fill', 3),  -- Sour Mix
-- 48 Melontini
(48, 1,  1.50, 'oz',  NULL,   1),  -- Vodka
(48, 29, 0.50, 'oz',  NULL,   2),  -- Melon Cordial
(48, 47, NULL, NULL,  'fill', 3),  -- Pineapple Juice
-- 49 Washington Apple
(49, 38, 1.50, 'oz',  NULL,   1),  -- Crown Royal
(49, 28, 0.50, 'oz',  NULL,   2),  -- Apple Pucker
(49, 45, NULL, NULL,  'splash',3), -- Cranberry Juice
-- 50 French Martini
(50, 1,  1.50, 'oz',  NULL,   1),  -- Vodka
(50, 20, 0.50, 'oz',  NULL,   2),  -- Chambord
(50, 47, NULL, NULL,  'fill', 3),  -- Pineapple Juice
-- 51 Sidecar
(51, 10, 1.00, 'oz',  NULL,   1),  -- Brandy
(51, 26, 0.50, 'oz',  NULL,   2),  -- Triple Sec
(51, 50, NULL, NULL,  'fill', 3),  -- Sour Mix
-- 52 Traditional Daiquiri
(52, 3,  1.00, 'oz',  NULL,   1),  -- Light Rum
(52, 51, 0.50, 'oz',  NULL,   2),  -- Simple Syrup
(52, 52, 0.50, 'oz',  NULL,   3),  -- Lime Syrup
(52, 50, NULL, NULL,  'fill', 4),  -- Sour Mix
-- 53 Margarita
(53, 5,  1.00, 'oz',  NULL,   1),  -- Tequila
(53, 26, 0.50, 'oz',  NULL,   2),  -- Triple Sec
(53, 52, 0.50, 'oz',  NULL,   3),  -- Lime Syrup
(53, 50, NULL, NULL,  'fill', 4),  -- Sour Mix
-- 54 Blue Margarita
(54, 5,  1.00, 'oz',  NULL,   1),  -- Tequila
(54, 27, 0.50, 'oz',  NULL,   2),  -- Blue Curacao
(54, 52, 0.50, 'oz',  NULL,   3),  -- Lime Syrup
(54, 50, NULL, NULL,  'fill', 4),  -- Sour Mix
-- 55 Golden Margarita
(55, 6,  1.00, 'oz',  NULL,   1),  -- Gold Tequila
(55, 21, 0.50, 'oz',  NULL,   2),  -- Grand Marnier
(55, 52, 0.50, 'oz',  NULL,   3),  -- Lime Syrup
(55, 48, NULL, NULL,  'splash',4), -- Orange Juice
(55, 50, NULL, NULL,  'fill', 5),  -- Sour Mix
-- 56 Perfect Margarita
(56, 5,  1.00, 'oz',  NULL,   1),  -- Tequila
(56, 25, 0.50, 'oz',  NULL,   2),  -- Cointreau
(56, 52, 0.50, 'oz',  NULL,   3),  -- Lime Syrup
(56, 50, NULL, NULL,  'fill', 4),  -- Sour Mix
-- 57 Tom Collins
(57, 2,  1.00, 'oz',  NULL,   1),  -- Gin
(57, 50, NULL, NULL,  'fill', 2),  -- Sour Mix
(57, 54, NULL, NULL,  'top',  3),  -- Club Soda
-- 58 Blue Hawaiian
(58, 3,  1.00, 'oz',  NULL,   1),  -- Light Rum
(58, 27, 0.50, 'oz',  NULL,   2),  -- Blue Curacao
(58, 47, NULL, NULL,  'fill', 3),  -- Pineapple Juice
-- 59 Rum Runner
(59, 31, 0.50, 'oz',  NULL,   1),  -- Blackberry Brandy
(59, 4,  0.50, 'oz',  NULL,   2),  -- Dark Rum
(59, 30, 0.50, 'oz',  NULL,   3),  -- Banana Cordial
(59, 53, 0.50, 'oz',  NULL,   4),  -- Grenadine
(59, 50, NULL, NULL,  'fill', 5),  -- Sour Mix
-- 60 Sex on the Beach
(60, 1,  1.00, 'oz',  NULL,   1),  -- Vodka
(60, 34, 0.50, 'oz',  NULL,   2),  -- Peach Schnapps
(60, 45, NULL, NULL,  'fill', 3),  -- Cranberry Juice
(60, 48, NULL, NULL,  'splash',4), -- Orange Juice
-- 61 Bahama Mama
(61, 4,  1.00, 'oz',  NULL,   1),  -- Dark Rum
(61, 11, 0.50, 'oz',  NULL,   2),  -- Coconut Rum
(61, 53, 0.50, 'oz',  NULL,   3),  -- Grenadine
(61, 48, NULL, NULL,  'splash',4), -- OJ
(61, 47, NULL, NULL,  'fill', 5),  -- Pineapple Juice
-- 62 Hurricane
(62, 3,  1.00, 'oz',  NULL,   1),  -- Light Rum
(62, 4,  1.00, 'oz',  NULL,   2),  -- Dark Rum
(62, 53, 0.50, 'oz',  NULL,   3),  -- Grenadine
(62, 45, NULL, NULL,  'splash',4), -- Cranberry Juice
(62, 47, NULL, NULL,  'fill', 5),  -- Pineapple Juice
(62, 50, NULL, NULL,  'splash',6), -- Sour Mix
-- 63 Lynchburg Lemonade
(63, 39, 1.00, 'oz',  NULL,   1),  -- Jack Daniel's
(63, 26, 0.50, 'oz',  NULL,   2),  -- Triple Sec
(63, 50, NULL, NULL,  'fill', 3),  -- Sour Mix
(63, 54, NULL, NULL,  'top',  4),  -- Club Soda
-- 64 Long Island Iced Tea
(64, 1,  0.50, 'oz',  NULL,   1),  -- Vodka
(64, 2,  0.50, 'oz',  NULL,   2),  -- Gin
(64, 3,  0.50, 'oz',  NULL,   3),  -- Light Rum
(64, 5,  0.50, 'oz',  NULL,   4),  -- Tequila
(64, 26, 0.50, 'oz',  NULL,   5),  -- Triple Sec
(64, 50, NULL, NULL,  'fill', 6),  -- Sour Mix
(64, 43, NULL, NULL,  'top',  7),  -- Coke
-- 65 Blue Long Island
(65, 1,  0.50, 'oz',  NULL,   1),  -- Vodka
(65, 2,  0.50, 'oz',  NULL,   2),  -- Gin
(65, 3,  0.50, 'oz',  NULL,   3),  -- Light Rum
(65, 5,  0.50, 'oz',  NULL,   4),  -- Tequila
(65, 27, 0.50, 'oz',  NULL,   5),  -- Blue Curacao
(65, 50, NULL, NULL,  'fill', 6),  -- Sour Mix
(65, 54, NULL, NULL,  'top',  7),  -- Club Soda
-- 66 Irish Trash Can
(66, 1,  0.50, 'oz',  NULL,   1),  -- Vodka
(66, 2,  0.50, 'oz',  NULL,   2),  -- Gin
(66, 3,  0.50, 'oz',  NULL,   3),  -- Light Rum
(66, 5,  0.50, 'oz',  NULL,   4),  -- Tequila
(66, 27, 0.50, 'oz',  NULL,   5),  -- Blue Curacao
(66, 41, NULL, NULL,  '1 can; drop open can into glass', 6),  -- Red Bull
-- 67 Mojito
(67, 3,  1.00, 'oz',  NULL,   1),  -- Light Rum
(67, 49, NULL, NULL,  'fresh squeezed', 2),  -- Lime Juice
(67, 51, 1.00, 'oz',  NULL,   3),  -- Simple Syrup
(67, 58, 5.00, 'leaves','slap then muddle', 4), -- Mint Leaves
(67, 54, NULL, NULL,  'top',  5),  -- Club Soda
-- 68 Orange Crush
(68, 12, 1.00, 'oz',  NULL,   1),  -- Orange Vodka
(68, 51, 1.00, 'oz',  NULL,   2),  -- Simple Syrup
(68, 66, 1.00, 'slice','muddle', 3),  -- Orange Slice
(68, 48, NULL, NULL,  'fill', 4),  -- Orange Juice
(68, 64, NULL, NULL,  'top',  5),  -- Sprite
-- 69 Old Fashioned
(69, 7,  2.00, 'oz',  NULL,   1),  -- Bourbon
(69, 51, 0.50, 'oz',  NULL,   2),  -- Simple Syrup
(69, 57, 2.00, 'dashes',NULL, 3),  -- Bitters
(69, 67, 1.00, 'each','muddle',4), -- Cherry
(69, 66, 1.00, 'slice','muddle',5),-- Orange Slice
(69, 54, NULL, NULL,  'splash',6), -- Club Soda / Water
-- 70 Gimlet
(70, 1,  1.50, 'oz',  'vodka or gin', 1),
(70, 52, 0.50, 'oz',  NULL,           2),  -- Lime Syrup
-- 71 Buttery Nipple
(71, 17, 1.00, 'oz',  NULL,   1),  -- Kahlúa
(71, 32, 1.00, 'oz',  NULL,   2),  -- Butterscotch Schnapps
(71, 18, NULL, NULL,  'float',3),  -- Baileys
-- 72 Black Russian
(72, 1,  1.50, 'oz',  NULL,   1),  -- Vodka
(72, 17, 0.50, 'oz',  NULL,   2),  -- Kahlúa
-- 73 White Russian
(73, 1,  1.50, 'oz',  NULL,   1),  -- Vodka
(73, 17, 0.50, 'oz',  NULL,   2),  -- Kahlúa
(73, 56, NULL, NULL,  'float',3),  -- Cream
-- 74 Rusty Nail
(74, 9,  1.50, 'oz',  NULL,   1),  -- Scotch
(74, 22, 0.50, 'oz',  NULL,   2),  -- Drambuie
-- 75 Godfather
(75, 9,  1.50, 'oz',  NULL,   1),  -- Scotch
(75, 24, 0.50, 'oz',  NULL,   2),  -- Amaretto
-- 76 Godmother
(76, 1,  1.50, 'oz',  NULL,   1),  -- Vodka
(76, 24, 0.50, 'oz',  NULL,   2),  -- Amaretto
-- 77 Negroni
(77, 2,  1.00, 'oz',  NULL,   1),  -- Gin
(77, 23, 0.50, 'oz',  NULL,   2),  -- Campari
(77, 36, 0.50, 'oz',  NULL,   3),  -- Sweet Vermouth
-- 78 Negroni Sbagliato
(78, 23, 0.50, 'oz',  NULL,   1),  -- Campari
(78, 36, 0.50, 'oz',  NULL,   2),  -- Sweet Vermouth
(78, 37, NULL, NULL,  'top',  3),  -- Prosecco
-- 79 Snifter Drink
(79, 10, 1.50, 'oz',  'any Brandy, Cognac, or Cordial/Liqueur', 1),
-- 80 Blow Job
(80, 17, 0.50, 'oz',  NULL,   1),  -- Kahlúa
(80, 18, 0.50, 'oz',  NULL,   2),  -- Baileys Irish Cream
-- 81 Kamikaze
(81, 1,  0.50, 'oz',  NULL,   1),  -- Vodka
(81, 26, 0.50, 'oz',  NULL,   2),  -- Triple Sec
(81, 52, 0.50, 'oz',  NULL,   3),  -- Lime Syrup
-- 82 Grape Gatorade
(82, 70, 0.50, 'oz',  NULL,      1),  -- Grape Vodka
(82, 20, 0.50, 'oz',  NULL,      2),  -- Chambord
(82, 50, NULL, NULL,  'splash',  3),  -- Sour Mix
(82, 44, NULL, NULL,  'splash',  4),  -- 7-Up
-- 83 Green Tea
(83, 71, 0.50, 'oz',  NULL,      1),  -- Jameson
(83, 34, 0.50, 'oz',  NULL,      2),  -- Peach Schnapps
(83, 50, NULL, NULL,  'splash',  3),  -- Sour Mix
(83, 64, NULL, NULL,  'splash',  4),  -- Sprite
-- 84 White Tea
(84, 1,  0.50, 'oz',  NULL,      1),  -- Vodka
(84, 34, 0.50, 'oz',  NULL,      2),  -- Peach Schnapps
(84, 50, NULL, NULL,  'splash',  3),  -- Sour Mix
(84, 64, NULL, NULL,  'splash',  4),  -- Sprite
-- 85 Lemon Drop
(85, 1,  0.50, 'oz',  NULL,      1),  -- Vodka
(85, 26, 0.50, 'oz',  NULL,      2),  -- Triple Sec
(85, 50, NULL, NULL,  'splash',  3),  -- Sour Mix
-- 86 Jolly Rancher
(86, 19, 0.50, 'oz',  NULL,      1),  -- Midori
(86, 34, 0.50, 'oz',  NULL,      2),  -- Peach Schnapps
(86, 45, NULL, NULL,  'splash',  3),  -- Cranberry Juice
-- 87 Swedish Fish
(87, 74, 1.00, 'oz',  NULL,      1),  -- Blackhaus
(87, 45, NULL, NULL,  'splash',  2),  -- Cranberry Juice
(87, 64, NULL, NULL,  'splash',  3),  -- Sprite
-- 88 Cinnamon Toast Crunch
(88, 75, 1.00, 'oz',  NULL,   1),  -- Fireball
(88, 76, 1.00, 'oz',  NULL,   2),  -- RumChata
-- 89 Skittle Bomb
(89, 41, NULL, NULL,  'half pint', 1),  -- Red Bull
(89, 12, NULL, NULL,  'in shot glass', 2),  -- Orange Vodka
(89, 78, NULL, NULL,  'in shot glass', 3),  -- Cherry Vodka
(89, 70, NULL, NULL,  'in shot glass', 4),  -- Grape Vodka
-- 90 Jager Bomb
(90, 41, NULL, NULL,  'half pint',     1),  -- Red Bull
(90, 77, 1.00, 'oz',  'in shot glass', 2),  -- Jägermeister
-- 91 Cherry Bomb
(91, 41, NULL, NULL,  'half pint',     1),  -- Red Bull
(91, 78, NULL, NULL,  'in shot glass', 2),  -- Cherry Vodka
(91, 53, NULL, NULL,  'splash in shot glass', 3),  -- Grenadine
-- 92 Dirty Girl Scout
(92, 1,  0.50, 'oz',  NULL,   1),  -- Vodka
(92, 72, 0.50, 'oz',  NULL,   2),  -- Green Crème de Menthe
(92, 18, 0.50, 'oz',  NULL,   3),  -- Baileys
-- 93 White Gummy Bear
(93, 78, 0.50, 'oz',  NULL,      1),  -- Cherry Vodka
(93, 34, 0.50, 'oz',  NULL,      2),  -- Peach Schnapps
(93, 50, NULL, NULL,  'splash',  3),  -- Sour Mix
(93, 64, NULL, NULL,  'splash',  4),  -- Sprite
-- 94 Pickle Back
(94, 71, 1.00, 'oz',  NULL,   1),  -- Jameson
(94, 79, 1.00, 'oz',  NULL,   2),  -- Pickle Juice
-- 95 Grasshopper
(95, 72, 0.50, 'oz',  NULL,   1),  -- Green Crème de Menthe
(95, 73, 0.50, 'oz',  NULL,   2),  -- White Crème de Cacao
(95, 56, NULL, NULL,  'fill', 3),  -- Cream
-- 96 Brandy Alexander
(96, 10, 0.50, 'oz',  NULL,   1),  -- Brandy
(96, 33, 0.50, 'oz',  NULL,   2),  -- Brown Crème de Cacao
(96, 56, NULL, NULL,  'fill', 3),  -- Cream
-- 97 Mudslide
(97, 1,  1.00, 'oz',  NULL,   1),  -- Vodka
(97, 17, 0.50, 'oz',  NULL,   2),  -- Kahlúa
(97, 18, 0.50, 'oz',  NULL,   3),  -- Baileys
-- 98 Aperol Spritz
(98, 80, 1.00, 'oz',  NULL,   1),  -- Aperol
(98, 37, 3.00, 'oz',  NULL,   2),  -- Prosecco
(98, 54, NULL, NULL,  'top',  3),  -- Club Soda
-- 99 Mimosa
(99, 81, NULL, NULL,  '3/4 fill', 1),  -- Champagne
(99, 48, NULL, NULL,  'fill',     2);  -- Orange Juice

-- =====================================================================
-- TASTE NOTES (sourced from Difford's Guide & Liquor.com)
-- taste_note_id: 1=Sweet,2=Sour,3=Bitter,4=Salty,5=Smoky,6=Spicy,
--                7=Herbal,8=Fruity,9=Citrusy,10=Floral,12=Creamy,13=Dry
-- =====================================================================

INSERT INTO "DrinkTasteNotes" ("drink_id", "taste_note_id", "source") VALUES
-- Old Fashioned (69)
(69,  1, 'Difford''s Guide'),  -- Sweet
(69,  3, 'Difford''s Guide'),  -- Bitter
(69,  5, 'Liquor.com'),        -- Smoky
(69, 13, 'Liquor.com'),        -- Dry
-- Mojito (67)
(67,  1, 'Difford''s Guide'),  -- Sweet
(67,  2, 'Difford''s Guide'),  -- Sour
(67,  7, 'Liquor.com'),        -- Herbal
(67,  9, 'Liquor.com'),        -- Citrusy
-- Margarita (53)
(53,  2, 'Difford''s Guide'),  -- Sour
(53,  4, 'Liquor.com'),        -- Salty
(53,  9, 'Difford''s Guide'),  -- Citrusy
(53,  3, 'Liquor.com'),        -- Bitter
-- Cosmopolitan (44)
(44,  9, 'Difford''s Guide'),  -- Citrusy
(44,  2, 'Difford''s Guide'),  -- Sour
(44,  8, 'Liquor.com'),        -- Fruity
-- Negroni (77)
(77,  3, 'Difford''s Guide'),  -- Bitter
(77,  7, 'Difford''s Guide'),  -- Herbal
(77,  1, 'Liquor.com'),        -- Sweet
-- Manhattan (37)
(37,  1, 'Difford''s Guide'),  -- Sweet
(37,  3, 'Difford''s Guide'),  -- Bitter
(37, 13, 'Liquor.com'),        -- Dry
-- Moscow Mule (27)
(27,  6, 'Liquor.com'),        -- Spicy
(27,  9, 'Difford''s Guide'),  -- Citrusy
(27,  2, 'Difford''s Guide'),  -- Sour
-- Espresso Martini (46)
(46,  3, 'Difford''s Guide'),  -- Bitter
(46,  1, 'Difford''s Guide'),  -- Sweet
(46, 12, 'Liquor.com');        -- Creamy
