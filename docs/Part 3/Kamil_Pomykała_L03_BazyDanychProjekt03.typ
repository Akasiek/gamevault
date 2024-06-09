// Import and init Codly - better codeblocks
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
  rust: (name: "Rust", icon: icon("../rust_brand.svg"), color: rgb("#CE412B")),
))
 
#set text(lang: "pl")
#set page(numbering: "1", margin: (x: 2.5cm, y: 2.5cm))
#set par(justify: true, leading: 0.9em, linebreaks: "optimized")
#set block(spacing: 1.45em, above: 1.3em)
// Set font and color for inline code
#show raw: set text(font: "JetBrains Mono", fill: rgb(20, 46, 27, 255) )
// Change h1 to be centered and uppercase
#show heading.where(level: 1): set align(center);

// Change color of figure's captions
#show figure: set text(fill: rgb(80, 80, 80, 255), style: "italic")



/* --- End of configuration --- */



#align(text(smallcaps("POLITECHNIKA RZESZOWSKA"), size: 0.8em), right + top)

#align([
  == Bazy danych - Projekt
  = System zarządzania kolekcją gier planszowych
  === Części 1., 2. i 3.
], center + horizon)


 
#align(grid( 
  columns: (auto, 1fr),
  [#align(text("Data wykonania: 8.06.2024 r.", size: 0.8em), end)],
  [#align(text(smallcaps("Kamil Pomykała L03"), size: 0.8em), end)],
), right + bottom)

#set align(start + top) 

#pagebreak()

#outline(
  depth: 3,
  indent: 2em
)

#pagebreak()

= #smallcaps([Spotkanie 2.])

== Tematyka i zakres projektu

Projekt skupia się na stworzenie systemu zarządzania kolekcją gier planszowych. Głównym celem projektu jest stworzenie bazy danych, która umożliwi katalogowanie gier planszowych, mechanik tych gier, recenzji oraz historii wydań. 

System pozwala na zarządzanie kolekcją jednej osoby lub grupy domowników. W projekcie zostaną zaimplementowane dwie główne role użytkowników: administratora, który ma pełen dostęp do funkcji systemu, oraz zwykłego użytkownika, który może korzystać z podstawowych funkcji przeglądania bazy gier oraz ma możliwość dodania recenzji. Dzięki takiemu podejściu użytkownicy mogą bez obaw o stratę danych, zarządzać swoją kolekcją gier planszowych.

Projekt nazwałem *"GameVault"*. Nazwa nawiązuje do przechowywania gier w wirtualnym "skarbcu".

=== Zagadnienia związane z tematem

- *Katalogowanie gier*: Należy opracować strukturę bazy danych, która pozwoli na przechowywanie informacji o grach planszowych, takich jak nazwa gry, gatunek, liczba graczy, czas trwania rozgrywki, opis (gdzie powinny znaleźć się dodatkowe informacje o grze). 
- *Mechaniki gier*: System powinien umożliwiać przypisanie mechanik gry do danej gry planszowej. Mechaniki gier to zestaw reguł, które określają sposób rozgrywki. Każda gra może posiadać wiele mechanik.
- *Recenzje gier*: Użytkownicy systemu mogą dodawać recenzje gier planszowych. Recenzje powinny zawierać ocenę gry oraz opis. Każda gra może posiadać wiele recenzji.
- *Historia wydań*: System powinien przechowywać informacje o wydaniach danej gry planszowej. Historia wydań zawiera informacje o dacie wydania, wydawcy, numerze wydania oraz opisie gdzie można znaleźć dodatkowe informacje o wydaniu. Każda gra może posiadać wiele wydań.
- *Role użytkowników*: System powinien umożliwiać zarządzanie rolami użytkowników. Administrator ma pełen dostęp do funkcji systemu, natomiast zwykły użytkownik ma ograniczony dostęp do funkcji systemu.

=== Funkcje bazy danych i ich priorytety

1. *Przechowywanie informacji o grach planszowych*
  - Priorytet: _*Wysoki*_
  - Opis: Najważniejsza funkcjonalność systemu, która umożliwia przechowywanie informacji o grach planszowych. Bez tej funkcjonalności projekt nie ma za dużego sensu.
2. *Przechowywanie informacji o mechanikach gier*
  - Priorytet: _*Średni*_
  - Opis: Funkcjonalność umożliwiająca przypisanie mechanik gry do danej gry planszowej. Dzięki tej funkcjonalności opisy gier stają się bardziej kompleksowe. Każdy użytkownik z dostępem do bazy gier może dowiedzieć się, jakie mechaniki posiada dana gra i podejrzeć je podczas rozgrywki.
#pagebreak()
3. *Przechowywanie informacji o recenzjach gier*
  - Priorytet: _*Średni*_
  - Opis: Funkcjonalność umożliwiająca dodawanie recenzji gier planszowych. Recenzje gier są ważne dla użytkowników, którzy chcą znaleźć informacje zwrotne na temat danej gry. Dzięki tej funkcjonalności użytkownicy mogą dzielić się swoimi opiniami na temat gier planszowych.
4. *Przechowywanie informacji o historii wydań gier*
  - Priorytet: _*Niski*_
  - Opis: Funkcjonalność umożliwiająca przechowywanie informacji o wydaniach danej gry planszowej. Ma najniższy priorytet, ponieważ nie jest to funkcjonalność, która jest niezbędna do działania systemu. Jednakże, dzięki tej funkcjonalności użytkownicy mogą lepiej zarządzać swoją kolekcją gier planszowych.

== Technologie i narzędzia

=== Technologie i rodzaj bazy danych

Projekt zostanie zrealizowany w oparciu o bazę danych *PostgreSQL*. Jest to jeden z najpopularniejszych silników bazodanowych, który oferuje zaawansowane funkcje i możliwości. PostgreSQL jest otwartoźródłowym systemem, co dla mnie - zwolennika takich rozwiązań, jest bardzo ważne. W projekcie wykorzystam wersję _16.2_ PostgreSQL, która podczas pisania tego dokumentu jest najnowszą wersją stabilną. Użyję tego #underline(link("https://hub.docker.com/layers/library/postgres/16.2-alpine/images/sha256-d2ae11f7207eb2c726b1678d7f98df2210759b8e5014d77afa9f77d014e33a9e?context=explore", [obrazu Dockerowego])).

Do obsługi bazy danych posłuży terminalowy *system ORM*. Do jego stworzenia wykorzystam język programowania *Rust*. Wykorzystam też poniższe biblioteki: 
- *Diesel*: ORM dla języka Rust, który umożliwia łatwe zarządzanie bazą danych PostgreSQL.
- *terminal-menu*: Biblioteka do tworzenia menu w terminalu. Umożliwia łatwe zarządzanie interfejsem użytkownika w terminalu.
- *Serde i Serde_json*: Biblioteka do serializacji i deserializacji danych w języku Rust. Umożliwia łatwe przekształcanie danych do formatu JSON.
- *Inne biblioteki*, które mogą okazać się przydatne podczas implementacji systemu.

W projekcie wykorzystam wersję _1.77.2_ języka Rust. Nie jest to najnowsza wersja języka, ale jest to wersja, która jest stabilna i sprawdzona. Program będzie kompilowany do wersji wykonywalnych pod systemy Windows i Linux więc nie jest potrzebny Docker. Podczas implementacji systemu będę korzystał z najnowszych wersji bibliotek, które są dostępne w repozytorium Cargo.

