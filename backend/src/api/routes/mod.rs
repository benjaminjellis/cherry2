use crate::{
    api::dtos::NewCoffeeRequestDto,
    coffee, roaster,
    types::{coffee::CoffeeId, roaster::RoasterId, UserId},
    AppState, CherryError,
};
use axum::{
    extract::{Path, State},
    Json,
};
use chrono::Utc;
use uuid::Uuid;

use super::dtos::{CoffeeDto, NewRoasterDto, RoasterDto};

pub(crate) async fn add_new_coffee(
    State(state): State<AppState>,
    Json(payload): Json<NewCoffeeRequestDto>,
) -> Result<Json<CoffeeDto>, CherryError> {
    let pool = &state.db_pool;
    let new_coffee = payload.into_new_coffee(CoffeeId::new(), Utc::now());
    let coffee = coffee::add_new_coffee(pool, &UserId::test_user(), &new_coffee).await?;

    let resp: CoffeeDto = coffee.into();
    Ok(Json(resp))
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
) -> Result<Json<RoasterDto>, CherryError> {
    let pool = &state.db_pool;
    let new_roaster = payload.into_new_roaster(RoasterId::new());
    let roaster = roaster::add_new_roaster(pool, new_roaster).await?;
    Ok(Json(roaster.into()))
}

pub(crate) async fn get_roaster(
    State(state): State<AppState>,
    Path(roster_id): Path<Uuid>,
) -> Result<Json<RoasterDto>, CherryError> {
    let pool = &state.db_pool;
    let roaster = roaster::get_roaster(pool, roster_id.into()).await?;
    Ok(Json(roaster.into()))
}

pub(crate) async fn delete_coffee(
    State(state): State<AppState>,
    Path(coffee_id): Path<Uuid>,
) -> Result<(), CherryError> {
    let pool = &state.db_pool;
    coffee::delete_coffee(pool, &coffee_id.into(), &UserId::test_user()).await?;
    Ok(())
}
