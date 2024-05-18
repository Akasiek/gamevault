#import "@preview/codly:0.2.1": *
#let icon(codepoint) = {
  box(
    height: 0.8em,
    baseline: 0.05em,
    image(codepoint)
  )
  h(0.1em)
}

#show: codly-init.with()
#codly(languages: (
  sql: (name: "SQL", color: rgb("#4d9ddd"), icon: icon("../postgresql_brand.svg")),
))

 
#set text(lang: "pl")
#set page(numbering: "1", margin: (x: 2.5cm, y: 2.5cm))
#set par(justify: true, leading: 0.9em, linebreaks: "optimized")
#set block(spacing: 1.45em, above: 1.3em)

#align(text(smallcaps("POLITECHNIKA RZESZOWSKA"), size: 0.8em), right + top)

#align([
  == Bazy danych - Projekt
  = System zarządzania kolekcją gier planszowych
  === Część 2. Diagram DB i SQL
], center + horizon)


 
#align(grid( 
  columns: (auto, 1fr),
  [#align(text("Data wykonania: 16.05.2024 r.", size: 0.8em), end)],
  [#align(text(smallcaps("Kamil Pomykała L03"), size: 0.8em), end)],
), right + bottom)

#set align(start + top) 

#pagebreak()

= Prezentacja diagramu ERD

Diagram ERD przedstawia strukturę bazy danych, która będzie wykorzystywana w tworzonym projekcie. Zawiera on informacje o encjach, atrybutach oraz relacjach między nimi.

Diagram stworzyłem przy pomocy programu online "dbdiagram.io". Wybór tego narzędzia wynika z mojego wcześniejszego doświadczenia z jego użyciem oraz z użycia języka DBML do tworzenia diagramów. #underline(link("https://dbdiagram.io/d/GameVault-664118429e85a46d55a31d24")[Link do diagramu na dbdiagram.io]).

#figure(image("images/diagram.png", width: 100%), caption: "Diagram ERD bazy danych projektu.")

== Opis tabel i ich funkcji

=== Tabela `Games`

Tabela `Games` jest główną tabelą w bazie danych. Zawiera informacje o grach planszowych, takie jak nazwa, opis, minimalna i maksymalna liczba graczy, średni czas gry oraz kategorie. Kluczem głównym tej tabeli jest `id`, podobnie jak w pozostałych tabelach.

Tabela posiada relacje z tabelami `GameTypes`, `Categories`, `Mechanics`, `GameReleases` oraz `GameReviews`:
- relacja z tabelą `GameTypes` jest typu jeden do wielu, ponieważ jeden typ może być przypisany do wielu gier, ale jedna gra może mieć przypisaną tylko jednego typu. Relacja jest zrealizowana za pomocą klucza obcego `type_id` w tabeli `Games`.
- relacja z tabelą `GameMechanics` jest typu wiele do wielu, ponieważ jedna gra może mieć wiele mechanik, a jedna mechanika może być przypisana do wielu gier. Relacja ta jest zrealizowana za pomocą tabeli pośredniczącej `GameMechanics`.
- relacja z tabelą `Categories` jest typu wiele do wielu, ponieważ jedna gra może być przypisana do wielu kategorii, a jedna kategoria może być przypisana do wielu gier. Relacja ta jest zrealizowana za pomocą tabeli pośredniczącej `GameCategories`.
- relacja z tabelą `GameReleases` jest typu jeden do wielu, ponieważ jedna gra może mieć wiele wydań, ale jedno wydanie może dotyczyć tylko jednej gry. Relacja jest zrealizowana za pomocą klucza obcego `game_id` w tabeli `GameReleases`.
- relacja z tabelą `GameReviews` jest typu jeden do wielu, ponieważ jedna gra może mieć wiele recenzji, ale jedna recenzja dotyczy tylko jednej gry. Relacja jest zrealizowana za pomocą klucza obcego `game_id` w tabeli `GameReviews`.

=== Table `GameTypes`

Tabela `GameTypes` przechowuje informacje o typach gier planszowych. Zawiera jedynie pole `name`, które jest unikalne i służy do identyfikacji typu.

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej.