=== Narzędzia

Przygotowanie dokumentacji projektu zostanie zrealizowane w języku *Typst*. Typst to alternatywne narzędzie do LaTeX, które umożliwia tworzenie dokumentacji w sposób tekstowy.

Do stworzenia diagramów ERD użyję narzędzia *dbdiagram.io*. Jest to narzędzie online, które wykorzystywałem już w przeszłości. W szczególności podoba mi się fakt, że diagramy tworzy się w sposób tekstowy. Dzięki temu można skupić się na projektowaniu bazy danych, a nie na rysowaniu diagramów.

#pagebreak()

Lokalne i produkcyjne środowisko projektu zostanie zrealizowane w oparciu o kontenery *Docker* i narzędzie *Docker Compose*. Docker umożliwia łatwe zarządzanie środowiskami deweloperskimi oraz produkcyjnymi. Repozytoria Dockerowe zawierają gotowe obrazy PostgreSQL i Rust, które można zmodyfikować według własnych potrzeb. Docker Compose umożliwia zarządzanie wieloma kontenerami jednocześnie za pomocą jednego pliku konfiguracyjnego `docker-compose.yml`.

Do zarządzania bazą danych użyję narzędzia *DataGrip* firmy *JetBrains*. Jest to zaawansowane narzędzie do zarządzania bazą danych, które oferuje wiele funkcji ułatwiających pracę z bazą danych. JetBrains oferuje darmową licencję dla studentów, co jest dodatkowym atutem tego narzędzia.

Do implementacji systemu ORM wykorzystam środowisko programistyczne *RustRover*. RustRover to nowe IDE firmy JetBrains, które oferuje wiele funkcji ułatwiających pracę z językiem Rust. RustRover oferuje integrację z Cargo, co umożliwia łatwe zarządzanie zależnościami w projekcie.

Wdrożenie projektu końcowego zostanie zrealizowane na platformie *Railway*. Railway umożliwia na łatwe wdrożenie kontenerów Docker na serwerach w chmurze. Ich darmowy plan wystarczy na potrzeby projektu.

Kontrola wersji projektu zostanie zrealizowana za pomocą narzędzia *Git* i platformy *GitHub*. Git umożliwia zarządzanie kodem źródłowym projektu, a GitHub umożliwia przechowywanie kodu źródłowego w chmurze. Repozytorium projektu będzie dostępne publicznie pod #underline(link("https://github.com/Akasiek/gamevault", [tym linkiem])).

#pagebreak()
= #smallcaps([Spotkanie 3.])

== Prezentacja diagramu ERD

Diagram ERD przedstawia strukturę bazy danych, która będzie wykorzystywana w tworzonym projekcie. Zawiera on informacje o encjach, atrybutach oraz relacjach między nimi.

Diagram stworzyłem przy pomocy programu online "dbdiagram.io". Wybór tego narzędzia wynika z mojego wcześniejszego doświadczenia z jego użyciem oraz z użycia języka DBML do tworzenia diagramów. #underline(link("https://dbdiagram.io/d/GameVault-664118429e85a46d55a31d24")[Link do diagramu na dbdiagram.io]).

#figure(image("img/diagram.png", width: 100%), caption: "Diagram ERD bazy danych projektu.")

=== Opis tabel i ich funkcji

==== Tabela `Games`

Tabela `Games` jest główną tabelą w bazie danych. Zawiera informacje o grach planszowych, takie jak nazwa, opis, minimalna i maksymalna liczba graczy, średni czas gry oraz kategorie. Kluczem głównym tej tabeli jest `id`, podobnie jak w pozostałych tabelach.

Tabela posiada relacje z tabelami `GameTypes`, `Categories`, `Mechanics`, `GameReleases` oraz `GameReviews`:
- relacja z tabelą `GameTypes` jest typu jeden do wielu, ponieważ jeden typ może być przypisany do wielu gier, ale jedna gra może mieć przypisaną tylko jednego typu. Relacja jest zrealizowana za pomocą klucza obcego `type_id` w tabeli `Games`.
- relacja z tabelą `GameMechanics` jest typu wiele do wielu, ponieważ jedna gra może mieć wiele mechanik, a jedna mechanika może być przypisana do wielu gier. Relacja ta jest zrealizowana za pomocą tabeli pośredniczącej `GameMechanics`.
- relacja z tabelą `Categories` jest typu wiele do wielu, ponieważ jedna gra może być przypisana do wielu kategorii, a jedna kategoria może być przypisana do wielu gier. Relacja ta jest zrealizowana za pomocą tabeli pośredniczącej `GameCategories`.
- relacja z tabelą `GameReleases` jest typu jeden do wielu, ponieważ jedna gra może mieć wiele wydań, ale jedno wydanie może dotyczyć tylko jednej gry. Relacja jest zrealizowana za pomocą klucza obcego `game_id` w tabeli `GameReleases`.
- relacja z tabelą `GameReviews` jest typu jeden do wielu, ponieważ jedna gra może mieć wiele recenzji, ale jedna recenzja dotyczy tylko jednej gry. Relacja jest zrealizowana za pomocą klucza obcego `game_id` w tabeli `GameReviews`.

==== Table `GameTypes`

Tabela `GameTypes` przechowuje informacje o typach gier planszowych. Zawiera jedynie pole `name`, które jest unikalne i służy do identyfikacji typu.

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej.

==== Tabela `Categories`

Tabela `Categories` przechowuje informacje o kategoriach gier planszowych. Zawiera jedynie pole `name`, które jest unikalne i służy do identyfikacji kategorii.

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej.

==== Tabela `Mechanics`

Tabela `Mechanics` przechowuje informacje o mechanikach gier planszowych. Zawiera pola `name` oraz `description`, z których pierwsze jest unikalne i służy do identyfikacji mechaniki.

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej.

==== Tabela asocjacyjna `GameMechanics`

Tabela `GameMechanics` jest tabelą pośredniczącą między tabelami `Games` i `Mechanics`. Zawiera pola `game_id` oraz `mechanic_id`, które są kluczami obcymi do odpowiednich tabel. Te pola tworzą jeden klucz główny tej tabeli, który zachowuje unikalność relacji między grami a mechanikami.

==== Tabela `GameReleases`

Tabela `GameReleases` przechowuje informacje o wydaniach gier planszowych. Zawiera pola `game_id`, `release_date`, `publisher`, `studio`, `language`, `price` oraz `extra_information`. 

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej.

==== Tabela `GameReviews`

Tabela `GameReviews` przechowuje informacje o recenzjach gier planszowych, pisanych przez użytkowników. Zawiera pola `game_id`, `user_id`, `rating` oraz `review`. 

Tabela ta posiada relację z tabelą `Games` opisaną wcześniej oraz relację z tabelą `Users`. Relacja z tabelą `Users` jest typu jeden do wielu, ponieważ jedna recenzja może być napisana przez jednego użytkownika, ale jeden użytkownik może napisać wiele recenzji. Relacja ta jest zrealizowana za pomocą klucza obcego `user_id` w tabeli `GameReviews`.

==== Tabela `Users`

Tabela `Users` przechowuje informacje o użytkownikach kolekcji. Zawiera pola `username`, `email`, `password`, `first_name`, `last_name` oraz `role`, która określa rolę użytkownika w systemie.

