use diesel::prelude::*;

use crate::db::models::game::Game;
use crate::db::schema::{game_mechanics, mechanics};

#[derive(Queryable, Selectable, Identifiable)]
#[diesel(table_name = mechanics)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Mechanic {
    pub id: i32,
    pub name: String,
    pub description: Option<String>,
}

impl Mechanic {
    pub fn get_all(connection: &mut PgConnection) -> Vec<Mechanic> {
        use crate::db::schema::mechanics::dsl::*;

        mechanics
            .order_by(name.asc())
            .load(connection)
            .expect("Error loading mechanics")
    }

    pub fn get_as_options(connection: &mut PgConnection) -> Vec<String> {
        Mechanic::get_all(connection)
            .into_iter()
            .map(|m| m.name)
            .collect()
    }
}

#[derive(Identifiable, Selectable, Queryable, Associations, Debug)]
#[diesel(belongs_to(Game))]
#[diesel(belongs_to(Mechanic))]
#[diesel(table_name = game_mechanics)]
#[diesel(primary_key(game_id, mechanic_id))]
pub struct GameMechanic {
    pub game_id: i32,
    pub mechanic_id: i32,
}