=== Tabela `Categories`

Tabela `Categories` przechowuje informacje o kategoriach gier planszowych. Zawiera jedynie pole `name`, które jest unikalne i służy do identyfikacji kategorii.

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej.

=== Tabela `Mechanics`

Tabela `Mechanics` przechowuje informacje o mechanikach gier planszowych. Zawiera pola `name` oraz `description`, z których pierwsze jest unikalne i służy do identyfikacji mechaniki.

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej.

=== Tabela asocjacyjna `GameMechanics`

Tabela `GameMechanics` jest tabelą pośredniczącą między tabelami `Games` i `Mechanics`. Zawiera pola `game_id` oraz `mechanic_id`, które są kluczami obcymi do odpowiednich tabel. Te pola tworzą jeden klucz główny tej tabeli, który zachowuje unikalność relacji między grami a mechanikami.

=== Tabela `GameReleases`

Tabela `GameReleases` przechowuje informacje o wydaniach gier planszowych. Zawiera pola `game_id`, `release_date`, `publisher`, `studio`, `language`, `price` oraz `extra_information`. 

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej.

=== Tabela `GameReviews`

Tabela `GameReviews` przechowuje informacje o recenzjach gier planszowych, pisanych przez użytkowników. Zawiera pola `game_id`, `user_id`, `rating` oraz `review`. 

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej oraz relację z tabelą `Users`. Relacja z tabelą `Users` jest typu jeden do wielu, ponieważ jedna recenzja może być napisana przez jednego użytkownika, ale jeden użytkownik może napisać wiele recenzji. Relacja ta jest zrealizowana za pomocą klucza obcego `user_id` w tabeli `GameReviews`.

=== Tabela `Users`

Tabela `Users` przechowuje informacje o użytkownikach kolekcji. Zawiera pola `username`, `email`, `password`, `first_name`, `last_name` oraz `role`, która określa rolę użytkownika w systemie.

Rola może być jedną z dwóch wartości: `USER` lub `ADMIN`. Ten wybór jest zrealizowany za pomocą typu `ENUM`.

Tabela ta posiada relację z tabelą `GameReviews` opisaną wcześniej.

= Zapytania SQL

== Zapytania tworzące tabele

Poniżej znajdują się zapytania SQL tworzące tabele w bazie danych projektu. Zapytania te zawierają definicje tabel, kluczy głównych, kluczy obcych oraz ograniczeń.

```sql
CREATE TYPE "UserRoles" AS ENUM ( 'ADMIN', 'USER' );

CREATE TABLE "Users"
(
    "id"         serial PRIMARY KEY,
    "username"   varchar(255) NOT NULL,
    "email"      varchar(255) NOT NULL,
    "password"   varchar(255) NOT NULL,
    "first_name" varchar(255),
    "last_name"  varchar(255),
    "role"       "UserRoles"  NOT NULL
);

CREATE TABLE "GameTypes"
(
    "id"   serial PRIMARY KEY,
    "name" varchar(255) UNIQUE NOT NULL
);

CREATE TABLE "Games"
(
    "id"                  serial PRIMARY KEY,
    "type_id"             integer      NOT NULL REFERENCES "GameTypes" ("id"),
    "name"                varchar(255) NOT NULL,
    "description"         text,
    "min_players"         integer,
    "max_players"         integer,
    "playing_time"        integer,
    "first_year_released" integer
);

CREATE TABLE "Categories"
(
    "id"   serial PRIMARY KEY,
    "name" varchar(255) UNIQUE NOT NULL
);

CREATE TABLE "GameCategories"
(
    "game_id"     integer NOT NULL REFERENCES "Games" ("id"),
    "category_id" integer NOT NULL REFERENCES "Categories" ("id"),
    CONSTRAINT "pk_game_categories" PRIMARY KEY ("game_id", "category_id")
);

COMMENT ON COLUMN "Games"."playing_time" IS 'Approximate playing time in minutes';

CREATE TABLE "Mechanics"
(
    "id"          serial PRIMARY KEY,
    "name"        varchar(255) UNIQUE NOT NULL,
    "description" text
);

CREATE TABLE "GameMechanics"
(
    "game_id"     integer NOT NULL REFERENCES "Games" ("id"),
    "mechanic_id" integer NOT NULL REFERENCES "Mechanics" ("id"),
    CONSTRAINT "pk_game_mechanics" PRIMARY KEY ("game_id", "mechanic_id")
);

CREATE TABLE "GameReviews"
(
    "id"      serial PRIMARY KEY,
    "game_id" integer NOT NULL REFERENCES "Games" ("id"),
    "user_id" integer NOT NULL REFERENCES "Users" ("id"),
    "rating"  integer NOT NULL,
    "review"  text
);

COMMENT ON COLUMN "GameReviews"."rating" IS 'Rating from 1 to 10';

CREATE TABLE "GameReleases"
(
    "id"                serial PRIMARY KEY,
    "game_id"           integer      NOT NULL REFERENCES "Games" ("id"),
    "release_date"      date         NOT NULL,
    "publisher"         varchar(255) NOT NULL,
    "studio"            varchar(255),
    "language"          varchar(255),
    "price"             decimal(6, 2),
    "extra_information" text
);
```

