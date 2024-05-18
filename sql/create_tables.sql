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