Rola może być jedną z dwóch wartości: `USER` lub `ADMIN`. Ten wybór jest zrealizowany za pomocą typu `ENUM`.

Tabela ta posiada relację z tabelą `GameReviews` opisaną wcześniej.

== Zapytania SQL

=== Zapytania tworzące tabele

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

=== Zapytania wprowadzające dane

Poniżej znajdują się zapytania SQL wprowadzające przykładowe dane do tabel.

==== Tabela `GameCategories`

```sql
INSERT INTO "GameTypes" (name) VALUES
    ('Abstract'), ('Area Control'), ('Cooperative'), ('Deck Building'), ('Economic'), ('Family'), ('Party'), ('Thematic'), ('War Games'), ('Strategy');
```

==== Tabela `Games`

```sql
INSERT INTO "Games" (type_id, name, description, min_players, max_players, playing_time, first_year_released) VALUES
    ((SELECT id FROM "GameTypes" WHERE name = 'Abstract'), 'Chess', 'A classic two-player strategy game of capturing the opponent''s king.', 2, 2, 30, 1475),
    ((SELECT id FROM "GameTypes" WHERE name = 'Abstract'), 'Go', 'An abstract strategy game for two players involving surrounding and capturing your opponent''s stones.', 2, 2, 60, -2200),
    ...
```

==== Tabele `Categories` i `GameCategories`

```sql
INSERT INTO "Categories" (name) VALUES
    ('Word Games'), ('Spies/Secret Agents'), ('Humor'), ('Fantasy'), ('Science Fiction'), ('Adventure'), ('Novel-based'), ('Horror'), ('Territory Building'), ('Medieval');

INSERT INTO "GameCategories" (game_id, category_id) VALUES
    ((SELECT id FROM "Games" WHERE name = 'Codenames'), (SELECT id FROM "Categories" WHERE name = 'Word Games')),
    ((SELECT id FROM "Games" WHERE name = 'Codenames'), (SELECT id FROM "Categories" WHERE name = 'Spies/Secret Agents')),
    ...
```

==== Tabele `Mechanics` i `GameMechanics`

```sql
INSERT INTO "Mechanics" (name) VALUES
    ('Tile Placement'), ('Hand Management'), ('Dice Rolling'), ('Team-Based Game'), ('Trading'), ('Memory'), ('Auction/Bidding'), ('Map Addition'), ('Player Elimination'), ('Deck Building'), ('Income'), ('End Game Bonuses');

INSERT INTO "GameMechanics" (game_id, mechanic_id) VALUES
    ((SELECT id FROM "Games" WHERE name = 'Carcassonne'), (SELECT id FROM "Mechanics" WHERE name = 'Tile Placement')),
    ((SELECT id FROM "Games" WHERE name = 'Carcassonne'), (SELECT id FROM "Mechanics" WHERE name = 'Map Addition')),
    ...
```

==== Tabele `GameReviews` i `Users`

```sql
INSERT INTO "Users" (username, email, password, role) VALUES
    ('admin', '174725@stud.prz.edu.pl', crypt('kamil123', gen_salt('bf', 10)), 'ADMIN'),
    ('testuser', 'kpomykala2002@gmail.com', crypt('test123', gen_salt('bf', 10)), 'USER');

INSERT INTO "GameReviews" (game_id, user_id, rating, review) VALUES
    ((SELECT id FROM "Games" WHERE name = 'Carcassonne'), (SELECT id FROM "Users" WHERE username = 'testuser'), 4, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam id consequat lacus. Cras ultricies, nunc molestie placerat tincidunt, enim sapien imperdiet nulla, sit amet tincidunt felis lorem pretium erat.'),
    ...
```

Funkcje `crypt()` i `gen_salt()` służą do zabezpieczenia haseł użytkowników przed przechowywaniem ich w postaci jawnej w bazie danych. Pochodzą one z rozszerzenia `pgcrypto`, które jest dostępne w PostgreSQL.

==== Tabela `GameReleases`

```sql
INSERT INTO "GameReleases" (game_id, release_date, publisher, studio, language, price, extra_information) VALUES
    ((SELECT id FROM "Games" WHERE name = 'Carcassonne'), '2020-01-01', 'Bard Centrum Gier', 'Bard Centrum Gier', 'Polish', 101.00, null),
    ((SELECT id FROM "Games" WHERE name = 'Catan'), '2023-06-01', 'NeoTroy Games', null, 'Turkish', 150.00, 'Limited edition'),
    ...
```

=== Przykładowe zapytania selekcyjne

==== Zapytanie o gry z kategorii "Fantasy"

```sql
SELECT "Games"."name" FROM "Games"
INNER JOIN "GameCategories" ON "Games"."id" = "GameCategories"."game_id"
INNER JOIN "Categories" ON "GameCategories"."category_id" = "Categories"."id"
WHERE "Categories"."name" = 'Fantasy';
```

==== Zapytanie o gry z mechaniką "Hand Management"

```sql
SELECT "Games"."name" FROM "Games"
INNER JOIN "GameMechanics" ON "Games"."id" = "GameMechanics"."game_id"
INNER JOIN "Mechanics" ON "GameMechanics"."mechanic_id" = "Mechanics"."id"
WHERE "Mechanics"."name" = 'Hand Management';
```

#pagebreak()
==== Zapytanie o gry, które posiadają średnią recenzji powyżej 4

```sql
SELECT "Games"."name", AVG("GameReviews"."rating") AS "average_rating", COUNT("GameReviews"."rating") AS "number_of_ratings" FROM "Games"
RIGHT JOIN "GameReviews" ON "Games"."id" = "GameReviews"."game_id"
GROUP BY "Games"."id"
HAVING AVG("GameReviews"."rating") >= 4;
```

==== Zapytanie o kategorie, które posiadają więcej niż 10, ale mniej niż 20 gier

```sql
SELECT "Categories"."name", COUNT("Games"."id") AS "game_count" FROM "Categories"
INNER JOIN "GameCategories" ON "Categories"."id" = "GameCategories"."category_id"
INNER JOIN "Games" ON "GameCategories"."game_id" = "Games"."id"
GROUP BY "Categories"."id"
HAVING COUNT("Games"."id") > 10 AND COUNT("Games"."id") < 20;
```

==== Zapytanie o użytkowników z rolą "USER" i ilością napisanych recenzji

```sql
SELECT "Users"."username", COUNT("GameReviews"."id") AS "review_count" FROM "Users"
LEFT JOIN "GameReviews" ON "Users"."id" = "GameReviews"."user_id"
WHERE "Users"."role" = 'USER'
GROUP BY "Users"."id";
```

==== Zapytanie o gry wydane po 2010 roku

```sql
SELECT "Games"."name", "Games"."first_year_released" FROM "Games"
WHERE "Games"."first_year_released" > 2010;
```

#pagebreak()
= #smallcaps([Spotkanie 4.])

== Zaawansowane zapytania SQL

=== Dodawanie danych

Zaawansowane dodawanie danych potraktowałem jako dodanie większej ilości danych do tabel w bazie danych. W tym celu przygotowałem kolejny skrypt SQL, który dodaje przykładowe dane. Tym razem postarałem się o zwiększenie ilości danych, aby pokazać jak system zachowuje się przy większej ilości rekordów.

