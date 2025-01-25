use crate::types::experiment::Experiment;
use sqlx::PgPool;

use crate::types::UserId;

use super::CherryDbError;

pub(crate) struct ExperimentDb {}

pub(crate) async fn add_experiment(
    pool: &PgPool,
    user_id: &UserId,
) -> Result<Experiment, CherryDbError> {
    // let experiment = sqlx::query_as!(
    //     ExperimentDb,
    //     r#"
    //     with inserted as (
    //     insert into experiments (id, user_id, name, roaster,
    //         roast_date, origin, varetial, process, tasting_notes,
    //         liked, in_current_rotation, added, last_updated)
    //     values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
    //     returning *
    //     )
    //     select
    //         inserted.*,  roasters.name AS roaster_name
    //     from inserted
    //     inner join
    //      roasters
    //     on
    //         inserted.roaster = roasters.id;
    //     "#,
    //     coffee.id.as_uuid(),
    //     user_id.as_uuid(),
    //     coffee.name,
    //     coffee.roaster.as_uuid(),
    //     coffee.roast_date,
    //     coffee.origin,
    //     coffee.varetial,
    //     coffee.process,
    //     coffee.tasting_notes,
    //     coffee.liked,
    //     coffee.in_current_rotation,
    //     coffee.added.naive_utc(),
    //     coffee.added.naive_utc()
    // )
    // .fetch_one(pool)
    // .await
    // .map_err(|e| match e {
    //     sqlx::Error::Database(db_error) if db_error.constraint() == Some("coffees_id_key") => {
    //         CherryDbError::KeyConflict("id already used".into())
    //     }
    //     _ => CherryDbError::InsertFailed(e.to_string()),
    // })?;
    // Ok(coffee.into())
    todo!()
}
