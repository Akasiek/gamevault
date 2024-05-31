-- Increase the price of all games in German by 25%
UPDATE "GameReleases"
SET "price" = "price" * 1.25
WHERE "language" = 'German';

-- Decrease the price of all games with Hand Management mechanics by 10%
UPDATE "GameReleases"
SET "price" = "price" * 0.9
FROM "Games"
         INNER JOIN "GameMechanics" ON "Games"."id" = "GameMechanics"."game_id"
         INNER JOIN "Mechanics" ON "GameMechanics"."mechanic_id" = "Mechanics"."id"
WHERE "Games"."id" = "GameReleases"."game_id"
  AND "Mechanics"."name" = 'Hand Management';

-- Increase the price of all games with a rating of 4 or higher by 15% (Use Subquery)
UPDATE "GameReleases"
SET "price" = "price" * 1.15
WHERE "game_id" IN (SELECT "game_id"
                    FROM "GameReviews"
                    WHERE "GameReviews"."rating" >= 4);

-- Based on the number of ratings change the role of users. If a user has more than 5 ratings, change their role to 'ADMIN', otherwise change their role to 'USER'
UPDATE "Users"
SET "role" = CASE
                 WHEN (SELECT COUNT(*)
                       FROM "GameReviews"
                       WHERE "Users"."id" = "GameReviews"."user_id") > 5 THEN 'ADMIN'
                 ELSE 'USER'
    END
FROM "GameReviews"
WHERE "Users"."id" = "GameReviews"."user_id";

-- To all mechanics add description that provides number of different games and game types that use this mechanic
-- If mechanic is not used in any game, set description to 'This mechanic is not used in any game'
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