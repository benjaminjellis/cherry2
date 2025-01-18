mod api;
mod coffee;
mod db;
mod error;
mod state;
mod types;

use api::routes::add_new_coffee;
pub(crate) use error::CherryError;

use axum::{
    routing::{get, post},
    Router,
};

use state::AppState;
#[cfg(not(target_env = "msvc"))]
use tikv_jemallocator::Jemalloc;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt, EnvFilter};

#[cfg(not(target_env = "msvc"))]
#[global_allocator]
static GLOBAL: Jemalloc = Jemalloc;

#[tokio::main]
async fn main() -> Result<(), CherryError> {
    dotenvy::dotenv().ok();

    let filter_layer = EnvFilter::new("backend=trace");

    tracing_subscriber::registry()
        .with(filter_layer)
        .with(tracing_subscriber::fmt::layer())
        .init();

    let database_url = std::env::var("DATABASE_URL")
        .map_err(|_| CherryError::Setup("Failed to get db url from env".to_string()))?;

    let db_pool = db::create_db_pool(&database_url).await?;

    db::MIGRATOR
        .run(&db_pool)
        .await
        .map_err(|err| CherryError::Setup(format!("Failed to run migration {}", err)))?;

    let app_state = AppState { db_pool };

    let app = Router::new()
        .route("/coffee", post(add_new_coffee))
        .route("/", get(|| async { "Hello, World!" }))
        .with_state(app_state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))?;

    axum::serve(listener, app)
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))?;

    Ok(())
}
