use sqlx::PgPool;

use crate::{
    db::roasters as db_roaster,
    types::roaster::{NewRoaster, Roaster, RoasterId},
    CherryError,
};

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

    roaster.ok_or(CherryError::NotFound(
        "Roaster with specified id not found".into(),
    ))
}
