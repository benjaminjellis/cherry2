mod api;
mod coffee;
mod db;
mod error;
mod experiments;
mod roaster;
mod types;

pub(crate) use error::CherryError;

#[cfg(not(target_env = "msvc"))]
use tikv_jemallocator::Jemalloc;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

#[cfg(not(target_env = "msvc"))]
#[global_allocator]
static GLOBAL: Jemalloc = Jemalloc;

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

    let router = api::build_router(db_pool).await?;

    tracing::info!("test");

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))?;

    axum::serve(listener, router)
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))?;

    Ok(())
}
