use diesel::{Connection, ConnectionResult, PgConnection};
use crate::db::models::user::User;

pub struct Login {
    pub username: String,
    pub password: String,
}

impl Login {
    pub fn establish_connection(&self) -> ConnectionResult<PgConnection> {
        let database_url = format!(
            "postgres://{}:{}@localhost:60824/GameVault",
            self.username, self.password
        );

        PgConnection::establish(&database_url)
    }
    
    pub fn check_if_can_connect(&self) -> bool {
        self.establish_connection().is_ok()
    }
    
    pub fn connect_or_panic(&self) -> PgConnection {
        self.establish_connection().unwrap_or_else(|_| {
            panic!("Error connecting to the database with the provided credentials.")
        })
    }
    
    pub fn get_user(&self) -> Option<User> {
        User::get_with_credentials(self)
    }
}
