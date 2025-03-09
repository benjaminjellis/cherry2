use sqlx::PgPool;

use crate::{
    db::roasters as db_roaster,
    types::{
        roaster::{NewRoaster, Roaster, RoasterId},
        UserId,
    },
    CherryError,
};

pub(crate) async fn get_all_roasters(pool: &PgPool) -> Result<Vec<Roaster>, CherryError> {
    Ok(db_roaster::get_all_roasters(pool).await?)
}

pub(crate) async fn get_roasters_by_name(
    pool: &PgPool,
    roaster_name: String,
) -> Result<Vec<Roaster>, CherryError> {
    Ok(db_roaster::search_roasters_by_name(pool, roaster_name).await?)
}

pub(crate) async fn add_new_roaster(
    pool: &PgPool,
    new_roaster: NewRoaster,
) -> Result<NewRoaster, CherryError> {
    db_roaster::add_roaster(pool, &new_roaster).await?;

    Ok(new_roaster)
}

pub(crate) async fn get_roaster(
    pool: &PgPool,
    roster_id: RoasterId,
) -> Result<Roaster, CherryError> {
    let roaster = db_roaster::get_roaster_by_id(pool, roster_id).await?;

    roaster.ok_or(CherryError::NotFound(roster_id.into_uuid()))
}

/// Get all the roasters that a user has logged a coffee for before
pub(crate) async fn get_roasters_for_user(
    pool: &PgPool,
    user_id: &UserId,
) -> Result<Vec<Roaster>, CherryError> {
    Ok(db_roaster::get_roasters_for_user(pool, user_id).await?)
}