Wcześniejsza iteracja pliku SQL zawierała prawie 100 linijek kodu. Nowy plik zawiera prawie 700 linijek. Widać, że ilość danych znacznie wzrosła.

Po wykonaniu nowego skryptu, w bazie danych znajduję się 130 gier, 35 kategorii gier, 10 typów gier, 33 mechaniki, 54 użytkowników, 53 recenzje oraz 56 wydań gier.

=== Aktualizacja danych

Tutaj potraktowałem frazę "zaawansowany" poważniej i przewidziałem parę różnych przypadków aktualizacji danych, które mogą wystąpić podczas pracy na bazie danych.

==== Powiększenie cen wydań gier w języku niemieckim o 25%
```sql
UPDATE "GameReleases"
SET "price" = "price" * 1.25
WHERE "language" = 'German';
```
==== Zmniejszenie cen wydań gier z mechaniką "Hand Management" o 10%
```sql
UPDATE "GameReleases"
SET "price" = "price" * 0.9
FROM "Games"
        INNER JOIN "GameMechanics" ON "Games"."id" = "GameMechanics"."game_id"
        INNER JOIN "Mechanics" ON "GameMechanics"."mechanic_id" = "Mechanics"."id"
WHERE "Games"."id" = "GameReleases"."game_id"
  AND "Mechanics"."name" = 'Hand Management';
```
==== Zwiększenie cen wydań gier z recenzją o ocenie 4 lub więcej o 15%
```sql
UPDATE "GameReleases"
SET "price" = "price" * 1.15
WHERE "game_id" IN (
  SELECT "game_id"
  FROM "GameReviews"
  WHERE "GameReviews"."rating" >= 4
);
```
#pagebreak()
==== Zmiana roli użytkowników na podstawie ilości recenzji gier. 

Jeśli użytkownik napisał więcej niż 5 recenzji, to zmień jego rolę na "`ADMIN`", w przeciwnym wypadku na "`USER`".

```sql
UPDATE "Users"
SET "role" = CASE
  WHEN (SELECT COUNT(*) FROM "GameReviews" WHERE "Users"."id" = "GameReviews"."user_id") > 5 THEN 'ADMIN'
  ELSE 'USER'
END
FROM "GameReviews"
WHERE "Users"."id" = "GameReviews"."user_id";
```
==== Aktualizacja opisu mechanik.

Jeśli mechanika nie jest używana w żadnej grze, to ustaw opis na "_This mechanic is not used in any game_". W przeciwnym wypadku ustaw opis na "_This mechanic is used in X games and Y game types_". Gdzie _X_ to liczba gier, a _Y_ to liczba typów gier, w których jest używana mechanika.

```sql
UPDATE "Mechanics"
SET "description" =
  CASE
    WHEN (SELECT COUNT(*) FROM "GameMechanics" WHERE "Mechanics"."id" = "GameMechanics"."mechanic_id") = 0 THEN 'This mechanic is not used in any game'
    ELSE
      'This mechanic is used in '
      || (SELECT COUNT(DISTINCT "game_id") FROM "GameMechanics" WHERE "Mechanics"."id" = "GameMechanics"."mechanic_id")
      || ' games and '
      || (SELECT COUNT(DISTINCT "type_id")
          FROM "Games"
          WHERE "Games"."id" IN (SELECT "game_id"
                                  FROM "GameMechanics"
                                  WHERE "Mechanics"."id" = "GameMechanics"."mechanic_id"))
      || ' game types'
  END
WHERE "Mechanics"."description" IS NULL;
```

#pagebreak()
=== Selekcja danych

W przypadku selekcji danych również postanowiłem pokazać kilka bardziej zaawansowanych zapytań, które mogą być przydatne podczas pracy z bazą danych.

==== Zapytanie o gry, których suma cen wydań wynosi ponad 200 zł
```sql
SELECT "Games"."name", SUM("GameReleases"."price") AS "price_sum", COUNT("GameReleases"."price") AS "number_of_releases"
FROM "Games"
INNER JOIN "GameReleases" ON "Games"."id" = "GameReleases"."game_id"
GROUP BY "Games"."id"
HAVING SUM("GameReleases"."price") >= 200;
```

==== Zapytanie o ranking użytkowników na podstawie ilości napisanych recenzji

Z pominięciem użytkowników, którzy nie napisali żadnej recenzji.

```sql
SELECT 
    "Users"."username",
    ROUND(AVG("GameReviews"."rating"), 3) AS "average_rating",
    COUNT("GameReviews"."rating")         AS "number_of_ratings",
    (SELECT "GameReviews"."review"
    FROM "GameReviews"
    WHERE "GameReviews"."user_id" = "Users"."id"
    ORDER BY "GameReviews"."id" DESC
    LIMIT 1)                             AS "latest_review"
FROM "Users"
LEFT JOIN "GameReviews" ON "Users"."id" = "GameReviews"."user_id"
GROUP BY "Users"."id"
HAVING COUNT("GameReviews"."rating") > 0
ORDER BY COUNT("GameReviews"."rating") DESC;
```

#pagebreak()
==== Zapytanie o gry i ich pierwsze, najnowsze wydanie oraz oryginalny rok wydania

```sql
SELECT 
    "Games"."name",
    (SELECT "GameReleases"."release_date"
    FROM "GameReleases"
    WHERE "GameReleases"."game_id" = "Games"."id"
    ORDER BY "GameReleases"."release_date" DESC
    LIMIT 1) AS "latest_release",
    (SELECT "GameReleases"."release_date"
    FROM "GameReleases"
    WHERE "GameReleases"."game_id" = "Games"."id"
    ORDER BY "GameReleases"."release_date" ASC
    LIMIT 1) AS "first_release",
    "Games"."first_year_released"
FROM "Games"
RIGHT JOIN "GameReleases" ON "Games"."id" = "GameReleases"."game_id"
GROUP BY "Games"."id";
```

==== Zapytanie o typy gier oraz ich średnią ilość minimalną i maksymalną graczy

```sql
SELECT
    "GameTypes"."name",
    ROUND(AVG("Games"."min_players"), 2) AS "average_min_players",
    ROUND(AVG("Games"."max_players"), 2) AS "average_max_players"
FROM "GameTypes"
INNER JOIN "Games" ON "GameTypes"."id" = "Games"."type_id"
GROUP BY "GameTypes"."id";
```

==== Zapytanie o kategorie gier, ilość gier, lista gier oraz średnią ocenę gier w danej kategorii

Lista gier to nazwy gier w danej kategorii, oddzielone przecinkami.

```sql
SELECT
    "Categories"."name",
    COUNT("Games"."id")                                        AS "game_count",
    STRING_AGG("Games"."name", ', ')                           AS "game_list",
    (SELECT ROUND(AVG("GameReviews"."rating"), 2)
    FROM "GameReviews"
              INNER JOIN "Games" ON "GameReviews"."game_id" = "Games"."id"
              INNER JOIN "GameCategories" ON "Games"."id" = "GameCategories"."game_id"
    WHERE "GameCategories"."category_id" = "Categories"."id") AS "average_rating"
FROM "Categories"
INNER JOIN "GameCategories" ON "Categories"."id" = "GameCategories"."category_id"
INNER JOIN "Games" ON "GameCategories"."game_id" = "Games"."id"
GROUP BY "Categories"."id";
```