== Zapytania wprowadzające dane

Poniżej znajdują się zapytania SQL wprowadzające przykładowe dane do tabel.

=== Tabela `GameCategories`

```sql
INSERT INTO "GameTypes" (name) VALUES
    ('Abstract'), ('Area Control'), ('Cooperative'), ('Deck Building'), ('Economic'), ('Family'), ('Party'), ('Thematic'), ('War Games'), ('Strategy');
```

=== Tabela `Games`

```sql
INSERT INTO "Games" (type_id, name, description, min_players, max_players, playing_time, first_year_released) VALUES
    ((SELECT id FROM "GameTypes" WHERE name = 'Abstract'), 'Chess', 'A classic two-player strategy game of capturing the opponent''s king.', 2, 2, 30, 1475),
    ((SELECT id FROM "GameTypes" WHERE name = 'Abstract'), 'Go', 'An abstract strategy game for two players involving surrounding and capturing your opponent''s stones.', 2, 2, 60, -2200),
    ((SELECT id FROM "GameTypes" WHERE name = 'Abstract'), 'Hive', 'An abstract strategy game where players compete to surround the opponent''s queen bee.', 2, 4, 30, 2001),
    ((SELECT id FROM "GameTypes" WHERE name = 'Area Control'), 'Risk', 'A classic board game of world domination through dice rolling and strategic troop placement.', 2, 6, 120, 1957),
    ((SELECT id FROM "GameTypes" WHERE name = 'Area Control'), 'Carcassonne', 'A tile-laying game where players compete to claim land and build features on a growing map.', 2, 5, 45, 2000),
    ((SELECT id FROM "GameTypes" WHERE name = 'Area Control'), 'Twilight Imperium', 'A grand strategy game of galactic conquest and diplomacy for experienced players.', 3, 8, 360, 2000),
    ((SELECT id FROM "GameTypes" WHERE name = 'Cooperative'), 'Pandemic', 'A cooperative game where players work together to stop the spread of diseases around the world.', 2, 4, 45, 2008),
    ((SELECT id FROM "GameTypes" WHERE name = 'Cooperative'), 'Forbidden Island', 'A cooperative game where players work together to recover treasures from a sinking island.', 2, 4, 30, 2010),
    ((SELECT id FROM "GameTypes" WHERE name = 'Cooperative'), 'Spirit Island', 'A cooperative game where players take on the roles of powerful spirits defending their island from colonizers.', 1, 4, 90, 2017),
    ((SELECT id FROM "GameTypes" WHERE name = 'Deck Building'), 'Dominion', 'The original deck-building game where players compete to build the most efficient deck of cards.', 2, 4, 30, 2008),
    ((SELECT id FROM "GameTypes" WHERE name = 'Deck Building'), 'Star Realms', 'A fast-paced deck-building game set in space where players battle for control of the galaxy.', 2, 6, 20, 2014),
    ((SELECT id FROM "GameTypes" WHERE name = 'Deck Building'), 'Clank!', 'A deck-building adventure game where players explore a dungeon, collect treasure, and avoid the dragon.', 2, 4, 60, 2016),
    ((SELECT id FROM "GameTypes" WHERE name = 'Economic'), 'Acquire', 'A classic economic game where players invest in and merge companies to earn the most money.', 2, 6, 90, 1964),
    ((SELECT id FROM "GameTypes" WHERE name = 'Economic'), 'Power Grid', 'A strategic economic game where players compete to power the most cities and earn the most money.', 2, 6, 120, 2004),
    ((SELECT id FROM "GameTypes" WHERE name = 'Economic'), 'Food Chain Magnate', 'A cutthroat economic game where players run competing fast food chains and try to outmaneuver their rivals.', 2, 5, 180, 2015),
    ((SELECT id FROM "GameTypes" WHERE name = 'Family'), 'Ticket to Ride', 'A family-friendly game of building train routes across North America.', 2, 5, 45, 2004),
    ((SELECT id FROM "GameTypes" WHERE name = 'Family'), 'Dixit', 'A creative storytelling game where players interpret abstract illustrations and try to match each other''s descriptions.', 3, 6, 30, 2008),
    ((SELECT id FROM "GameTypes" WHERE name = 'Family'), 'Everdell', 'A charming game of building a woodland critter village and attracting adorable critters to live there.', 1, 4, 80, 2018),
    ((SELECT id FROM "GameTypes" WHERE name = 'Family'), 'Scrabble', 'A classic word game where players compete to create words and earn points based on letter values.', 2, 4, 90, 1938),
    ((SELECT id FROM "GameTypes" WHERE name = 'Party'), 'Codenames', 'A word association game where players give one-word clues to help their teammates guess the correct words.', 4, 8, 15, 2015),
    ((SELECT id FROM "GameTypes" WHERE name = 'Party'), 'Telestrations', 'A drawing and guessing game where players pass around sketchbooks and try to interpret each other''s drawings.', 4, 12, 30, 2009),
    ((SELECT id FROM "GameTypes" WHERE name = 'Party'), 'Just One', 'A cooperative party game where players try to guess a word based on one-word clues, but duplicate clues are eliminated.', 3, 7, 20, 2018),
    ((SELECT id FROM "GameTypes" WHERE name = 'Thematic'), 'Arkham Horror', 'A cooperative game of cosmic horror where players investigate mysteries and battle otherworldly monsters.', 1, 8, 240, 1987),
    ((SELECT id FROM "GameTypes" WHERE name = 'Thematic'), 'Gloomhaven', 'A cooperative campaign game of tactical combat and exploration in a dark fantasy world.', 1, 4, 120, 2017),
    ((SELECT id FROM "GameTypes" WHERE name = 'Thematic'), 'Malhya: Lands of Legends', 'A narrative-driven adventure game set in a rich fantasy world with branching storylines and epic quests.', 1, 5, 180, 2024),
    ((SELECT id FROM "GameTypes" WHERE name = 'War Games'), 'Axis & Allies', 'A classic World War II strategy game of global conflict and military strategy.', 2, 5, 180, 1981),
    ((SELECT id FROM "GameTypes" WHERE name = 'War Games'), 'Twilight Struggle', 'A two-player game of Cold War politics and strategy where players compete for global influence.', 2, 2, 180, 2005),
    ((SELECT id FROM "GameTypes" WHERE name = 'War Games'), 'Root', 'A strategic war game of woodland creatures vying for control of the forest and its resources.', 2, 4, 90, 2018),
    ((SELECT id FROM "GameTypes" WHERE name = 'Strategy'), 'Terraforming Mars', 'A strategic game of colonizing and terraforming Mars to make it habitable for human life.', 1, 5, 120, 2016),
    ((SELECT id FROM "GameTypes" WHERE name = 'Strategy'), 'Scythe', 'A strategic game of farming, combat, and resource management set in an alternate history 1920s Europe.', 1, 7, 115, 2016),
    ((SELECT id FROM "GameTypes" WHERE name = 'Strategy'), 'The Castles of Burgundy: Special Edition', 'A strategic game of building and developing a medieval estate through tile placement and resource management.', 1, 4, 90, 2023),
    ((SELECT id FROM "GameTypes" WHERE name = 'Strategy'), 'Catan', 'A classic board game of trading and building settlements on the island of Catan.', 3, 4, 90, 1995);
```

