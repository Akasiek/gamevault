use std::env;

use diesel::pg::PgConnection;
use diesel::prelude::*;

pub mod models;
pub mod schema;

pub fn establish_admin_connection() -> PgConnection {
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    PgConnection::establish(&database_url)
        .unwrap_or_else(|_| panic!("Error connecting to {}", database_url))
}
