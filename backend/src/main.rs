mod api;
mod coffee;
mod db;
mod error;
mod experiments;
mod roaster;
mod types;

use std::{
    env,
    net::{IpAddr, Ipv4Addr, SocketAddr},
};

use api::UserClaims;
pub(crate) use error::CherryError;

use axum_cognito::{self, CognitoAuthLayer};
use mimalloc::MiMalloc;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

#[global_allocator]
static GLOBAL: MiMalloc = MiMalloc;

fn get_env_var(env_var: &'static str) -> Result<String, CherryError> {
    env::var(env_var).map_err(|source| CherryError::EnvVar {
        var: env_var,
        source,
    })
}

fn get_cognito_env_vars() -> Result<(String, String, String), CherryError> {
    let cognito_client_id = get_env_var("COGNITO_ENV_VAR")?;
    let cognito_pool_id = get_env_var("COGNITO_POOL_ID")?;
    let cognito_region = get_env_var("COGNITO_REGION")?;
    Ok((cognito_client_id, cognito_pool_id, cognito_region))
}

#[tokio::main]
async fn main() -> Result<(), CherryError> {
    dotenvy::dotenv().ok();

    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer())
        .init();

    let (cognito_client_id, cognito_pool_id, cognito_region) = get_cognito_env_vars()?;

    let cognito_layer = CognitoAuthLayer::<UserClaims>::new(
        axum_cognito::OAuthTokenType::Id,
        &cognito_client_id,
        &cognito_pool_id,
        &cognito_region,
    )
    .await
    .unwrap();

    let database_url = std::env::var("DATABASE_URL").map_err(|source| CherryError::EnvVar {
        source,
        var: "DATABASE_URL",
    })?;

    let db_pool = db::create_db_pool(&database_url).await?;

    db::MIGRATOR
        .run(&db_pool)
        .await
        .map_err(CherryError::Migration)?;

    let router = api::build_router(db_pool, cognito_layer).await?;

    tracing::info!("test");

    let addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 3000);

    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .map_err(CherryError::ServerSetup)?;

    axum::serve(listener, router)
        .await
        .map_err(CherryError::ServerSetup)?;

    Ok(())
}
