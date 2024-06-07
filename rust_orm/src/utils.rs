pub mod check_db_users;
pub mod login;
pub mod prompts;

/// Panic if the database connection fails
pub fn check_db_connection() {
    crate::db::establish_admin_connection();
}

/// Clear the terminal window
/// If on Windows, use the 'cls' command
/// Otherwise, use the 'clear' command
///
/// If command fails, do nothing
pub fn clear_term() {
    #[cfg(target_os = "windows")]
        let _ = std::process::Command::new("cmd").arg("/c").arg("cls").status();

    #[cfg(not(target_os = "windows"))]
        let _ = std::process::Command::new("clear").status();
}
