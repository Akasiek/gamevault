-- Get all games with releases in database that price sum is greater or equal to 200
SELECT "Games"."name", SUM("GameReleases"."price") AS "price_sum", COUNT("GameReleases"."price") AS "number_of_releases"
FROM "Games"
         INNER JOIN "GameReleases" ON "Games"."id" = "GameReleases"."game_id"
GROUP BY "Games"."id"
HAVING SUM("GameReleases"."price") >= 200;

-- Get ranking of users ratings. Show only users with more than 0 ratings, show also latest review
SELECT "Users"."username",
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


-- Get all games' latest release and first release from collection and first year they were released on the market
SELECT "Games"."name",
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

-- Get game types and average minimum and maximum number of players
SELECT "GameTypes"."name",
       ROUND(AVG("Games"."min_players"), 2) AS "average_min_players",
       ROUND(AVG("Games"."max_players"), 2) AS "average_max_players"
FROM "GameTypes"
         INNER JOIN "Games" ON "GameTypes"."id" = "Games"."type_id"
GROUP BY "GameTypes"."id";

-- Get all game categories, count of games, list of games and average rating of games
SELECT "Categories"."name",
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

