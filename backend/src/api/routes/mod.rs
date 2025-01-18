use crate::{
    api::dtos::NewCoffeeRequestDto,
    coffee,
    types::{coffee::CoffeeId, UserId},
    AppState, CherryError,
};
use axum::{extract::State, Json};
use chrono::Utc;

use super::dtos::CoffeeDto;

pub(crate) async fn add_new_coffee(
    State(state): State<AppState>,
    Json(payload): Json<NewCoffeeRequestDto>,
) -> Result<Json<CoffeeDto>, CherryError> {
    let pool = &state.db_pool;
    let new_coffee = payload.to_new_coffee(CoffeeId::new(), Utc::now());
    coffee::add_new_coffee(pool, &UserId::test_user(), &new_coffee).await?;

    let resp: CoffeeDto = new_coffee.into();
    Ok(Json(resp))
}
