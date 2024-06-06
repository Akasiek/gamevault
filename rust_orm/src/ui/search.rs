use color_print::cprintln;
use text_io::read;
use crate::db;
use db::models::game::Game;

pub fn search_games_by_name() {
    let query = ask_for_string_query();
    let connection = &mut db::establish_connection();
    let results = Game::search_by_name(&query, connection);

    if results.is_empty() {
        cprintln!("\nNo games found for query: <italic>{}</>\n", query);
        return;
    }

    cprintln!("\nDisplaying <bold,green>{}</> games\n", results.len());
    for game in results {
        game.display();
    }
}

fn ask_for_string_query() -> String {
    cprintln!("Enter a search query (Press <bold>Enter</> to submit): ");
    let mut query: String = read!("{}\n");

    // If on Windows, remove the trailing '\r' character
    if cfg!(target_os = "windows") {
        query = query.trim_end_matches('\r').to_string();
    }

    query
}