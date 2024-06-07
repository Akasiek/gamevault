use color_print::{cprintln, cstr};
use getch::Getch;
use terminal_menu::{back_button, button, label, menu, mut_menu, run, submenu, TerminalMenu};

use crate::db::models::user::User;
use crate::utils::check_db_users::check_user;
use crate::utils::clear_term;
use crate::utils::login::Login;

pub mod search_games;
mod log_in;
mod create_review;
mod add_category_to_game;
mod create_game;

pub fn main() {
    let login = log_in::ask_for_login();

    if !check_user(&login) {
        cprintln!("\n<bold,red>Invalid login credentials!</>\n");
        return;
    }

    init_menu_loop(login);
}

pub fn init_menu_loop(login: Login) {
    let user = login.get_user().unwrap();

    loop {
        let menu = build_menu(&user);
        run(&menu);

        if mut_menu(&menu).canceled() {
            break;
        }

        clear_term();
        run_selected_action(get_selected_item_name(&menu), &login);

        if !if_to_continue() {
            break;
        }
    }

    cprintln!("\n\n<bold>Goodbye!</>\n\n");
}

fn build_menu(user: &User) -> TerminalMenu {
    let role = user.role.to_string();

    return match role.as_str() {
        "ADMIN" => build_admin_menu(user),
        "USER" => build_user_menu(user),
        _ => panic!("Invalid role"),
    };
}

fn build_admin_menu(user: &User) -> TerminalMenu {
    menu(vec![
        label("--------------------"),
        label(format!(cstr!("<bold,green>Welcome to GameVault, {}!</>"), user.username)),
        label(""),
        label(cstr!(
            "<italic>Press the <bold>arrow keys</> to navigate the menu</>"
        )),
        label(cstr!("<italic>Press <bold>Enter</> to select an item</>")),
        label(cstr!("<italic>Press <bold,red>Q</> to quit</>")),
        label("--------------------"),
        label(""),
        submenu(
            "Search Board Games",
            vec![
                label("--------------------"),
                label("Select a search criteria"),
                label("--------------------"),
                button("Search by Name"),
                button("Search by Type"),
                button("Search by Category"),
                button("Search by Mechanic"),
                back_button("Back"),
            ],
        ),
        button("Create Game"),
        button("Add Category to Game"),
        button("Create Review"),
    ])
}

fn build_user_menu(user: &User) -> TerminalMenu {
    menu(vec![
        label("--------------------"),
        label(format!(cstr!("<bold,green>Welcome to GameVault, {}!</>"), user.username)),
        label(""),
        label(cstr!(
            "<italic>Press the <bold>arrow keys</> to navigate the menu</>"
        )),
        label(cstr!("<italic>Press <bold>Enter</> to select an item</>")),
        label(cstr!("<italic>Press <bold,red>Q</> to quit</>")),
        label("--------------------"),
        label(""),
        submenu(
            "Search Board Games",
            vec![
                label("--------------------"),
                label("Select a search criteria"),
                label("--------------------"),
                button("Search by Name"),
                button("Search by Type"),
                button("Search by Category"),
                button("Search by Mechanic"),
                back_button("Back"),
            ],
        ),
        button("Create Review"),
    ])
}


/// Get the name of the selected item in the menu.
/// If the selected item is a submenu, get the name of the selected item in the submenu.
fn get_selected_item_name(menu: &TerminalMenu) -> String {
    let mut menu = mut_menu(menu);

    match menu.selected_item_name() {
        "Search Board Games" => {
            let submenu = menu.get_submenu("Search Board Games");
            let selected = submenu.selected_item_name().to_string();
            selected
        }
        default => default.to_string(),
    }
}

fn run_selected_action(selected: String, login: &Login) {
    let mut conn = login.connect_or_panic();
    let user = login.get_user().unwrap();

    match selected.as_str() {
        "Search by Name" => search_games::search_games_by_name(&mut conn),
        "Search by Type" => search_games::search_games_by_type(&mut conn),
        "Search by Category" => search_games::search_games_by_category(&mut conn),
        "Search by Mechanic" => search_games::search_games_by_mechanic(&mut conn),
        "Create Game" => create_game::main(&mut conn),
        "Add Category to Game" => add_category_to_game::main(&mut conn),
        "Create Review" => create_review::main(&mut conn, &user),
        _ => println!("Invalid selection"),
    }
}

/// Ask the user if they want to continue.
/// Returns true if the user wants to continue, false if they want to quit.
fn if_to_continue() -> bool {
    cprintln!("Press <bold,red>Q</> to quit, or <italic>any other key</> to continue");

    let getch = Getch::new();
    let byte = getch.getch();

    !matches!(byte.unwrap(), b'q' | b'Q')
}
