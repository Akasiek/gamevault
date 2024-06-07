use sqlx::{Pool, Postgres};
use sqlx::postgres::PgPoolOptions;
use anyhow::Context;
use color_print::cprintln;

#[tokio::main]
async fn main() -> Result<(), sqlx::Error> {
    let database_url = dotenvy::var("DATABASE_URL")
        .context("DATABASE_URL must be set").unwrap();

    let pool = get_connection(&database_url).await;

    print_ten_latest_games(&pool).await;

    print_categories_with_5_15_games(&pool).await;

    print_users_and_number_of_reviews(&pool).await;

    Ok(())
}

async fn get_connection(database_url: &str) -> Pool<Postgres> {
    PgPoolOptions::new()
        .max_connections(5)
        .connect(database_url)
        .await
        .expect("Failed to connect to Postgres.")
}

async fn print_ten_latest_games(pool: &Pool<Postgres>) {
    let result = sqlx::query!("SELECT name, description FROM \"Games\" ORDER BY id DESC LIMIT 10")
        .fetch_all(pool)
        .await
        .expect("Failed to fetch games.");

    cprintln!("\n<strong>Latest 10 games:</>\n");
    for record in result {
        let description = record.description.unwrap_or_else(|| String::from("No description available."));

        cprintln!("<strong><b>{}</></> - <i>{}</>", record.name, description);
    }

    println!("\n");
}

async fn print_categories_with_5_15_games(pool: &Pool<Postgres>) {
    let result = sqlx::query!("SELECT c.name, COUNT(g.id) AS game_count FROM \"Categories\" c
        INNER JOIN \"GameCategories\" gc ON c.id = gc.category_id
        INNER JOIN \"Games\" g ON gc.game_id = g.id
        GROUP BY c.id
        HAVING COUNT(g.id) > 5 AND COUNT(g.id) < 15")
        .fetch_all(pool)
        .await
        .expect("Failed to fetch categories.");

    cprintln!("\n<strong>Categories with more than 5 and less than 15 games:</>\n");
    for record in result {
        cprintln!("<strong><b>{}</></> - <i>{:?}</>", record.name, record.game_count.unwrap_or(0));
    }

    println!("\n");
}

async fn print_users_and_number_of_reviews(pool: &Pool<Postgres>) {
    let result = sqlx::query!("SELECT u.username, COUNT(gr.id) AS review_count FROM \"Users\" u
        LEFT JOIN \"GameReviews\" gr ON u.id = gr.user_id
        WHERE u.role = 'USER'
        AND gr.id IS NOT NULL
        GROUP BY u.id")
        .fetch_all(pool)
        .await
        .expect("Failed to fetch users.");

    cprintln!("\n<strong>Users and the number of reviews they have made (exclude users without reviews):</>\n");
    for record in result {
        cprintln!("<strong><b>{}</></> - <i>{:?}</>", record.username, record.review_count.unwrap_or(0));
    }

    println!("\n");
}