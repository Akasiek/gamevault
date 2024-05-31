-- Get all games from 'Fantasy' category
SELECT "Games"."name" FROM "Games"
INNER JOIN "GameCategories" ON "Games"."id" = "GameCategories"."game_id"
INNER JOIN "Categories" ON "GameCategories"."category_id" = "Categories"."id"
WHERE "Categories"."name" = 'Fantasy';

-- Get all games with 'Hand management' mechanic
SELECT "Games"."name" FROM "Games"
INNER JOIN "GameMechanics" ON "Games"."id" = "GameMechanics"."game_id"
INNER JOIN "Mechanics" ON "GameMechanics"."mechanic_id" = "Mechanics"."id"
WHERE "Mechanics"."name" = 'Hand Management';

-- Get all games with average rating of 4 or higher
SELECT "Games"."name", AVG("GameReviews"."rating") AS "average_rating", COUNT("GameReviews"."rating") AS "number_of_ratings" FROM "Games"
RIGHT JOIN "GameReviews" ON "Games"."id" = "GameReviews"."game_id"
GROUP BY "Games"."id"
HAVING AVG("GameReviews"."rating") >= 4;

-- Get all categories with more than 5 games and less than 15 games
SELECT "Categories"."name", COUNT("Games"."id") AS "game_count" FROM "Categories"
INNER JOIN "GameCategories" ON "Categories"."id" = "GameCategories"."category_id"
INNER JOIN "Games" ON "GameCategories"."game_id" = "Games"."id"
GROUP BY "Categories"."id"
HAVING COUNT("Games"."id") > 5 AND COUNT("Games"."id") < 15;

-- Get all users and the number of reviews they have given
SELECT "Users"."username", COUNT("GameReviews"."id") AS "review_count" FROM "Users"
LEFT JOIN "GameReviews" ON "Users"."id" = "GameReviews"."user_id"
WHERE "Users"."role" = 'USER'
GROUP BY "Users"."id";

-- Get all games released after 2010
SELECT "Games"."name", "Games"."first_year_released" FROM "Games"
WHERE "Games"."first_year_released" > 2010;

