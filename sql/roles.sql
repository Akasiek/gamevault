-- Create a group for administrators
CREATE ROLE admins WITH NOLOGIN;

-- Create a group for users
CREATE ROLE users WITH NOLOGIN;

-- Grant the admins group the ability to select, insert, update, and delete from all tables in the database GameVault
SET ROLE NONE;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admins;
GRANT CREATE ON SCHEMA public TO admins;

-- Fix the sequence permissions - this is needed for the serial columns to work correctly
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO admins;

-- Grant the users group the ability to select from all tables and insert and update in GameReviews table
SET ROLE NONE;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO users;
GRANT INSERT, UPDATE ON "GameReviews" TO users;

-- Fix the sequence permissions - this is needed for the serial columns to work correctly
GRANT USAGE, SELECT ON "GameReviews_id_seq" TO users;


-- Create administrators
--   Passwords are always encrypted using sha256
CREATE ROLE admin WITH LOGIN PASSWORD 'kamil123' IN ROLE admins;
CREATE ROLE brownleopard167 WITH LOGIN PASSWORD 'adriana' IN ROLE admins;
CREATE ROLE brownelephant395 WITH LOGIN PASSWORD 'marianne' IN ROLE admins;
CREATE ROLE orangemeercat937 WITH LOGIN PASSWORD 'admiral' IN ROLE admins;
CREATE ROLE happyelephant398 WITH LOGIN PASSWORD 'buffy' IN ROLE admins;
CREATE ROLE angrytiger902 WITH LOGIN PASSWORD 'python' IN ROLE admins;
CREATE ROLE whitedog925 WITH LOGIN PASSWORD 'bigal' IN ROLE admins;
CREATE ROLE greendog151 WITH LOGIN PASSWORD 'giorgio' IN ROLE admins;
CREATE ROLE smallfrog999 WITH LOGIN PASSWORD 'snapper' IN ROLE admins;
CREATE ROLE silverfrog736 WITH LOGIN PASSWORD 'johnboy' IN ROLE admins;

-- Example of using the admins group
SET ROLE admin;

SELECT * FROM "Games";

INSERT INTO "Games" (type_id, name, description, min_players, max_players, playing_time, first_year_released)
VALUES (1, 'Test Game', 'This is a test game', 2, 4, 60, 2019);

UPDATE "Games" SET description = 'This is a test game that has been updated' WHERE name = 'Test Game';

DELETE FROM "Games" WHERE name = 'Test Game';


-- Create users
SET ROLE NONE;
CREATE ROLE testuser WITH LOGIN PASSWORD 'test123' IN ROLE users;
CREATE ROLE bigdog363 WITH LOGIN PASSWORD 'lespaul' IN ROLE users;
CREATE ROLE beautifulladybug647 WITH LOGIN PASSWORD 'speakers' IN ROLE users;
CREATE ROLE redelephant587 WITH LOGIN PASSWORD 'winner' IN ROLE users;
CREATE ROLE bluerabbit488 WITH LOGIN PASSWORD 'football1' IN ROLE users;
CREATE ROLE brownbird726 WITH LOGIN PASSWORD 'trevor' IN ROLE users;
CREATE ROLE redtiger664 WITH LOGIN PASSWORD 'megan1' IN ROLE users;
CREATE ROLE silverleopard287 WITH LOGIN PASSWORD 'solitude' IN ROLE users;
CREATE ROLE blackbutterfly238 WITH LOGIN PASSWORD 'jayhawks' IN ROLE users;
CREATE ROLE beautifulpeacock570 WITH LOGIN PASSWORD '2727' IN ROLE users;
CREATE ROLE brownleopard490 WITH LOGIN PASSWORD 'racers' IN ROLE users;
CREATE ROLE bluelion607 WITH LOGIN PASSWORD 'horizon' IN ROLE users;
CREATE ROLE smallladybug987 WITH LOGIN PASSWORD 'blondes' IN ROLE users;
CREATE ROLE lazyzebra393 WITH LOGIN PASSWORD 'natalie' IN ROLE users;
CREATE ROLE sadfrog211 WITH LOGIN PASSWORD 'murphy' IN ROLE users;
CREATE ROLE organicdog182 WITH LOGIN PASSWORD 'susan' IN ROLE users;
CREATE ROLE lazybear213 WITH LOGIN PASSWORD '1a2b3c4d' IN ROLE users;
CREATE ROLE yellowwolf708 WITH LOGIN PASSWORD 'hottest' IN ROLE users;
CREATE ROLE yellowzebra866 WITH LOGIN PASSWORD 'game' IN ROLE users;
CREATE ROLE tinyzebra562 WITH LOGIN PASSWORD 'hardball' IN ROLE users;
CREATE ROLE beautifulgoose819 WITH LOGIN PASSWORD 'achilles' IN ROLE users;
CREATE ROLE silverwolf552 WITH LOGIN PASSWORD 'sales' IN ROLE users;
CREATE ROLE ticklishwolf937 WITH LOGIN PASSWORD 'rolling' IN ROLE users;
CREATE ROLE sadsnake629 WITH LOGIN PASSWORD 'yesyes' IN ROLE users;
CREATE ROLE greensnake233 WITH LOGIN PASSWORD 'startrek' IN ROLE users;
CREATE ROLE ticklishgoose127 WITH LOGIN PASSWORD 'midori' IN ROLE users;
CREATE ROLE brownwolf827 WITH LOGIN PASSWORD '1987' IN ROLE users;
CREATE ROLE smallpeacock567 WITH LOGIN PASSWORD 'root' IN ROLE users;
CREATE ROLE blackleopard632 WITH LOGIN PASSWORD 'smokes' IN ROLE users;
CREATE ROLE bigkoala609 WITH LOGIN PASSWORD 'grizzly' IN ROLE users;
CREATE ROLE crazycat330 WITH LOGIN PASSWORD '1220' IN ROLE users;
CREATE ROLE ticklishzebra301 WITH LOGIN PASSWORD 'nice' IN ROLE users;
CREATE ROLE tinyswan125 WITH LOGIN PASSWORD 'manchest' IN ROLE users;
CREATE ROLE organicmouse894 WITH LOGIN PASSWORD 'jaguar1' IN ROLE users;
CREATE ROLE whiteelephant931 WITH LOGIN PASSWORD 'active' IN ROLE users;
CREATE ROLE brownleopard182 WITH LOGIN PASSWORD 'gaymen' IN ROLE users;
CREATE ROLE smallcat637 WITH LOGIN PASSWORD 'erica' IN ROLE users;
CREATE ROLE yellowtiger206 WITH LOGIN PASSWORD '420420' IN ROLE users;
CREATE ROLE whitefrog396 WITH LOGIN PASSWORD 'mantle' IN ROLE users;
CREATE ROLE silverleopard192 WITH LOGIN PASSWORD '33333333' IN ROLE users;
CREATE ROLE greenleopard699 WITH LOGIN PASSWORD 'eddie1' IN ROLE users;
CREATE ROLE ticklishdog164 WITH LOGIN PASSWORD 'ross' IN ROLE users;
CREATE ROLE lazygorilla208 WITH LOGIN PASSWORD 'heidi' IN ROLE users;
CREATE ROLE purplekoala865 WITH LOGIN PASSWORD 'tetsuo' IN ROLE users;

-- Example of using the users group
SET ROLE testuser;

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



SET ROLE NONE;