== Role i uprawnienia

PostgreSQL bazuje na modelu ról i uprawnień, które pozwalają na kontrolę dostępu do danych w bazie. We wcześniejszych wersjach PostgreSQL, był podział na użytkowników i grupy, teraz role zastępują oba te pojęcia i pozwalają na bardziej elastyczne zarządzanie dostępem do danych.

W projekcie stworzyłem dwie role bez uprawnień do logowania (wcześniej takie role nazywały się grupami): `user` i `admin`. Rola `user` ma ograniczony dostęp do danych, może przeglądać tabele, dodawać i aktualizować w tabeli `GameReviews`. Rola `admin` ma pełny dostęp do danych, może przeglądać, dodawać, aktualizować i usuwać dane z wszystkich tabel.

```sql
CREATE ROLE admins WITH NOLOGIN;
CREATE ROLE users WITH NOLOGIN;

SET ROLE NONE; -- Reset role to NONE
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admins;
GRANT CREATE ON SCHEMA public TO admins;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO admins;

SET ROLE NONE;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO users;
GRANT INSERT, UPDATE ON "GameReviews" TO users;
GRANT USAGE, SELECT ON "GameReviews_id_seq" TO users;
```

Musiałem dodać uprawnienia do sekwencji, ponieważ kolumny `serial` w PostgreSQL są zaimplementowane za pomocą sekwencji, które są automatycznie tworzone przez bazę danych. Bez tych uprawnień, role nie mogą korzystać z kolumn `serial`.

W tym samym pliku SQL, stworzyłem również role z możliwością logowania (użytkowników), które odpowiadają rekordom z tabeli `Users`.

```sql
-- Create administrators
SET ROLE NONE;
CREATE ROLE admin WITH LOGIN PASSWORD 'kamil123' IN ROLE admins; -- Passwords are always encrypted using sha256
CREATE ROLE brownleopard167 WITH LOGIN PASSWORD 'adriana' IN ROLE admins;
CREATE ROLE brownelephant395 WITH LOGIN PASSWORD 'marianne' IN ROLE admins;
...

-- Create users
SET ROLE NONE;
CREATE ROLE testuser WITH LOGIN PASSWORD 'test123' IN ROLE users;
CREATE ROLE bigdog363 WITH LOGIN PASSWORD 'lespaul' IN ROLE users;
...
```

Hasła można zapisać tutaj bez funkcji `crypt()`, ponieważ PostgreSQL automatycznie je zaszyfruje.

=== Przykładowe zapytania z wykorzystaniem ról

Na samym końcu pliku SQL, dodałem kilka przykładowych zapytań, które potwierdzają poprawne działanie ról i uprawnień.

```sql
-- Example of using the admins group
SET ROLE admin; -- Switch to the admin role

SELECT * FROM "Games";

INSERT INTO "Games" (type_id, name, description, min_players, max_players, playing_time, first_year_released)
VALUES (1, 'Test Game', 'This is a test game', 2, 4, 60, 2019);

UPDATE "Games" SET description = 'This is a test game that has been updated' WHERE name = 'Test Game';

DELETE FROM "Games" WHERE name = 'Test Game';
```

Tutaj wszystkie zapytania powinny zostać wykonane bez problemów, ponieważ rola `admin` ma pełne uprawnienia do wszystkich tabel.

```sql
-- Example of using the users group
SET ROLE testuser; -- Switch to the testuser role

SELECT * FROM "Games";

SELECT * FROM "GameReviews";

INSERT INTO "GameReviews" (game_id, user_id, rating, review)
VALUES ((SELECT id FROM "Games" WHERE name = 'Chess'), (SELECT id FROM "Users" WHERE username = 'testuser'), 5, 'This is a great game!');

UPDATE "GameReviews" SET review = 'This is a great game! I love it!' WHERE game_id = (SELECT id FROM "Games" WHERE name = 'Chess') AND user_id = (SELECT id FROM "Users" WHERE username = 'testuser');

-- This will fail because the user group does not have delete permissions on the GameReviews table
DELETE FROM "GameReviews" WHERE game_id = (SELECT id FROM "Games" WHERE name = 'Chess') AND user_id = (SELECT id FROM "Users" WHERE username = 'testuser');

-- This will fail because the user group does not have insert permissions on the Games table
INSERT INTO "Games" (type_id, name, description, min_players, max_players, playing_time, first_year_released)
VALUES (1, 'Test Game', 'This is a test game', 2, 4, 60, 2019);

-- This will fail because the user group does not have update permissions on the Games table
UPDATE "Games" SET description = 'This is a test game that has been updated' WHERE name = 'Test Game';
```

Natomiast tutaj niektóre zapytania powinny zakończyć się błędem, ponieważ rola `user` ma ograniczone uprawnienia. Komentarze w kodzie SQL wyjaśniają, które i dlaczego zapytania nie powiodą się.

== Funkcje i procedury

W PostgreSQL można tworzyć funkcje i procedury, które pomagają w automatyzacji zadań i wykonywaniu bardziej skomplikowanych operacji na bazie danych. Funkcje mogą przyjmować argumenty i zwracać wartości, podczas gdy procedury są bardziej podobne do skryptów, które wykonują operacje na bazie danych.

W projekcie stworzyłem plik SQL zawierający kilka przykładowych funkcji i procedur, które mogą być przydatne w pracy z moją bazą danych.

=== Funkcja `get_game_details`

W tej funkcji, zwracam zestaw informacji o grze na podstawie jej nazwy. Funkcja przyjmuje nazwę gry jako argument i zwraca ID gry, nazwę, typ, kategorie, mechaniki oraz wydania w formacie JSON.

```sql
CREATE OR REPLACE FUNCTION get_game_details(game_name_param VARCHAR(255))
    RETURNS TABLE
            (
                game_id    INTEGER,
                game_name  VARCHAR(255),
                game_type  VARCHAR(255),
                categories VARCHAR[],
                mechanics  VARCHAR[],
                releases   JSON
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT g.id                       AS ID,
               g.name                     AS Name,
               gt.name                    AS Type,
               ARRAY_AGG(DISTINCT c.name) AS Categories,
               ARRAY_AGG(DISTINCT m.name) AS Mechanics,
               JSON_AGG(
                       JSON_BUILD_OBJECT(
                               'id', gr.id,
                               'release_date', gr.release_date,
                               'publisher', gr.publisher,
                               'studio', gr.studio,
                               'language', gr.language,
                               'price', gr.price,
                               'extra_information', gr.extra_information
                       )
               )                          AS Releases
        FROM "Games" g
                 JOIN "GameTypes" gt ON g.type_id = gt.id
                 LEFT JOIN "GameCategories" gc ON g.id = gc.game_id
                 LEFT JOIN "Categories" c ON gc.category_id = c.id
                 LEFT JOIN "GameMechanics" gm ON g.id = gm.game_id
                 LEFT JOIN "Mechanics" m ON gm.mechanic_id = m.id
                 LEFT JOIN "GameReleases" gr ON g.id = gr.game_id
        WHERE g.name = game_name_param
        GROUP BY g.id, gt.name;
END
$$ LANGUAGE plpgsql;

-- Example of calling the function
SELECT * FROM get_game_details('Champions of Midgard');
```

