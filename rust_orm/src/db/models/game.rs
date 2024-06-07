use color_print::cprintln;
use diesel::prelude::*;

use crate::db::models::category::Category;
use crate::db::models::game_type::GameType;
use crate::db::models::mechanic::Mechanic;
use crate::db::schema;

#[derive(Queryable, Identifiable, Selectable, Associations)]
#[diesel(table_name = schema::games)]
#[diesel(belongs_to(GameType, foreign_key = type_id))]
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

#[derive(Insertable)]
#[diesel(table_name = schema::games)]
pub struct GameForm {
    pub type_id: i32,
    pub name: String,
    pub description: Option<String>,
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

    pub fn display_with_relationships(&self) {
        let mut admin_conn = crate::db::establish_admin_connection();
        let game_type = self.get_type(&mut admin_conn);
        let game_categories: Vec<Category> = self.get_categories(&mut admin_conn);
        let game_mechanics: Vec<Mechanic> = self.get_mechanics(&mut admin_conn);

        let categories = join_names(game_categories.iter().map(|c| c.name.clone()).collect());
        let mechanics = join_names(game_mechanics.iter().map(|m| m.name.clone()).collect());

        println!("--------------------");
        cprintln!("<bold,green>{}</>", self.name);
        cprintln!("<italic>{}</>", self.description);
        cprintln!("<italic>Players</>: {}-{}", self.min_players, self.max_players);
        cprintln!("<italic>Approximate Playing Time</>: {} minutes", self.playing_time);
        cprintln!("<italic>First Released</>: {}", self.first_year_released);
        cprintln!("<italic>Game Type</>: {}", game_type.name);
        cprintln!("<italic>Categories</>: {}", categories);
        cprintln!("<italic>Mechanics</>: {}", mechanics);
        println!("--------------------\n");
    }

    pub fn get_as_options() -> Vec<String> {
        use schema::games::dsl::*;
        let mut admin_conn = crate::db::establish_admin_connection();

        games.
            select(name)
            .order(name)
            .load::<String>(&mut admin_conn)
            .expect("Error loading games")
    }

    pub fn get_type(&self, connection: &mut PgConnection) -> GameType {
        use schema::game_types::dsl::*;

        game_types
            .find(self.type_id)
            .first(connection)
            .expect("Error loading game type")
    }

    pub fn get_categories(&self, connection: &mut PgConnection) -> Vec<Category> {
        use schema::categories::dsl::*;
        use schema::game_categories::dsl::*;

        game_categories
            .inner_join(schema::categories::table)
            .filter(game_id.eq(self.id))
            .select(categories::all_columns())
            .load(connection)
            .expect("Error loading categories")
    }

    pub fn get_mechanics(&self, connection: &mut PgConnection) -> Vec<Mechanic> {
        use schema::mechanics::dsl::*;
        use schema::game_mechanics::dsl::*;

        game_mechanics
            .inner_join(schema::mechanics::table)
            .filter(game_id.eq(self.id))
            .select(mechanics::all_columns())
            .load(connection)
            .expect("Error loading mechanics")
    }

    pub fn search_by_name(query: &str, connection: &mut PgConnection) -> Vec<Game> {
        use schema::games::dsl::*;

        games
            .filter(name.like(format!("%{}%", query)))
            .load(connection)
            .expect("Error loading games")
    }

    pub fn search_by_type_name(type_name: &String, connection: &mut PgConnection) -> Vec<Game> {
        use schema::games::dsl::*;

        games
            .inner_join(schema::game_types::table)
            .filter(schema::game_types::name.eq(type_name))
            .select(games::all_columns())
            .load(connection)
            .expect("Error loading games")
    }

    pub fn search_by_category_name(category_name: &String, connection: &mut PgConnection) -> Vec<Game> {
        use schema::games::dsl::*;
        use schema::game_categories::dsl::*;

        game_categories
            .inner_join(schema::categories::table)
            .inner_join(schema::games::table)
            .filter(schema::categories::name.eq(category_name))
            .select(games::all_columns())
            .load(connection)
            .expect("Error loading games")
    }

    pub fn search_by_mechanic_name(mechanic_name: &String, connection: &mut PgConnection) -> Vec<Game> {
        use schema::games::dsl::*;
        use schema::game_mechanics::dsl::*;

        game_mechanics
            .inner_join(schema::mechanics::table)
            .inner_join(schema::games::table)
            .filter(schema::mechanics::name.eq(mechanic_name))
            .select(games::all_columns())
            .load(connection)
            .expect("Error loading games")
    }

    pub fn insert(connection: &mut PgConnection, form: GameForm) -> QueryResult<usize> {
        diesel::insert_into(schema::games::table)
            .values(&form)
            .execute(connection)
    }
}


fn join_names(names: Vec<String>) -> String {
    let names = names.iter().map(|n| n.clone()).collect::<Vec<String>>().join(", ");

    if names.is_empty() {
        "None".to_string()
    } else {
        names
    }
}