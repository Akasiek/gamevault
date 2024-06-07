use crate::db::models::user::User;
use crate::utils::login::Login;

pub fn check_user(login: &Login) -> bool {
    check_db_user(login) && check_gamevault_user(login)
}

/// Check if login provided corresponds to a PostgreSQL user.
fn check_db_user(login: &Login) -> bool {
    login.check_if_can_connect()
}

fn check_gamevault_user(login: &Login) -> bool {
    User::check_with_credentials(login)
}
