use dotenvy::dotenv;

pub mod db;
pub mod ui;
pub mod utils;

fn main() {
    dotenv().ok();
    utils::check_db_connection();

    ui::main();
}