=== Tabele `Categories` i `GameCategories`

```sql
INSERT INTO "Categories" (name) VALUES
    ('Word Games'), ('Spies/Secret Agents'), ('Humor'), ('Fantasy'), ('Science Fiction'), ('Adventure'), ('Novel-based'), ('Horror'), ('Territory Building'), ('Medieval');

INSERT INTO "GameCategories" (game_id, category_id) VALUES
    ((SELECT id FROM "Games" WHERE name = 'Codenames'), (SELECT id FROM "Categories" WHERE name = 'Word Games')),
    ((SELECT id FROM "Games" WHERE name = 'Codenames'), (SELECT id FROM "Categories" WHERE name = 'Spies/Secret Agents')),
    ((SELECT id FROM "Games" WHERE name = 'Telestrations'), (SELECT id FROM "Categories" WHERE name = 'Humor')),
    ((SELECT id FROM "Games" WHERE name = 'Gloomhaven'), (SELECT id FROM "Categories" WHERE name = 'Fantasy')),
    ((SELECT id FROM "Games" WHERE name = 'Gloomhaven'), (SELECT id FROM "Categories" WHERE name = 'Adventure')),
    ((SELECT id FROM "Games" WHERE name = 'Spirit Island'), (SELECT id FROM "Categories" WHERE name = 'Fantasy')),
    ((SELECT id FROM "Games" WHERE name = 'Clank!'), (SELECT id FROM "Categories" WHERE name = 'Fantasy')),
    ((SELECT id FROM "Games" WHERE name = 'Arkham Horror'), (SELECT id FROM "Categories" WHERE name = 'Horror')),
    ((SELECT id FROM "Games" WHERE name = 'Arkham Horror'), (SELECT id FROM "Categories" WHERE name = 'Adventure')),
    ((SELECT id FROM "Games" WHERE name = 'Arkham Horror'), (SELECT id FROM "Categories" WHERE name = 'Novel-based')),
    ((SELECT id FROM "Games" WHERE name = 'Scythe'), (SELECT id FROM "Categories" WHERE name = 'Science Fiction')),
    ((SELECT id FROM "Games" WHERE name = 'The Castles of Burgundy: Special Edition'), (SELECT id FROM "Categories" WHERE name = 'Medieval')),
    ((SELECT id FROM "Games" WHERE name = 'The Castles of Burgundy: Special Edition'), (SELECT id FROM "Categories" WHERE name = 'Territory Building'));
```

