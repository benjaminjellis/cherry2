use sqlx::PgPool;

use crate::{
    db,
    types::{
        coffee::CoffeeId,
        experiment::{Experiment, ExperimentId, NewExperiment},
        UserId,
    },
    CherryError,
};

pub(crate) async fn add_new_experiment(
    pool: &PgPool,
    user_id: &UserId,
    coffee_id: &CoffeeId,
    new_experiment: NewExperiment,
) -> Result<Experiment, CherryError> {
    let added_experiment =
        db::experiments::add_new_experiment(pool, new_experiment.into_db(user_id, coffee_id))
            .await?;
    Ok(added_experiment)
}

pub(crate) async fn delete_experiment(
    pool: &PgPool,
    user_id: &UserId,
    experiment_id: &ExperimentId,
) -> Result<(), CherryError> {
    db::experiments::delete_experiment(pool, user_id, experiment_id).await?;
    Ok(())
}

pub(crate) async fn get_experiment(
    pool: &PgPool,
    user_id: &UserId,
    experiment_id: &ExperimentId,
) -> Result<Option<Experiment>, CherryError> {
    let experiment = db::experiments::get_experiment(pool, user_id, experiment_id).await?;
    Ok(experiment)
}

pub(crate) async fn get_experiments_for_coffee(
    pool: &PgPool,
    user_id: &UserId,
    coffee_id: &CoffeeId,
) -> Result<Vec<Experiment>, CherryError> {
    let experiments = db::experiments::get_experiments_for_coffee(pool, user_id, coffee_id).await?;
    Ok(experiments)
}

pub(crate) async fn like_experiment(
    pool: &PgPool,
    user_id: &UserId,
    experiment_id: &ExperimentId,
) -> Result<(), CherryError> {
    db::experiments::delete_experiment(pool, user_id, experiment_id).await?;
    Ok(())
}
