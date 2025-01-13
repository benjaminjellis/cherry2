use sqlx::{
    migrate::Migrator,
    postgres::{PgPool, PgPoolOptions},
};

use crate::CherryError;

const MAX_CONNECTIONS: u32 = 50;

pub(crate) static MIGRATOR: Migrator = sqlx::migrate!(); // defaults to "./migrations"

pub(crate) async fn create_db_pool(database_url: &str) -> Result<PgPool, CherryError> {
    PgPoolOptions::new()
        .max_connections(MAX_CONNECTIONS)
        .connect(database_url)
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))
}
