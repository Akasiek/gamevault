use color_print::cprintln;
use diesel::PgConnection;
use inquire::{Confirm, CustomType};

use crate::db::models::game::Game;
use crate::db::models::game_review::GameReview;
use crate::db::models::user::User;
use crate::utils::prompts;

pub fn main(conn: &mut PgConnection, user: &User) {
    let game_name = ask_for_game_selection();
    let game = Game::search_by_name(&game_name, conn).pop().unwrap();
    let rating = ask_for_rating();
    let review = ask_for_review();

    let res = GameReview::insert(conn, user.id, game.id, rating, review);

    match res {
        Ok(_) => {
            cprintln!("\n<g>Review created successfully!</>\n");
        }
        Err(e) => {
            cprintln!("\n<r>Failed to create review: {}</>", e);
        }
    }
}

fn ask_for_game_selection() -> String {
    let options = Game::get_as_options();

    prompts::ask_for_selection(options, "Select a game: ")
}

fn ask_for_rating() -> i32 {
    loop {
        let validator = |rating: &i32| {
            if *rating >= 1 && *rating <= 10 {
                Ok(inquire::validator::Validation::Valid)
            } else {
                Ok(inquire::validator::Validation::Invalid("Invalid rating. Please enter a number between 1 and 10".into()))
            }
        };

        let res = CustomType::<i32>::new("Enter a rating (1-10)")
            .with_validator(validator)
            .with_help_message("Please enter a number between 1 and 10")
            .with_error_message("Invalid rating. Please enter a number between 1 and 10")
            .prompt();

        match res {
            Ok(rating) => { return rating; }
            Err(_) => {
                cprintln!("<r>Something went wrong. Let's try that again...</>");
            }
        }
    }
}

fn ask_for_review() -> Option<String> {
    // First ask if user wants to write a review
    Confirm::new("Would you like to write a review?")
        .with_default(false)
        .prompt()
        .unwrap()
        .then(|| {
            prompts::ask_for_editor("Write your review: ")
        })
        .unwrap_or(None)
}