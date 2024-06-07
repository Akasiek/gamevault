use color_print::cprintln;
use diesel::PgConnection;

use db::models::game::Game;

use crate::db;
use crate::db::models::category::Category;
use crate::db::models::game_type::GameType;
use crate::db::models::mechanic::Mechanic;
use crate::utils::prompts;

pub fn search_games_by_name(conn: &mut PgConnection) {
    let query = prompts::ask_for_string("Enter a search query: ");
    let results = Game::search_by_name(&query, conn);

    display_search_results(results);
}

pub fn search_games_by_type(conn: &mut PgConnection) {
    let options = GameType::get_as_options(conn);
    let choice = prompts::ask_for_selection(options, "Select a game type: ");

    let results = Game::search_by_type_name(&choice, conn);

    display_search_results(results);
}

pub fn search_games_by_category(conn: &mut PgConnection) {
    let options = Category::get_as_options(conn);
    let choice = prompts::ask_for_selection(options, "Select a game category: ");

    let results = Game::search_by_category_name(&choice, conn);

    display_search_results(results);
}

pub fn search_games_by_mechanic(conn: &mut PgConnection) {
    let options = Mechanic::get_as_options(conn);
    let choice = prompts::ask_for_selection(options, "Select a game mechanic: ");

    let results = Game::search_by_mechanic_name(&choice, conn);

    display_search_results(results);
}

pub fn display_search_results(results: Vec<Game>) {
    if results.is_empty() {
        cprintln!("\nNo games found for query.\n");
        return;
    }

    cprintln!("\nDisplaying <bold,green>{}</> games\n", results.len());
    for game in results {
        game.display_with_relationships();
    }
}

