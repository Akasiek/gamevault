
/// Clear the terminal window
/// If on Windows, use the 'cls' command
/// Otherwise, use the 'clear' command
/// 
/// If command fails, do nothing
pub(crate) fn clear_term() {
    print!("{}[2J", 27 as char);
}