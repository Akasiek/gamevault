use diesel::prelude::*;

use crate::db::schema;

#[derive(Queryable, Selectable)]
#[diesel(table_name = schema::game_types)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct GameType {
    pub id: i32,
    pub name: String,
}

impl GameType {
    pub fn get_all(connection: &mut PgConnection) -> Vec<GameType> {
        use schema::game_types::dsl::*;

        game_types
            .order_by(name.asc())
            .load(connection)
            .expect("Error loading game types")
    }

    pub fn get_as_options(connection: &mut PgConnection) -> Vec<String> {
        GameType::get_all(connection)
            .into_iter()
            .map(|game_type| game_type.name)
            .collect()
    }

    pub fn search_by_name(query: &str, connection: &mut PgConnection) -> Vec<GameType> {
        use schema::game_types::dsl::*;

        game_types
            .filter(name.eq(query))
            .load(connection)
            .expect("Error loading game types")
    }
}