=== Tabele `Mechanics` i `GameMechanics`

```sql
INSERT INTO "Mechanics" (name) VALUES
    ('Tile Placement'), ('Hand Management'), ('Dice Rolling'), ('Team-Based Game'), ('Trading'), ('Memory'), ('Auction/Bidding'), ('Map Addition'), ('Player Elimination'), ('Deck Building'), ('Income'), ('End Game Bonuses');

INSERT INTO "GameMechanics" (game_id, mechanic_id) VALUES
    ((SELECT id FROM "Games" WHERE name = 'Carcassonne'), (SELECT id FROM "Mechanics" WHERE name = 'Tile Placement')),
    ((SELECT id FROM "Games" WHERE name = 'Carcassonne'), (SELECT id FROM "Mechanics" WHERE name = 'Map Addition')),
    ((SELECT id FROM "Games" WHERE name = 'Dominion'), (SELECT id FROM "Mechanics" WHERE name = 'Hand Management')),
    ((SELECT id FROM "Games" WHERE name = 'Dominion'), (SELECT id FROM "Mechanics" WHERE name = 'Deck Building')),
    ((SELECT id FROM "Games" WHERE name = 'Power Grid'), (SELECT id FROM "Mechanics" WHERE name = 'Auction/Bidding')),
    ((SELECT id FROM "Games" WHERE name = 'Root'), (SELECT id FROM "Mechanics" WHERE name = 'Hand Management')),
    ((SELECT id FROM "Games" WHERE name = 'Root'), (SELECT id FROM "Mechanics" WHERE name = 'Dice Rolling')),
    ((SELECT id FROM "Games" WHERE name = 'Everdell'), (SELECT id FROM "Mechanics" WHERE name = 'Hand Management')),
    ((SELECT id FROM "Games" WHERE name = 'Everdell'), (SELECT id FROM "Mechanics" WHERE name = 'Income')),
    ((SELECT id FROM "Games" WHERE name = 'Everdell'), (SELECT id FROM "Mechanics" WHERE name = 'End Game Bonuses')),
    ((SELECT id FROM "Games" WHERE name = 'Scrabble'), (SELECT id FROM "Mechanics" WHERE name = 'Tile Placement')),
    ((SELECT id FROM "Games" WHERE name = 'Scrabble'), (SELECT id FROM "Mechanics" WHERE name = 'Hand Management')),
    ((SELECT id FROM "Games" WHERE name = 'Scrabble'), (SELECT id FROM "Mechanics" WHERE name = 'End Game Bonuses'));
```

