use crate::types::{
    coffee::CoffeeId,
    experiment::{Experiment, ExperimentId},
    UserId,
};
use chrono::{NaiveDate, NaiveDateTime};
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

pub(crate) async fn delete_experiment(
    pool: &PgPool,
    user_id: &UserId,
    experiment_id: &ExperimentId,
) -> Result<(), CherryDbError> {
    let a = sqlx::query!(
        r#"delete from experiments where experiments.id = $1 and experiments.user_id = $2"#,
        experiment_id.as_uuid(),
        user_id.as_uuid(),
    )
    .execute(pool)
    .await
    .map_err(|err| CherryDbError::Delete(err.to_string()))?;

    if a.rows_affected() < 1 {
        Err(CherryDbError::Unauthorised)
    } else {
        Ok(())
    }
}

pub(crate) async fn get_experiment(
    pool: &PgPool,
    user_id: &UserId,
    experiment_id: &ExperimentId,
) -> Result<Option<Experiment>, CherryDbError> {
    let a = sqlx::query_as!(
        ExperimentDb,
        r#"
            select * from experiments
            where experiments.user_id = $1 and experiments.id = $2"#,
        user_id.as_uuid(),
        experiment_id.as_uuid()
    )
    .fetch_optional(pool)
    .await
    .map_err(|err| CherryDbError::Select(err.to_string()))?
    .map(TryInto::try_into)
    .transpose()?;

    Ok(a)
}

pub(crate) async fn get_experiments_for_coffee(
    pool: &PgPool,
    user_id: &UserId,
    coffee_id: &CoffeeId,
) -> Result<Vec<Experiment>, CherryDbError> {
    let experiments = sqlx::query_as!(
        ExperimentDb,
        r#"
            select * from experiments
            where experiments.user_id = $1 and experiments.coffee_id = $2"#,
        user_id.as_uuid(),
        coffee_id.as_uuid()
    )
    .fetch_all(pool)
    .await
    .map_err(|err| CherryDbError::Select(err.to_string()))?
    .into_iter()
    .map(TryInto::try_into)
    .collect::<Result<_, CherryDbError>>()?;

    Ok(experiments)
}
