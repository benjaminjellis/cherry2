use crate::{
    api::dtos::NewCoffeeRequestDto,
    coffee, experiments, roaster,
    types::{coffee::CoffeeId, experiment::ExperimentId, roaster::RoasterId},
    CherryError,
};
use axum::{
    extract::{Path, Query, State},
    Extension, Json,
};
use chrono::Utc;
use http::StatusCode;
use serde::Deserialize;

use super::{
    dtos::{CoffeeDto, ExperimentDto, NewExperimentDto, NewRoasterDto, RoasterDto},
    state::AppState,
    UserClaims,
};

/// Adds a new coffee to the database.
///
/// # Arguments
///
/// * `state` - The application state, containing the database pool.
/// * `payload` - The JSON payload containing the new coffee request.
///
/// # Returns
///
/// Returns a `Result` containing a tuple with:
///
/// * `StatusCode::CREATED` - If the coffee was successfully added.
/// * `Json<CoffeeDto>` - The newly created coffee as a JSON response.
///
/// Returns a `CherryError` if any error occurred during the process.
pub(crate) async fn add_new_coffee(
    State(state): State<AppState>,
    Extension(user_claims): Extension<UserClaims>,
    Json(payload): Json<NewCoffeeRequestDto>,
) -> Result<(StatusCode, Json<CoffeeDto>), CherryError> {
    let pool = &state.db_pool;
    let new_coffee = payload.into_new_coffee(CoffeeId::new(), Utc::now());
    let coffee = coffee::add_new_coffee(pool, &user_claims.sub, &new_coffee).await?;

    let resp: CoffeeDto = coffee.into();
    Ok((StatusCode::CREATED, Json(resp)))
}

pub(crate) async fn get_coffee(
    State(state): State<AppState>,
    Extension(user_claims): Extension<UserClaims>,
    Path(coffee_id): Path<CoffeeId>,
) -> Result<Json<CoffeeDto>, CherryError> {
    let pool = &state.db_pool;
    let coffee = coffee::get_coffee(pool, &coffee_id, &user_claims.sub).await?;
    coffee
        .map(|coffee| Json(coffee.into()))
        .ok_or(CherryError::NotFound(coffee_id.into_uuid()))
}

pub(crate) async fn get_coffees(
    State(state): State<AppState>,
    Extension(user_claims): Extension<UserClaims>,
) -> Result<Json<Vec<CoffeeDto>>, CherryError> {
    let pool = &state.db_pool;
    let coffees = coffee::get_all_coffees_for_a_user(pool, &user_claims.sub).await?;
    Ok(Json(coffees.into_iter().map(Into::into).collect()))
}

pub(crate) async fn add_new_roaster(
    State(state): State<AppState>,
    Extension(_): Extension<UserClaims>,
    Json(payload): Json<NewRoasterDto>,
) -> Result<(StatusCode, Json<RoasterDto>), CherryError> {
    let pool = &state.db_pool;
    let new_roaster = payload.into_new_roaster(RoasterId::new());
    let roaster = roaster::add_new_roaster(pool, new_roaster).await?;
    Ok((StatusCode::CREATED, Json(roaster.into())))
}

pub(crate) async fn get_all_roasters(
    State(state): State<AppState>,
    Extension(_): Extension<UserClaims>,
) -> Result<Json<Vec<RoasterDto>>, CherryError> {
    let pool = &state.db_pool;
    let all_roasters = roaster::get_all_roasters(pool).await?;
    Ok(Json(all_roasters.into_iter().map(Into::into).collect()))
}

pub(crate) async fn get_roaster(
    State(state): State<AppState>,
    Path(roster_id): Path<RoasterId>,
    Extension(_): Extension<UserClaims>,
) -> Result<(StatusCode, Json<RoasterDto>), CherryError> {
    let pool = &state.db_pool;
    let roaster = roaster::get_roaster(pool, roster_id).await?;
    Ok((StatusCode::CREATED, Json(roaster.into())))
}

#[derive(Deserialize)]
pub(crate) struct RoasterSearch {
    pub(crate) name: String,
}