#figure(
  image("img/func_1.png"),
  caption: [Wynik przykładowego zapytania z wykorzystaniem funkcji `get_game_details`]
)


=== Procedura `add_game_review`

Ta procedura za zadanie dodanie recenzji do gry na podstawie nazwy gry, ID użytkownika, oceny i recenzji. Procedura przyjmuje te parametry i dodaje nowy rekord do tabeli `GameReviews`.

```sql
CREATE OR REPLACE PROCEDURE add_game_review(
    game_name_param VARCHAR(255),
    user_id_param INTEGER,
    rating_param INTEGER,
    review_param TEXT
)
AS
$$
BEGIN
    INSERT INTO "GameReviews" (game_id, user_id, rating, review)
    VALUES ((SELECT id FROM "Games" WHERE name = game_name_param), user_id_param, rating_param, review_param);
END;
$$ LANGUAGE plpgsql;

-- Example of calling the procedure
CALL add_game_review('Champions of Midgard', 1, 5, 'Great game, highly recommended!');
```

=== Funkcja `get_games_by_category_and_mechanic`

Kolejna funkcja zwraca listę gier, które należą do danej kategorii i posiadają daną mechanikę. Funkcja przyjmuje nazwę kategorii i mechaniki jako argumenty i zwraca ID gry i nazwę gry.

```sql
CREATE OR REPLACE FUNCTION get_games_by_category_and_mechanic(
    category_name_param VARCHAR(255),
    mechanic_name_param VARCHAR(255)
)
    RETURNS TABLE
            (
                game_id   INTEGER,
                game_name VARCHAR(255)
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT g.id   AS game_id,
               g.name AS game_name
        FROM "Games" g
                 JOIN "GameCategories" gc ON g.id = gc.game_id
                 JOIN "Categories" c ON gc.category_id = c.id
                 JOIN "GameMechanics" gm ON g.id = gm.game_id
                 JOIN "Mechanics" m ON gm.mechanic_id = m.id
        WHERE c.name = category_name_param
          AND m.name = mechanic_name_param;
END;
$$ LANGUAGE plpgsql;

-- Example of calling the function
SELECT * FROM get_games_by_category_and_mechanic('Fantasy', 'Hand Management');
```

#figure(
  image("img/func_2.png"),
  caption: [Wynik przykładowego zapytania z wykorzystaniem funkcji `get_games_by_category_and_mechanic`]
)

=== Procedury `remove_mechanic_from_game`

Procedura `remove_mechanic_from_game` usuwa mechanikę z gry na podstawie nazwy gry i nazwy mechaniki. Procedura znajduje ID gry i ID mechaniki na podstawie nazw i usuwa rekord z tabeli `GameMechanics`.

```sql
CREATE OR REPLACE PROCEDURE remove_mechanic_from_game(
    game_name_param VARCHAR(255),
    mechanic_name_param VARCHAR(255)
)
AS
$$
BEGIN
    DELETE
    FROM "GameMechanics"
    WHERE game_id = (SELECT id FROM "Games" WHERE name = game_name_param)
      AND mechanic_id = (SELECT id FROM "Mechanics" WHERE name = mechanic_name_param);
END;
$$ LANGUAGE plpgsql;

-- Example of calling the procedure
CALL remove_mechanic_from_game('Champions of Midgard', 'Worker Placement');
```


=== Procedura `add_mechanic_to_game`

Procedura `add_mechanic_to_game` dodaje mechanikę do gry na podstawie nazwy gry i nazwy mechaniki. Procedura znajduje ID gry i ID mechaniki na podstawie nazw i dodaje nowy rekord do tabeli `GameMechanics`.

```sql
CREATE OR REPLACE PROCEDURE add_mechanic_to_game(
    game_name_param VARCHAR(255),
    mechanic_name_param VARCHAR(255)
)
AS
$$
BEGIN
    INSERT INTO "GameMechanics" (game_id, mechanic_id)
    VALUES ((SELECT id FROM "Games" WHERE name = game_name_param), (SELECT id FROM "Mechanics" WHERE name = mechanic_name_param));
END;
$$ LANGUAGE plpgsql;

-- Example of calling the procedure
CALL add_mechanic_to_game('Champions of Midgard', 'Worker Placement');
```

== Backup i restore

W tym punkcie posłużyłem się głównie narzędziami dostępnymi w aplikacji do zarządzania bazą danych DataGrip. DataGrip automatycznie wykonuje komendy `pg_dump` i `psql`, które są odpowiedzialne za tworzenie kopii zapasowych i przywracanie danych z kopii zapasowej.

=== Backup

Aby wykonać kopię zapasową bazy danych, wystarczy wybrać odpowiednią opcję w menu kontekstowym bazy danych w DataGrip. 

#figure(
  image("img/backup_1.png", width: 75%),
  caption: "Wybór opcji backup z menu kontekstowego bazy danych w DataGrip"
)

Po wybraniu opcji pojawia się okno dialogowe. W przypadku systemu Windows, DataGrip pytał mnie o lokalizację skryptu `pg_dump`, który jest częścią instalacji PostgreSQL (_możliwe, że brakowało mi skryptu w zmiennych środowiskowych_). Natomiast w przypadku systemu Linux, DataGrip automatycznie wykrył lokalizację skryptu.

W oknie dialogowym można wybrać lokalizację pliku z kopią zapasową, format pliku, opcje tworzenia kopii zapasowej oraz dodatkowe opcje.

#figure(
  image("img/backup_2.png", width: 75%),
  caption: "Okno dialogowe backupu bazy danych w DataGrip"
)

=== Restore

Komenda Restore działa na podobnej zasadzie. W zależności od formatu kopii zapasowej, trzeba przygotować odpowiednio bazę danych. W przypadku plików `.sql`, trzeba utworzyć pustą bazę danych. 

Następnie wybieramy opcję "Restore..." z menu kontekstowego bazy danych i wybieramy plik z kopią zapasową.

#figure(
  image("img/restore_1.png", width: 58%),
  caption: "Wybór opcji restore z menu kontekstowego bazy danych w DataGrip"
)

#figure(
  image("img/restore_2.png", width: 70%),
  caption: "Okno dialogowe restore bazy danych w DataGrip"
)

Po wybraniu pliku, DataGrip automatycznie przywraca bazę danych z kopii zapasowej.

#figure(
  image("img/restore_3.png", width: 35%),
  caption: "Dwie bazy danych obok siebie - oryginalna i przywrócona z kopii zapasowej"
)

== Wersja testowa bazy danych

Testową bazę danych stworzyłem na serwerze lokalnym, korzystając z opcji backupu i restore opisanych powyżej. 

#figure(
  image("img/test_1.png", width: 75%),
  caption: "Okno dialogowe restore bazy testowej w DataGrip"
)

#figure(
  image("img/test_2.png", width: 60%),
  caption: "Nowo utworzona i przywrócona testowa baza danych"
)

#pagebreak()

== Komunikacja z językiem programowania

Komunikacja z bazą danych PostgreSQL jest możliwa z poziomu wielu języków programowania. W projekcie użyłem języka Rust i biblioteki `sqlx` do komunikacji z bazą danych.

Program składa się z jednego pliku `main.rs`. W pliku tym, łączę się z bazą danych, wykonuję kilka zapytań i wyświetlam wyniki.

=== Połączenie z bazą danych

