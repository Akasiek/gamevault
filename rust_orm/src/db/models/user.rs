use crate::db::{establish_admin_connection, schema};
use crate::utils::login::Login;
use diesel::prelude::*;
use schema::users::dsl::*;

#[derive(Queryable, Selectable, Debug)]
#[diesel(table_name = schema::users)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct User {
    pub id: i32,
    pub username: String,
    pub email: String,
    pub password: String,
    pub first_name: String,
    pub last_name: String,
    pub role: String,
}

impl User {
    pub fn check_with_credentials(login: &Login) -> bool {
        let mut conn = establish_admin_connection();

        let results: Result<Vec<User>, _> = users
            .filter(username.eq(login.username.clone()))
            .filter(password.eq(diesel::dsl::sql(&format!("crypt('{}', password)", login.password))))
            .load(&mut conn);

        match results {
            Ok(results) => !results.is_empty(),
            Err(_) => false,
        }
    }

    pub fn get_with_credentials(login: &Login) -> Option<User> {
        let mut conn = establish_admin_connection();

        let user = users
            .filter(username.eq(login.username.clone()))
            .filter(password.eq(diesel::dsl::sql(&format!("crypt('{}', password)", login.password))))
            .first(&mut conn);

        match user {
            Ok(user) => Some(user),
            Err(_) => None,
        }
    }
}
