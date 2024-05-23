pub mod search;
mod utils;

use color_print::{cprintln, cstr};
use getch::Getch;
use terminal_menu::{run, menu, label, submenu, back_button, button, mut_menu, TerminalMenu};

pub fn init_menu_loop() {
    loop {
        let menu = build_menu();
        run(&menu);

        if mut_menu(&menu).canceled() {
            break;
        }

        utils::clear_term();
        run_selected_action(get_selected_item_name(&menu));

        if if_to_continue() {
            utils::clear_term();
        } else {
            break;
        }
    }

    cprintln!("\n\n<bold>Goodbye!</>\n\n");
}

fn build_menu() -> TerminalMenu {
    menu(vec![
        label("--------------------"),
        label(cstr!("<bold,green>Welcome to GameVault!</>")),
        label(""),
        label(cstr!("<italic>Press the <bold>arrow keys</> to navigate the menu</>")),
        label(cstr!("<italic>Press <bold>Enter</> to select an item</>")),
        label(cstr!("<italic>Press <bold,red>Q</> to quit</>")),
        label("--------------------"),
        label(""),
        submenu("Search Board Games", vec![
            label("--------------------"),
            label("Select a search criteria"),
            label("--------------------"),
            button("Search by Name"),
            back_button("Back"),
        ]),
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

fn run_selected_action(selected: String) {
    match selected.as_str() {
        "Search by Name" => search::search_games_by_name(),
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