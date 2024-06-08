use diesel::prelude::*;

use crate::db::models::game::Game;
use crate::db::schema::{categories, game_categories};
use crate::db::schema;

#[derive(Queryable, Selectable, Identifiable)]
#[diesel(table_name = categories)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Category {
    pub id: i32,
    pub name: String,
}

impl Category {
    pub fn get_all(connection: &mut PgConnection) -> Vec<Category> {
        use schema::categories::dsl::*;

        categories
            .order_by(name.asc())
            .load(connection)
            .expect("Error loading categories")
    }

    pub fn get_as_options(connection: &mut PgConnection) -> Vec<String> {
        Category::get_all(connection)
            .into_iter()
            .map(|category| category.name)
            .collect()
    }

    pub fn names_to_ids(connection: &mut PgConnection, category_names: Vec<String>) -> Vec<i32> {
        use schema::categories::dsl::*;

        categories
            .filter(name.eq_any(category_names))
            .select(id)
            .load(connection)
            .expect("Error loading category IDs")
    }
}

#[derive(Identifiable, Selectable, Queryable, Associations, Insertable, Debug)]
#[diesel(belongs_to(Game))]
#[diesel(belongs_to(Category))]
#[diesel(table_name = game_categories)]
#[diesel(primary_key(game_id, category_id))]
pub struct GameCategory {
    pub game_id: i32,
    pub category_id: i32,
}

impl GameCategory {
    pub fn multi_insert(connection: &mut PgConnection, passed_game_id: i32, category_ids: Vec<i32>) -> QueryResult<usize> {
        use schema::game_categories::*;

        // First remove all existing associations
        diesel::delete(game_categories::table.filter(game_id.eq(passed_game_id)))
            .execute(connection)
            .expect("Error deleting game categories");

        let new_game_categories: Vec<GameCategory> = category_ids
            .into_iter()
            .map(|new_category_id| GameCategory { game_id: passed_game_id, category_id: new_category_id })
            .collect();

        diesel::insert_into(game_categories::table)
            .values(&new_game_categories)
            .execute(connection)
    }
}