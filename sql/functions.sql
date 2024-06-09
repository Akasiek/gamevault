--
-- Function to get game details by name
--
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
SELECT *
FROM get_game_details('Champions of Midgard');


--
-- Function to add a review to a game
--
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


--
-- Function to get games by category and mechanic
--
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


--
-- Function to remove a mechanic from a game
--
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


--
-- Function to add a mechanic to a game
--
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