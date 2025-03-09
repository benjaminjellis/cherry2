use axum::{
    routing::{delete, get, post},
    Router,
};
use http::{
    header::{AUTHORIZATION, CONTENT_TYPE},
    Method,
};
use sqlx::PgPool;
use state::AppState;
use tower_http::cors::{Any, CorsLayer};

use routes::*;

use crate::{types::UserId, CherryError};

mod dtos;
mod routes;
use serde::{Deserialize, Serialize};
pub(crate) mod state;

/// User claims
#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct UserClaims {
    /// A unique identifier (UUID), or subject, for the authenticated user. The username might
    /// not be unique in your user pool. The sub claim is the best way to identify a given user.
    pub sub: UserId,
    /// User email
    pub email: String,
    #[serde(rename = "cognito:username")]
    pub username: String,
}

pub(crate) async fn build_router(
    db_pool: PgPool,
    cognito_layer: axum_cognito::CognitoAuthLayer<UserClaims>,
) -> Result<axum::Router, CherryError> {
    let app_state = AppState { db_pool };

    let api_router = Router::new()
        .route("/coffee", post(add_new_coffee).get(get_coffees))
        .route("/coffee/{coffee_id}", delete(delete_coffee).get(get_coffee))
        .route(
            "/coffee/{coffee_id}/experiment",
            get(get_experiments_for_coffee).post(add_experiment),
        )
        .route(
            "/coffee/{coffee_id}/experiment/{experiment_id}",
            delete(delete_experiment).get(get_experiment),
        )
        .route(
            "/coffee/{coffee_id}/experiment/{experiment_id}/like",
            get(like_coffee),
        )
        .route("/roaster", post(add_new_roaster).get(get_roasters_for_user))
        .route("/roaster/search", get(get_roasters_by_name))
        .route("/roaster/all", get(get_all_roasters))
        .route("/roaster/{roaster_id}", get(get_roaster))
        .route("/experiment/{experiment_id}/like", get(like_experiment))
        // .route("/experiment", get(get_experiments_for_user))
        .with_state(app_state);

    let cors = CorsLayer::new()
        // allow `GET` and `POST` when accessing the resource
        .allow_methods([Method::GET, Method::POST, Method::DELETE])
        .allow_headers([AUTHORIZATION, CONTENT_TYPE])
        // TODO: restrict the origin when deployed
        .allow_origin(Any);

    let app = Router::new()
        .nest("/api", api_router)
        .layer(cors)
        .layer(cognito_layer);
    Ok(app)
}
