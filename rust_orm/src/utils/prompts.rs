use color_print::cprintln;
use inquire::{Editor, MultiSelect, Select, Text};

pub fn ask_for_string(prompt: &str) -> String {
    loop {
        match Text::new(prompt).prompt() {
            Ok(query) => { return query; }
            Err(_) => {
                cprintln!("<r>Something went wrong. Let's try that again...</>");
            }
        }
    }
}

pub fn ask_for_number(prompt: &str) -> i32 {
    loop {
        match Text::new(prompt).prompt() {
            Ok(query) => {
                match query.parse::<i32>() {
                    Ok(number) => { return number; }
                    Err(_) => {
                        cprintln!("<r>Invalid input. Please enter a number.</>");
                    }
                }
            }
            Err(_) => {
                cprintln!("<r>Something went wrong. Let's try that again...</>");
            }
        }
    }
}

pub fn ask_for_selection(options: Vec<String>, prompt: &str) -> String {
    loop {
        match Select::new(prompt, options.clone()).with_page_size(32).prompt() {
            Ok(choice) => { return choice; }
            Err(_) => {
                cprintln!("<r>Something went wrong. Let's try that again...</>");
            }
        };
    }
}

pub fn ask_for_editor(prompt: &str) -> Option<String> {
    let review = Editor::new(prompt)
        .with_editor_command("micro".as_ref())
        .prompt();

    return match review {
        Ok(review) => {
            if review.is_empty() {
                return None;
            }

            Some(review)
        }
        Err(_) => {
            cprintln!("<r>Something went wrong. Make sure to install <strong>micro</> editor.</>");
            None
        }
    };
}

pub fn ask_for_multiselection(options: Vec<String>, default_options: Vec<String>, prompt: &str) -> Vec<String> {
    loop {
        let default_options: &[usize] = &default_options.iter()
            .map(|option| options.iter().position(|o| o == option).unwrap())
            .collect::<Vec<usize>>();

        let res = MultiSelect::new(prompt, options.clone())
            .with_default(default_options)
            .with_page_size(32)
            .prompt();

        match res {
            Ok(selection) => { return selection; }
            Err(_) => {
                cprintln!("<r>Something went wrong. Let's try that again...</>");
            }
        }
    }
}