pub(crate) async fn get_roasters_by_name(
    State(state): State<AppState>,
    Query(search): Query<RoasterSearch>,
    Extension(_): Extension<UserClaims>,
) -> Result<Json<Vec<RoasterDto>>, CherryError> {
    let pool = &state.db_pool;
    let roaster = roaster::get_roasters_by_name(pool, search.name).await?;
    Ok(Json(roaster.into_iter().map(Into::into).collect()))
}

pub(crate) async fn get_roasters_for_user(
    State(state): State<AppState>,
    Extension(user_claims): Extension<UserClaims>,
) -> Result<Json<Vec<RoasterDto>>, CherryError> {
    let pool = &state.db_pool;
    let roaster = roaster::get_roasters_for_user(pool, &user_claims.sub).await?;
    Ok(Json(roaster.into_iter().map(Into::into).collect()))
}

pub(crate) async fn delete_coffee(
    State(state): State<AppState>,
    Path(coffee_id): Path<CoffeeId>,
    Extension(user_claims): Extension<UserClaims>,
) -> Result<StatusCode, CherryError> {
    let pool = &state.db_pool;
    coffee::delete_coffee(pool, &coffee_id, &user_claims.sub).await?;
    Ok(StatusCode::GONE)
}

pub(crate) async fn add_experiment(
    State(state): State<AppState>,
    Path(coffee_id): Path<CoffeeId>,
    Extension(user_claims): Extension<UserClaims>,
    Json(new_experiment): Json<NewExperimentDto>,
) -> Result<(StatusCode, Json<ExperimentDto>), CherryError> {
    let pool = &state.db_pool;
    let added_experiment: ExperimentDto =
        experiments::add_new_experiment(pool, &user_claims.sub, &coffee_id, new_experiment.into())
            .await?
            .into();

    Ok((StatusCode::CREATED, Json(added_experiment)))
}

pub(crate) async fn get_experiments_for_coffee(
    State(state): State<AppState>,
    Path(coffee_id): Path<CoffeeId>,
    Extension(user_claims): Extension<UserClaims>,
) -> Result<Json<Vec<ExperimentDto>>, CherryError> {
    let pool = &state.db_pool;
    let experiments = experiments::get_experiments_for_coffee(pool, &user_claims.sub, &coffee_id)
        .await?
        .into_iter()
        .map(Into::into)
        .collect::<Vec<_>>();
    Ok(Json(experiments))
}

pub(crate) async fn get_experiment(
    State(state): State<AppState>,
    Path((_, experiment_id)): Path<(CoffeeId, ExperimentId)>,
    Extension(user_claims): Extension<UserClaims>,
) -> Result<Json<ExperimentDto>, CherryError> {
    let pool = &state.db_pool;
    let experiment = experiments::get_experiment(pool, &user_claims.sub, &experiment_id)
        .await?
        .map(Into::into);
    match experiment {
        Some(experiment) => Ok(Json(experiment)),
        None => Err(CherryError::NotFound(experiment_id.into_uuid())),
    }
}

pub(crate) async fn delete_experiment(
    State(state): State<AppState>,
    Path((_, experiment_id)): Path<(CoffeeId, ExperimentId)>,
    Extension(user_claims): Extension<UserClaims>,
) -> Result<StatusCode, CherryError> {
    let pool = &state.db_pool;
    experiments::delete_experiment(pool, &user_claims.sub, &experiment_id).await?;
    Ok(StatusCode::GONE)
}

pub(crate) async fn like_coffee(
    State(state): State<AppState>,
    Path((_, experiment_id)): Path<(CoffeeId, ExperimentId)>,
    Extension(user_claims): Extension<UserClaims>,
) -> Result<StatusCode, CherryError> {
    let pool = &state.db_pool;
    experiments::delete_experiment(pool, &user_claims.sub, &experiment_id).await?;
    Ok(StatusCode::GONE)
}

pub(crate) async fn like_experiment(
    State(state): State<AppState>,
    Extension(user_claims): Extension<UserClaims>,
    Path(experiment_id): Path<ExperimentId>,
) -> Result<(), CherryError> {
    experiments::like_experiment(&state.db_pool, &user_claims.sub, &experiment_id).await?;
    Ok(())
}
