use sqlx::PgPool;

use crate::{
    db::coffee as db_coffee,
    types::{
        coffee::{Coffee, NewCoffee},
        UserId,
    },
    CherryError,
};

pub(crate) async fn add_new_coffee(
    pool: &PgPool,
    user_id: &UserId,
    new_coffee: &NewCoffee,
) -> Result<Coffee, CherryError> {
    let coffee = db_coffee::add_coffee(pool, user_id, new_coffee).await?;
    Ok(coffee)
}

pub(crate) async fn get_all_coffees_for_a_user(
    pool: &PgPool,
    user_id: &UserId,
) -> Result<Vec<Coffee>, CherryError> {
    let coffees = db_coffee::get_all_coffees_for_user(pool, user_id).await?;
    Ok(coffees)
}
