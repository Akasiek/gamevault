use diesel::PgConnection;

use crate::db::models::category::{Category, GameCategory};
use crate::db::models::game::Game;
use crate::utils::prompts;

pub fn main(conn: &mut PgConnection) {

    // First choose to which game to add the category
    let game_name = ask_for_game_selection();
    let game = Game::search_by_name(&game_name, conn).pop().unwrap();

    // Then choose the category to add
    let category_names = ask_for_category_multiselection(conn, &game);
    let category_ids = Category::names_to_ids(conn, category_names);

    let res = GameCategory::multi_insert(conn, game.id, category_ids);

    match res {
        Ok(_) => println!("Categories added to game"),
        Err(e) => eprintln!("Error adding categories to game: {}", e),
    }
}

fn ask_for_game_selection() -> String {
    let options = Game::get_as_options();

    prompts::ask_for_selection(options, "Select a game: ")
}

fn ask_for_category_multiselection(conn: &mut PgConnection, game: &Game) -> Vec<String> {
    let all_options = Category::get_as_options(conn);
    let game_categories = game.get_categories(conn);
    let default_options = game_categories.iter().map(|c| c.name.clone()).collect();

    prompts::ask_for_multiselection(all_options, default_options, "Select categories: ")
}