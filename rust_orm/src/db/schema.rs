diesel::table! {
    #[sql_name = "Games"]
    games (id) {
        id -> Integer,
        type_id -> Integer,
        name -> VarChar,
        description -> Text,
        min_players -> Integer,
        max_players -> Integer,
        playing_time -> Integer,
        first_year_released -> Integer,
    }
}

diesel::table! {
    #[sql_name = "GameTypes"]
    game_types (id) {
        id -> Integer,
        name -> VarChar,
    }
}
diesel::joinable!(games -> game_types (type_id));
diesel::allow_tables_to_appear_in_same_query!(games, game_types);

diesel::table! {
    #[sql_name = "Categories"]
    categories (id) {
        id -> Integer,
        name -> VarChar,
    }
}

diesel::table! {
    #[sql_name = "GameCategories"]
    game_categories (game_id, category_id) {
        game_id -> Integer,
        category_id -> Integer
    }
}

diesel::joinable!(game_categories -> games (game_id));
diesel::joinable!(game_categories -> categories (category_id));
diesel::allow_tables_to_appear_in_same_query!(game_categories, games, categories);

diesel::table! {
    #[sql_name = "Mechanics"]
    mechanics (id) {
        id -> Integer,
        name -> VarChar,
        description -> Text,
    }
}

diesel::table! {
    #[sql_name = "GameMechanics"]
    game_mechanics (game_id, mechanic_id) {
        game_id -> Integer,
        mechanic_id -> Integer
    }
}

diesel::joinable!(game_mechanics -> games (game_id));
diesel::joinable!(game_mechanics -> mechanics (mechanic_id));
diesel::allow_tables_to_appear_in_same_query!(game_mechanics, games, mechanics);


diesel::table! {
    #[sql_name = "Users"]
    users (id) {
        id -> Integer,
        username -> VarChar,
        email -> VarChar,
        password -> VarChar,
        first_name -> VarChar,
        last_name -> VarChar,
        role -> VarChar,
    }
}

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