=== Tabele `GameReviews` i `Users`

```sql
INSERT INTO "Users" (username, email, password, role) VALUES
    ('admin', '174725@stud.prz.edu.pl', '$2y$10$xjw.5TWX7uzvlWEsyaf6BuRhIXv2M2zWC9NcsIyGVe50DefmQYOEq', 'ADMIN'),
    ('testuser', 'kpomykala2002@gmail.com', '$2y$10$H.5U1jmjzdLY44BecfDp5Ojc2UVI74FaCqaHFMcFix8fez3dhPfsC', 'USER');

INSERT INTO "GameReviews" (game_id, user_id, rating, review) VALUES
    ((SELECT id FROM "Games" WHERE name = 'Carcassonne'), (SELECT id FROM "Users" WHERE username = 'testuser'), 4, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam id consequat lacus. Cras ultricies, nunc molestie placerat tincidunt, enim sapien imperdiet nulla, sit amet tincidunt felis lorem pretium erat.'),
    ((SELECT id FROM "Games" WHERE name = 'Dominion'), (SELECT id FROM "Users" WHERE username = 'testuser'), 5, 'Integer eget ligula nec nisi accumsan dignissim nec eget libero. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut suscipit volutpat odio in tempus. Sed gravida a lectus sed vulputate. Maecenas eget diam a ante consequat consequat et sit amet diam. '),
    ((SELECT id FROM "Games" WHERE name = 'Power Grid'), (SELECT id FROM "Users" WHERE username = 'admin'), 2, 'Morbi porta libero ut nunc fermentum ullamcorper. Nunc nulla ex, iaculis ut sapien vitae, mollis accumsan ex. Etiam varius nisi ut consectetur placerat. Aliquam aliquam vel purus quis ultricies. Phasellus eget metus sit amet erat mollis dapibus nec ac mi. Quisque porta tincidunt sapien eu maximus. Nullam ut dictum ipsum. '),
    ((SELECT id FROM "Games" WHERE name = 'Root'), (SELECT id FROM "Users" WHERE username = 'admin'), 4, null),
    ((SELECT id FROM "Games" WHERE name = 'Root'), (SELECT id FROM "Users" WHERE username = 'testuser'), 5, null),
    ((SELECT id FROM "Games" WHERE name = 'Everdell'), (SELECT id FROM "Users" WHERE username = 'testuser'), 3, null),
    ((SELECT id FROM "Games" WHERE name = 'Scrabble'), (SELECT id FROM "Users" WHERE username = 'admin'), 1, null);
```

=== Tabela `GameReleases`

