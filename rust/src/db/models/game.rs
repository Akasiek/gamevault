use color_print::cprintln;
use diesel::prelude::*;
use crate::db::schema;

#[derive(Queryable, Selectable)]
#[diesel(table_name = schema::games)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Game {
    pub id: i32,
    pub type_id: i32,
    pub name: String,
    pub description: String,
    pub min_players: i32,
    pub max_players: i32,
    pub playing_time: i32,
    pub first_year_released: i32,
}

impl Game {
    pub fn display(&self) {
        println!("--------------------");
        cprintln!("<bold,green>{}</>", self.name);
        cprintln!("<italic>{}</>", self.description);
        cprintln!("<italic>Players</>: {}-{}", self.min_players, self.max_players);
        cprintln!("<italic>Approximate Playing Time</>: {} minutes", self.playing_time);
        cprintln!("<italic>First Released</>: {}", self.first_year_released);
        println!("--------------------\n");
    }
    pub fn search_by_name(query: &str, connection: &mut PgConnection) -> Vec<Game> {
        use schema::games::dsl::*;

        games
            .filter(name.like(format!("%{}%", query)))
            .load(connection)
            .expect("Error loading games")
    }
}