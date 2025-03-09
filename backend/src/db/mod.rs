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
    #[error("Failed to insert: {description}: {source}")]
    Insert {
        source: sqlx::Error,
        description: &'static str,
    },
    #[error("Found conflicting key: `{0}`")]
    KeyConflict(String),
    #[error("Failed to delete: {description}: {source}")]
    Delete {
        source: sqlx::Error,
        description: &'static str,
    },
    #[error("Failed to select: {description}: {source}")]
    Select {
        source: sqlx::Error,
        description: &'static str,
    },
    #[error("Failed to update: {description}: {source}")]
    Update {
        source: sqlx::Error,
        description: &'static str,
    },
    #[error("Failed to parse str from db: `{0}`")]
    DbParse(ParseError),
    #[error("User is not unauthorised")]
    Unauthorised,
}

impl Default for CherryDbError {
    fn default() -> Self {
        Self::Unauthorised
    }
}

const MAX_CONNECTIONS: u32 = 50;

pub(crate) static MIGRATOR: Migrator = sqlx::migrate!(); // defaults to "./migrations"

pub(crate) async fn create_db_pool(database_url: &str) -> Result<PgPool, CherryError> {
    PgPoolOptions::new()
        .max_connections(MAX_CONNECTIONS)
        .connect(database_url)
        .await
        .map_err(CherryError::DbSetup)
}
