use sqlx::PgPool;

use crate::{
    db::coffee::add_coffee,
    types::{coffee::NewCoffee, UserId},
    CherryError,
};

pub(crate) async fn add_new_coffee(
    pool: &PgPool,
    user_id: &UserId,
    new_coffee: &NewCoffee,
) -> Result<(), CherryError> {
    add_coffee(pool, user_id, new_coffee).await?;
    Ok(())
}
