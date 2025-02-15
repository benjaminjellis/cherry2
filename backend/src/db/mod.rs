pub(crate) mod coffee;
pub(crate) mod experiments;
pub(crate) mod roasters;

use sqlx::{
    migrate::Migrator,
    postgres::{PgPool, PgPoolOptions},
};
use strum::ParseError;
use thiserror::Error;

use crate::CherryError;

#[derive(Error, Debug)]
pub(crate) enum CherryDbError {
    #[error("Failed to insert: `{0}`")]
    InsertFailed(String),
    #[error("Found conflicting key: `{0}`")]
    KeyConflict(String),
    #[error("Failed to delete: `{0}`")]
    Delete(String),
    #[error("Failed to select: `{0}`")]
    Select(String),
    #[error("Failed to parse str from db: `{0}`")]
    DbParse(ParseError),
}

const MAX_CONNECTIONS: u32 = 50;

pub(crate) static MIGRATOR: Migrator = sqlx::migrate!(); // defaults to "./migrations"

pub(crate) async fn create_db_pool(database_url: &str) -> Result<PgPool, CherryError> {
    PgPoolOptions::new()
        .max_connections(MAX_CONNECTIONS)
        .connect(database_url)
        .await
        .map_err(|err| CherryError::Setup(err.to_string()))
}
