use inquire::{Password, Text};
use crate::utils::login::Login;

pub fn ask_for_login() -> Login {
    let username = ask_for_username();
    let password = ask_for_password();

    Login { username, password }
}

fn ask_for_username() -> String {
    loop {
        let username = Text::new("Username: ").prompt();

        match username {
            Ok(username) => return username,
            Err(_) => println!("Let's try that again..."),
        }
    }
}

fn ask_for_password() -> String {
    loop {
        let password = Password::new("Password: ").without_confirmation().prompt();

        match password {
            Ok(password) => return password,
            Err(_) => println!("Let's try that again..."),
        }
    }
}