Połączenie z bazą danych z użyciem `sqlx` jest bardzo proste. Wystarczy stworzyć strukturę `Pool` i przekazać adres URL bazy danych. Adres ten jest brany z pliku `.env` dla bezpieczeństwa.

```rust
async fn get_connection(database_url: &str) -> Pool<Postgres> {
    PgPoolOptions::new()
        .max_connections(5)
        .connect(database_url)
        .await
        .expect("Failed to connect to Postgres.")
}
```

Struktura `Pool` przechowuje połączenia do bazy danych i zarządza nimi automatycznie. Za jej pomocą można wykonywać zapytania do bazy danych.

=== Przykładowe zapytania

W pliku `main.rs` znajdują się 3 przykładowe zapytania.

==== Zapytanie o 10 najnowszych gier

Funkcja `print_ten_latest_games` wykonuje zapytanie do bazy danych o 10 najnowszych gier i wyświetla ich nazwy i opisy za pomocą makra `cprintln!`, które dodaje kolor do konsoli.

```rust
async fn print_ten_latest_games(pool: &Pool<Postgres>) {
    let result = sqlx::query!("SELECT name, description FROM \"Games\" ORDER BY id DESC LIMIT 10")
        .fetch_all(pool)
        .await
        .expect("Failed to fetch games.");

    cprintln!("\n<strong>Latest 10 games:</>\n");
    for record in result {
        let description = record.description.unwrap_or_else(|| String::from("No description available."));

        cprintln!("<strong><b>{}</></> - <i>{}</>", record.name, description);
    }

    println!("\n");
}
```

#figure(
  image("img/simple_rust_1.png"),
  caption: "Wynik zapytania o 10 najnowszych gier w języku Rust"
)

==== Zapytanie o kategorie z 5-15 grami

Tym razem funkcja `print_categories_with_5_15_games` wykonuje zapytanie o kategorie, które posiadają od 5 do 15 gier. Wyniki są wyświetlane w konsoli.

```rust
async fn print_categories_with_5_15_games(pool: &Pool<Postgres>) {
    let result = sqlx::query!("SELECT c.name, COUNT(g.id) AS game_count FROM \"Categories\" c
        INNER JOIN \"GameCategories\" gc ON c.id = gc.category_id
        INNER JOIN \"Games\" g ON gc.game_id = g.id
        GROUP BY c.id
        HAVING COUNT(g.id) > 5 AND COUNT(g.id) < 15")
        .fetch_all(pool)
        .await
        .expect("Failed to fetch categories.");

    cprintln!("\n<strong>Categories with more than 5 and less than 15 games:</>\n");
    for record in result {
        cprintln!("<strong><b>{}</></> - <i>{:?}</>", record.name, record.game_count.unwrap_or(0));
    }

    println!("\n");
}
```

#figure(
  image("img/simple_rust_2.png"),
  caption: "Wynik zapytania o kategorie z 5-15 grami w języku Rust"
)

#pagebreak()
==== Zapytanie o użytkowników i ilość recenzji

Ostatnie zapytanie w funkcji `print_users_and_number_of_reviews` zwraca użytkowników z rolą "USER" i ilością napisanych recenzji. Ominięci są użytkownicy, którzy nie napisali żadnej recenzji. Wyniki zapytania są wyświetlane w konsoli.

```rust
async fn print_users_and_number_of_reviews(pool: &Pool<Postgres>) {
    let result = sqlx::query!("SELECT u.username, COUNT(gr.id) AS review_count FROM \"Users\" u
        LEFT JOIN \"GameReviews\" gr ON u.id = gr.user_id
        WHERE u.role = 'USER'
        AND gr.id IS NOT NULL
        GROUP BY u.id")
        .fetch_all(pool)
        .await
        .expect("Failed to fetch users.");

    cprintln!("\n<strong>Users and the number of reviews they have made (exclude users without reviews):</>\n");
    for record in result {
        cprintln!("<strong><b>{}</></> - <i>{:?}</>", record.username, record.review_count.unwrap_or(0));
    }

    println!("\n");
}
```

#figure(
  image("img/simple_rust_3.png"),
  caption: "Wynik zapytania o użytkowników i ilość recenzji w języku Rust"
)

#pagebreak()

== Rust ORM

Oprócz krótkiego programu w Rust, który korzysta z biblioteki `sqlx`, można również korzystać z ORM (Object-Relational Mapping) w Rust. Jedną z popularniejszych bibliotek ORM w Rust jest `diesel` i zniej skorzystałem w projekcie. Za jej pomocą stworzyłem prostą aplikację konsolową do zarządzania bazą danych.

Oprócz tego skorzystałem z następujących bibliotek:
- `dotenvy` - do ładowania zmiennych środowiskowych z pliku `.env`
- `terminal-menu` - do stworzenia prostego menu w konsoli
- `inquire` - do interakcji z użytkownikiem

Aplikacja składa się z ponad 1000 linijek kodu.

=== Połączenie z bazą danych

Podobnie jak w przypadku `sqlx`, połączenie z bazą danych w `diesel` jest proste. Tym razem projekt podzieliłem na wiele sekcji i plików, aby zachować porządek. W pliku `db.rs` znajduje się funkcja `establish_admin_connection`, która łączy się z bazą danych jako administrator i zwraca połączenie.

Połączenie administratora jest potrzebne do pierwszej weryfikacji logującego się użytkownika.

```rust
pub fn establish_admin_connection() -> PgConnection {
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    PgConnection::establish(&database_url)
        .unwrap_or_else(|_| panic!("Error connecting to {}", database_url))
}
```

Podobnie jak we wcześniejszym programie, URL bazy danych jest pobierany z pliku `.env`.

Po poprawnym połączeniu z bazą danych, aplikacja przechodzi do kroków autoryzacji użytkownika.

=== Autoryzacja użytkownika

Przez fakt, że w bazie danych każdy użytkownik z tabeli `Users` powinien posiadać rola z możliwością logowania do bazy danych. W aplikacji sprawdzane jest czy istnieje i rekord w tabeli `Users`, i rola z możliwością logowania. Oprócz tego sprawdzana jest poprawność hasła i nazwy użytkownika.

```rust
pub fn check_user(login: &Login) -> bool {
    check_db_user(login) && check_gamevault_user(login)
}

// Rola z możliwością logowania do bazy danych
fn check_db_user(login: &Login) -> bool {
    login.check_if_can_connect()
}

// Rekord z tabeli Users
fn check_gamevault_user(login: &Login) -> bool {
    User::check_with_credentials(login)
}
```

#figure(
  image("img/orm_1.png"),
  caption: "Autoryzacja użytkownika w aplikacji konsolowej"
)

Po zalogowaniu się, użytkownikowi wyświetla się menu aplikacji.

=== Menu aplikacji

Menu aplikacji jest stworzone za pomocą biblioteki `terminal-menu`. Użytkownik może wybrać jedną z opcji, które są wyświetlane w konsoli. W zależności od roli użytkownika, wyświetlane są różne opcje - administracja widzi wszystkie, a użytkownik tylko te, na które ma uprawnienia.

