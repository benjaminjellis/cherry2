use crate::types::experiment::Experiment;
use chrono::{DateTime, NaiveDate, NaiveDateTime, Utc};
use sqlx::PgPool;
use uuid::Uuid;

use super::CherryDbError;

pub(crate) struct ExperimentDb {
    pub(crate) id: Uuid,
    pub(crate) date: NaiveDate,
    pub(crate) coffee_id: Uuid,
    pub(crate) brew_method: String,
    pub(crate) grinder: String,
    pub(crate) grind_setting: String,
    pub(crate) recipe: String,
    pub(crate) liked: bool,
    pub(crate) user_id: Uuid,
    pub(crate) notes: String,
    pub(crate) added: NaiveDateTime,
    pub(crate) last_updated: NaiveDateTime,
}

pub(crate) async fn add_new_experiment(
    pool: &PgPool,
    experiment: ExperimentDb,
) -> Result<Experiment, CherryDbError> {
    let new_experiment = sqlx::query_as!(
        ExperimentDb,
        r#"
        with inserted as (
            insert into experiments (
                id, date, coffee_id, brew_method, grinder, grind_setting, 
                recipe, liked, user_id, notes, added, last_updated
            ) 
        VALUES (
            $1, $2, $3, $4, $5,
            $6, $7, $8, $9, $10,
            $11, $12
            ) 
         RETURNING *
        )
        SELECT * FROM inserted;
        "#,
        experiment.id,
        experiment.date,
        experiment.coffee_id,
        experiment.brew_method,
        experiment.grinder,
        experiment.grind_setting,
        experiment.recipe,
        experiment.liked,
        experiment.user_id,
        experiment.notes,
        experiment.added,
        experiment.last_updated
    )
    .fetch_one(pool)
    .await
    .map_err(|e| match e {
        sqlx::Error::Database(db_error) if db_error.constraint() == Some("coffees_id_key") => {
            CherryDbError::KeyConflict("id already used".into())
        }
        _ => CherryDbError::InsertFailed(e.to_string()),
    })?
    .try_into()?;

    Ok(new_experiment)
}
