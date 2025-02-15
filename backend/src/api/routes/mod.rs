use crate::{
    api::dtos::NewCoffeeRequestDto,
    coffee, experiments, roaster,
    types::{coffee::CoffeeId, roaster::RoasterId, UserId},
    AppState, CherryError,
};
use axum::{
    extract::{Path, Query, State},
    Json,
};
use chrono::Utc;
use http::StatusCode;
use serde::Deserialize;
use uuid::Uuid;

use super::dtos::{CoffeeDto, ExperimentDto, NewExperimentDto, NewRoasterDto, RoasterDto};

pub(crate) async fn add_new_coffee(
    State(state): State<AppState>,
    Json(payload): Json<NewCoffeeRequestDto>,
) -> Result<(StatusCode, Json<CoffeeDto>), CherryError> {
    let pool = &state.db_pool;
    let new_coffee = payload.into_new_coffee(CoffeeId::new(), Utc::now());
    let coffee = coffee::add_new_coffee(pool, &UserId::test_user(), &new_coffee).await?;

    let resp: CoffeeDto = coffee.into();
    Ok((StatusCode::CREATED, Json(resp)))
}

pub(crate) async fn get_coffee(
    State(state): State<AppState>,
    Path(coffee_id): Path<Uuid>,
) -> Result<Json<CoffeeDto>, CherryError> {
    let pool = &state.db_pool;
    let coffee = coffee::get_coffee(pool, &coffee_id.into(), &UserId::test_user()).await?;
    coffee
        .map(|coffee| Json(coffee.into()))
        .ok_or(CherryError::NotFound("Coffee not found".into()))
}

pub(crate) async fn get_coffees(
    State(state): State<AppState>,
) -> Result<Json<Vec<CoffeeDto>>, CherryError> {
    let pool = &state.db_pool;
    let coffees = coffee::get_all_coffees_for_a_user(pool, &UserId::test_user()).await?;
    Ok(Json(coffees.into_iter().map(Into::into).collect()))
}

pub(crate) async fn add_new_roaster(
    State(state): State<AppState>,
    Json(payload): Json<NewRoasterDto>,
) -> Result<(StatusCode, Json<RoasterDto>), CherryError> {
    let pool = &state.db_pool;
    let new_roaster = payload.into_new_roaster(RoasterId::new());
    let roaster = roaster::add_new_roaster(pool, new_roaster).await?;
    Ok((StatusCode::CREATED, Json(roaster.into())))
}

pub(crate) async fn get_all_roasters(
    State(state): State<AppState>,
) -> Result<Json<Vec<RoasterDto>>, CherryError> {
    let pool = &state.db_pool;
    let all_roasters = roaster::get_all_roasters(pool).await?;
    Ok(Json(all_roasters.into_iter().map(Into::into).collect()))
}

pub(crate) async fn get_roaster(
    State(state): State<AppState>,
    Path(roster_id): Path<Uuid>,
) -> Result<(StatusCode, Json<RoasterDto>), CherryError> {
    let pool = &state.db_pool;
    let roaster = roaster::get_roaster(pool, roster_id.into()).await?;
    Ok((StatusCode::CREATED, Json(roaster.into())))
}

#[derive(Deserialize)]
pub(crate) struct RoasterSearch {
    pub(crate) name: String,
}

pub(crate) async fn get_roasters_by_name(
    State(state): State<AppState>,
    Query(search): Query<RoasterSearch>,
) -> Result<Json<Vec<RoasterDto>>, CherryError> {
    let pool = &state.db_pool;
    let roaster = roaster::get_roasters_by_name(pool, search.name).await?;
    Ok(Json(roaster.into_iter().map(Into::into).collect()))
}

pub(crate) async fn get_roasters_for_user(
    State(state): State<AppState>,
) -> Result<Json<Vec<RoasterDto>>, CherryError> {
    let pool = &state.db_pool;
    let user_id = UserId::test_user();
    let roaster = roaster::get_roasters_for_user(pool, user_id).await?;
    Ok(Json(roaster.into_iter().map(Into::into).collect()))
}

pub(crate) async fn delete_coffee(
    State(state): State<AppState>,
    Path(coffee_id): Path<Uuid>,
) -> Result<StatusCode, CherryError> {
    let pool = &state.db_pool;
    coffee::delete_coffee(pool, &coffee_id.into(), &UserId::test_user()).await?;
    Ok(StatusCode::GONE)
}

pub(crate) async fn add_experiment(
    State(state): State<AppState>,
    Path(coffee_id): Path<Uuid>,
    Json(new_experiment): Json<NewExperimentDto>,
) -> Result<(StatusCode, Json<ExperimentDto>), CherryError> {
    let pool = &state.db_pool;
    let user_id = UserId::test_user();
    let added_experiment: ExperimentDto =
        experiments::add_new_experiment(pool, &user_id, &coffee_id.into(), new_experiment.into())
            .await?
            .into();

    Ok((StatusCode::CREATED, Json(added_experiment)))
}

pub(crate) async fn get_experiments_for_coffee(
    State(state): State<AppState>,
    Path(coffee_id): Path<Uuid>,
) -> Result<Json<Vec<ExperimentDto>>, CherryError> {
    let pool = &state.db_pool;
    let user_id = UserId::test_user();
    let experiments = experiments::get_experiments_for_coffee(pool, &user_id, &coffee_id.into())
        .await?
        .into_iter()
        .map(Into::into)
        .collect::<Vec<_>>();
    Ok(Json(experiments))
}

pub(crate) async fn get_experiment(
    State(state): State<AppState>,
    Path((_, experiment_id)): Path<(Uuid, Uuid)>,
) -> Result<Json<ExperimentDto>, CherryError> {
    let pool = &state.db_pool;
    let user_id = UserId::test_user();
    let experiment = experiments::get_experiment(pool, &user_id, &experiment_id.into())
        .await?
        .map(Into::into);
    match experiment {
        Some(experiment) => Ok(Json(experiment)),
        None => Err(CherryError::NotFound(experiment_id.to_string())),
    }
}

pub(crate) async fn delete_experiment(
    State(state): State<AppState>,
    Path((_, experiment_id)): Path<(Uuid, Uuid)>,
) -> Result<StatusCode, CherryError> {
    let pool = &state.db_pool;
    let user_id = UserId::test_user();
    experiments::delete_experiment(pool, &user_id, &experiment_id.into()).await?;
    Ok(StatusCode::GONE)
}