```sql
INSERT INTO "GameReleases" (game_id, release_date, publisher, studio, language, price, extra_information) VALUES
    ((SELECT id FROM "Games" WHERE name = 'Carcassonne'), '2020-01-01', 'Bard Centrum Gier', 'Bard Centrum Gier', 'Polish', 101.00, null),
    ((SELECT id FROM "Games" WHERE name = 'Catan'), '2023-06-01', 'NeoTroy Games', null, 'Turkish', 150.00, 'Limited edition'),
    ((SELECT id FROM "Games" WHERE name = 'Catan'), '2021-09-10', 'Albi, KOSMOS', 'KOSMOS', 'Czech', 98.21, 'Alternative name: "Catan: Základní hra". Used'),
    ((SELECT id FROM "Games" WHERE name = 'Catan'), '2022-06-30', 'KOSMOS', 'KOSMOS', 'German', 129.99, 'Alternative name: "Catan: Das Spiel"'),
    ((SELECT id FROM "Games" WHERE name = 'Catan'), '2021-01-12', 'Swan Panasia Co., Ltd.', 'KOSMOS', 'Chinese', 150.00, 'Alternative name: "卡坦島". Imported'),
    ((SELECT id FROM "Games" WHERE name = 'Dominion'), '2013-12-12', 'Ystari Games', null, 'French', 80.00, 'Third printing');
```

== Przykładowe zapytania selekcyjne

=== Zapytanie o gry z kategorii "Fantasy"

```sql
SELECT "Games"."name" FROM "Games"
INNER JOIN "GameCategories" ON "Games"."id" = "GameCategories"."game_id"
INNER JOIN "Categories" ON "GameCategories"."category_id" = "Categories"."id"
WHERE "Categories"."name" = 'Fantasy';
```

=== Zapytanie o gry z mechaniką "Hand Management"

```sql
SELECT "Games"."name" FROM "Games"
INNER JOIN "GameMechanics" ON "Games"."id" = "GameMechanics"."game_id"
INNER JOIN "Mechanics" ON "GameMechanics"."mechanic_id" = "Mechanics"."id"
WHERE "Mechanics"."name" = 'Hand Management';
```

=== Zapytanie o gry, które posiadają średnią recenzji powyżej 4

```sql
SELECT "Games"."name", AVG("GameReviews"."rating") AS "average_rating", COUNT("GameReviews"."rating") AS "number_of_ratings" FROM "Games"
RIGHT JOIN "GameReviews" ON "Games"."id" = "GameReviews"."game_id"
GROUP BY "Games"."id"
HAVING AVG("GameReviews"."rating") >= 4;
```

=== Zapytanie o kategorie, które posiadają więcej niż 10, ale mniej niż 20 gier

```sql
SELECT "Categories"."name", COUNT("Games"."id") AS "game_count" FROM "Categories"
INNER JOIN "GameCategories" ON "Categories"."id" = "GameCategories"."category_id"
INNER JOIN "Games" ON "GameCategories"."game_id" = "Games"."id"
GROUP BY "Categories"."id"
HAVING COUNT("Games"."id") > 10 AND COUNT("Games"."id") < 20;
```

=== Zapytanie o użytkowników z rolą "USER" i ilością napisanych recenzji

```sql
SELECT "Users"."username", COUNT("GameReviews"."id") AS "review_count" FROM "Users"
LEFT JOIN "GameReviews" ON "Users"."id" = "GameReviews"."user_id"
WHERE "Users"."role" = 'USER'
GROUP BY "Users"."id";
```

=== Zapytanie o gry wydane po 2010 roku

```sql
SELECT "Games"."name", "Games"."first_year_released" FROM "Games"
WHERE "Games"."first_year_released" > 2010;
```

#pagebreak()
=== Zapytanie o gry, których zsumowana cena wydań przekracza 250 zł

```sql
SELECT "Games"."name", SUM("GameReleases"."price") AS "price_sum", COUNT("GameReleases"."price") AS "number_of_releases" FROM "Games"
INNER JOIN "GameReleases" ON "Games"."id" = "GameReleases"."game_id"
GROUP BY "Games"."id"
HAVING SUM("GameReleases"."price") > 250;
```