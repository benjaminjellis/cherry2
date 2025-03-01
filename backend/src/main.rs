mod api;
mod coffee;
mod db;
mod error;
mod experiments;
mod roaster;
mod state;
mod types;

use api::routes::{
    add_experiment, add_new_coffee, add_new_roaster, delete_coffee, delete_experiment,
    get_all_roasters, get_coffee, get_coffees, get_experiment, get_experiments_for_coffee,
    get_roaster, get_roasters_by_name, get_roasters_for_user,
};

pub(crate) use error::CherryError;

use axum::{
    http::Method,
    routing::{delete, get, post},
    Router,
};
use http::header::{AUTHORIZATION, CONTENT_TYPE};
use tower_http::cors::{Any, CorsLayer};

use state::AppState;
#[cfg(not(target_env = "msvc"))]
use tikv_jemallocator::Jemalloc;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

// #[cfg(not(target_env = "msvc"))]
// #[global_allocator]
// static GLOBAL: Jemalloc = Jemalloc;
//

#[tokio::main]
async fn main() -> Result<(), CherryError> {
    dotenvy::dotenv().ok();

    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer())
        .init();

    let database_url = std::env::var("DATABASE_URL").map_err(CherryError::EnvVar)?;

    let db_pool = db::create_db_pool(&database_url).await?;

    db::MIGRATOR
        .run(&db_pool)
        .await
        .map_err(CherryError::Migration)?;

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
        .route("/roaster", post(add_new_roaster).get(get_roasters_for_user))
        .route("/roaster/search", get(get_roasters_by_name))
        .route("/roaster/all", get(get_all_roasters))
        .route("/roaster/{roaster_id}", get(get_roaster))
        .with_state(app_state);

    let cors = CorsLayer::new()
        // allow `GET` and `POST` when accessing the resource
        .allow_methods([Method::GET, Method::POST, Method::DELETE])
        .allow_headers([AUTHORIZATION, CONTENT_TYPE])
        // TODO: restrict the origin when deployed
        .allow_origin(Any);

    let app = Router::new().nest("/api", api_router).layer(cors);

    tracing::info!("test");

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))?;

    axum::serve(listener, app)
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))?;

    Ok(())
}
