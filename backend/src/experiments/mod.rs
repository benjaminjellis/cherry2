use sqlx::PgPool;

use crate::{
    db,
    types::{
        coffee::CoffeeId,
        experiment::{Experiment, NewExperiment},
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