```rust
fn build_menu(user: &User) -> TerminalMenu {
    let role = user.role.to_string();

    return match role.as_str() {
        "ADMIN" => build_admin_menu(user),
        "USER" => build_user_menu(user),
        _ => panic!("Invalid role"),
    };
}

// Menu dla administratora
fn build_admin_menu(user: &User) -> TerminalMenu {
    menu(vec![
        label("--------------------"),
        label(format!(cstr!("<bold,green>Welcome to GameVault, {}!</>"), user.username)),
        label(""),
        label(cstr!(
            "<italic>Press the <bold>arrow keys</> to navigate the menu</>"
        )),
        label(cstr!("<italic>Press <bold>Enter</> to select an item</>")),
        label(cstr!("<italic>Press <bold,red>Q</> to quit</>")),
        label("--------------------"),
        label(""),
        submenu(
            "Search Board Games",
            vec![
                label("--------------------"),
                label("Select a search criteria"),
                label("--------------------"),
                button("Search by Name"),
                button("Search by Type"),
                button("Search by Category"),
                button("Search by Mechanic"),
                back_button("Back"),
            ],
        ),
        button("Create Game"),
        button("Add Category to Game"),
        button("Create Review"),
    ])
}

// Menu dla użytkownika
fn build_user_menu(user: &User) -> TerminalMenu {
  ...
}
```

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  
  figure(
    image("img/orm_2.png"),
    caption: "Menu aplikacji widziane przez administratora"
  ),
  figure(
    image("img/orm_3.png"),
    caption: "Menu aplikacji widziane przez użytkownika"
  )
)

Wszystkie opcje w menu są interaktywne i użytkownik może wybrać jedną z nich za pomocą klawiszy strzałek i klawisza Enter. W zależności od wybranej opcji, aplikacja wykonuje odpowiednie akcje. 

```rust
fn run_selected_action(selected: String, login: &Login) {
    let mut conn = login.connect_or_panic();
    let user = login.get_user().unwrap();

    match selected.as_str() {
        "Search by Name" => search_games::search_games_by_name(&mut conn),
        "Search by Type" => search_games::search_games_by_type(&mut conn),
        "Search by Category" => search_games::search_games_by_category(&mut conn),
        "Search by Mechanic" => search_games::search_games_by_mechanic(&mut conn),
        "Create Game" => create_game::main(&mut conn),
        "Add Category to Game" => add_category_to_game::main(&mut conn),
        "Create Review" => create_review::main(&mut conn, &user),
        _ => println!("Invalid selection"),
    }
}
```

Opcja "_Search Board Games_" przenosi użytkownika do podmenu, gdzie może wybrać kryterium wyszukiwania.

#figure(
  image("img/orm_4.png"),
  caption: "Podmenu wyszukiwania gier w aplikacji konsolowej"
)

=== Opcje aplikacji

==== Wyszukiwanie gier 

W aplikacji istnieje wiele sposób na wyszukiwanie gier. Użytkownik może wyszukać grę po nazwie, typie, kategorii lub mechanice. Wyszukiwanie przez nazwę odbywa się standardowo - przez wpisanie części lub całości nazwy gry. Natomiast inne kryteria pozwalają na wybranie opcji z listy. 

#figure(
  image("img/orm_5.png"),
  caption: "Wyszukiwanie gier po nazwie (wpisanie nazwy)"
)

#figure(
  image("img/orm_6.png", width: 60%),
  caption: "Wyszukiwanie gier po kategorii (wybranie z listy)"
)


Po wpisaniu/wybraniu kryterium, aplikacja wyświetla wyniki w konsoli.

#figure(
  image("img/orm_7.png"),
  caption: "Przykładowe wyniki wyszukiwania gier wyświetlane w konsoli"
)

==== Dodawanie gry

Opcja "_Create Game_" pozwala na dodanie nowej gry do bazy danych. Użytkownik wprowadza dane o grze, takie jak nazwa, opis, minimalna i maksymalna ilość graczy, czas gry, rok pierwszego wydania oraz typ gry.

#figure(
  image("img/orm_8.png"),
  caption: "Widok dodawania nowej gry w aplikacji"
)

Po wprowadzeniu danych i zatwierdzeniu, aplikacja dodaje nową grę do bazy danych i informuje użytkownika o sukcesie.

==== Dodawanie kategorii do gry

Następna opcja - "_Add Category to Game_" pozwala na dodanie kategorii do istniejącej gry. Użytkownik wybiera grę z listy, a następnie wybiera kategorie z listy wielokrotnego wyboru.

Jako że kategorie posiadają relację wiele do wielu z grami, pierwsze sprawdzamy jakie kategorie są już przypisane do gry i umieszczamy je na liście wyboru jako domyślnie zaznaczone.

Aplikacja po zatwierdzeniu wyboru, pierwsze usuwa wszystkie kategorie przypisane do gry, a następnie dodaje nowe.

#figure(
  image("img/orm_9.png", width: 90%),
  caption: "Widok dodawania kategorii do gry w aplikacji"
)

==== Dodawanie recenzji

Ostatnią opcją jest możliwość dodania recenzji do gry. Użytkownik wybiera grę z listy, a następnie wprowadza ocenę i recenzję.

#figure(
  image("img/orm_10.png"),
  caption: "Widok dodawania recenzji do gry w aplikacji"
)

=== Modele

W aplikacji korzystam z modeli, które reprezentują struktury danych w bazie danych. Modele są zdefiniowane w folderze `models` i zawierają strukturę i metody związane z danymi.

Przykładowy model `game_review`:

```rust
// Struktura modelu recenzji gry
#[derive(Identifiable, Selectable, Queryable, Associations, Debug)]
#[diesel(belongs_to(Game))]
#[diesel(belongs_to(User))]
#[diesel(table_name = schema::game_reviews)]
#[diesel(primary_key(game_id, user_id))]
pub struct GameReview {
    pub id: i32,
    pub game_id: i32,
    pub user_id: i32,
    // Number from 1 to 10
    pub rating: i32,
    pub review: Option<String>,
}

// Struktura formularza do dodawania recenzji
#[derive(Insertable)]
#[diesel(table_name = schema::game_reviews)]
pub struct GameReviewForm {
    pub game_id: i32,
    pub user_id: i32,
    pub rating: i32,
    pub review: Option<String>,
}

// Implementacja metod dla struktury modelu recenzji gry
impl GameReview {
    // Metoda do dodawania recenzji do bazy danych
    pub fn insert(conn: &mut PgConnection, game_id: i32, user_id: i32, rating: i32, review: Option<String>) -> QueryResult<usize> {
        let form = GameReviewForm {
            game_id, user_id, rating, review,
        };

        diesel::insert_into(schema::game_reviews::table)
            .values(&form)
            .execute(conn)
    }
}
```

==== Pomocnicze schematy tabel

Oprócz modeli, `diesel` potrzebuje również schematów tabel, które definiują strukturę bazy danych. Oprócz tego informują też o relacjach i kluczach obcych między tabelami. Schematy są zdefiniowane w pliku `schema.rs`.

Przykładowy schemat tabeli `game_reviews`:

```rust
diesel::table! {
    #[sql_name = "GameReviews"]
    game_reviews (id) {
        id -> Integer,
        game_id -> Integer,
        user_id -> Integer,
        rating -> Integer,
        review -> Text,
    }
}

diesel::joinable!(game_reviews -> games (game_id));
diesel::joinable!(game_reviews -> users (user_id));
diesel::allow_tables_to_appear_in_same_query!(game_reviews, games, users);
```