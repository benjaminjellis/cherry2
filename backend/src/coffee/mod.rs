use sqlx::PgPool;

use crate::{
    db::coffee as db_coffee,
    types::{
        coffee::{Coffee, CoffeeId, NewCoffee},
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

pub(crate) async fn get_coffee(
    pool: &PgPool,
    coffee_id: &CoffeeId,
    user_id: &UserId,
) -> Result<Option<Coffee>, CherryError> {
    Ok(db_coffee::get_coffee_by_id(pool, user_id, coffee_id).await?)
}

pub(crate) async fn get_all_coffees_for_a_user(
    pool: &PgPool,
    user_id: &UserId,
) -> Result<Vec<Coffee>, CherryError> {
    let coffees = db_coffee::get_all_coffees_for_user(pool, user_id).await?;
    Ok(coffees)
}

pub(crate) async fn delete_coffee(
    pool: &PgPool,
    coffee_id: &CoffeeId,
    user_id: &UserId,
) -> Result<(), CherryError> {
    db_coffee::delete_coffee(pool, user_id, coffee_id).await?;
    Ok(())
}
