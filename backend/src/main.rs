mod db;
mod error;
mod routes;

pub(crate) use error::CherryError;

use axum::{routing::get, Router};

#[tokio::main]
async fn main() -> Result<(), CherryError> {
    dotenvy::dotenv().ok();
    let database_url = std::env::var("DATABASE_URL")
        .map_err(|_| CherryError::Setup("Failed to get db url from env".to_string()))?;

    let db_pool = db::create_db_pool(&database_url).await?;

    db::MIGRATOR
        .run(&db_pool)
        .await
        .map_err(|err| CherryError::Setup(format!("Failed to run migration {}", err)))?;

    let app = Router::new().route("/", get(|| async { "Hello, World!" }));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))?;

    axum::serve(listener, app)
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))?;

    Ok(())
}
