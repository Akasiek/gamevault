use color_print::cprintln;
use diesel::PgConnection;

use crate::db::models::game::{Game, GameForm};
use crate::db::models::game_type::GameType;
use crate::utils::prompts::{ask_for_editor, ask_for_number, ask_for_selection, ask_for_string};

pub fn main(conn: &mut PgConnection) {
    let name = ask_for_string("Enter the name of the game: ");
    let description = ask_for_editor("Enter the description of the game: ");
    let (min_players, max_players) = ask_for_min_and_max_players();
    let playing_time = ask_for_number("Enter the average playtime of the game (in minutes): ");
    let first_year_released = ask_for_number("Enter the year the game was first released: ");
    let type_id = ask_for_type(conn);

    let form = GameForm {
        type_id,
        name,
        description,
        min_players,
        max_players,
        playing_time,
        first_year_released,
    };
    
    let res = Game::insert(conn, form);
    
    match res {
        Ok(_) => {
            cprintln!("\n<g>Game created successfully!</>\n");
        }
        Err(e) => {
            cprintln!("\n<r>Failed to create game: {}</>", e);
        }
    }
}

fn ask_for_min_and_max_players() -> (i32, i32) {
    loop {
        let min_players = ask_for_number("Enter the minimum number of players: ");
        let max_players = ask_for_number("Enter the maximum number of players: ");

        if min_players > max_players {
            cprintln!("<r>Minimum number of players cannot be greater than maximum number of players. Please try again.</>");
        } else {
            return (min_players, max_players);
        }
    }
}

fn ask_for_type(conn: &mut PgConnection) -> i32 {
    let options = GameType::get_as_options(conn);
    let choice = ask_for_selection(options, "Select a game type: ");

    let game_type = GameType::search_by_name(&choice, conn).pop().unwrap();

    game_type.id
}