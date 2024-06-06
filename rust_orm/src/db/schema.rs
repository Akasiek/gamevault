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
