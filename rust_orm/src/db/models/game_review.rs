use diesel::prelude::*;

use crate::db::models::game::Game;
use crate::db::models::user::User;
use crate::db::schema;

#[derive(Identifiable, Selectable, Queryable, Associations, Debug)]
#[diesel(belongs_to(Game))]
#[diesel(belongs_to(User))]
#[diesel(table_name = schema::game_reviews)]
#[diesel(primary_key(game_id, user_id))]
pub struct GameReview {
    pub id: i32,
    pub game_id: i32,
    pub user_id: i32,
    // Number from 1 to 10
    pub rating: i32,
    pub review: String,
}

#[derive(Insertable)]
#[diesel(table_name = schema::game_reviews)]
pub struct GameReviewForm {
    pub game_id: i32,
    pub user_id: i32,
    pub rating: i32,
    pub review: Option<String>,
}

impl GameReview {
    pub fn insert(conn: &mut PgConnection, game_id: i32, user_id: i32, rating: i32, review: Option<String>) -> QueryResult<usize> {
        let form = GameReviewForm {
            game_id,
            user_id,
            rating,
            review,
        };

        diesel::insert_into(schema::game_reviews::table)
            .values(&form)
            .execute(conn)
    }
}