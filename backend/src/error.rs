use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use sqlx::migrate::MigrateError;
use thiserror::Error;
use tracing::error;
use uuid::Uuid;

use crate::db::CherryDbError;

#[derive(Error, Debug)]
pub(crate) enum CherryError {
    #[error("Failed to load environment variable: {var}, source: {source}")]
    EnvVar {
        var: &'static str,
        source: std::env::VarError,
    },
    #[error("DB setup failed: {0}")]
    DbSetup(sqlx::Error),
    #[error("DB setup failed: {0}")]
    ServerSetup(std::io::Error),
    #[error("Database migration failed: {0}")]
    Migration(MigrateError),
    #[error(transparent)]
    CherryDbError(#[from] CherryDbError),
    #[error("Resource not found: {0}")]
    NotFound(Uuid),
}

impl IntoResponse for CherryError {
    fn into_response(self) -> Response {
        error!(?self);
        let (status, error_message) = match self {
            CherryError::DbSetup(err) => (StatusCode::INTERNAL_SERVER_ERROR, err.to_string()),
            CherryError::ServerSetup(err) => (StatusCode::INTERNAL_SERVER_ERROR, err.to_string()),
            CherryError::CherryDbError(err) => match err {
                CherryDbError::KeyConflict(_)
                | CherryDbError::Delete {
                    source: _,
                    description: _,
                }
                | CherryDbError::Select {
                    source: _,
                    description: _,
                }
                | CherryDbError::Update {
                    source: _,
                    description: _,
                }
                | CherryDbError::DbParse(_)
                | CherryDbError::Insert {
                    source: _,
                    description: _,
                } => (StatusCode::INTERNAL_SERVER_ERROR, err.to_string()),
                CherryDbError::Unauthorised => {
                    (StatusCode::UNAUTHORIZED, String::from("Not authorised"))
                }
            },
            CherryError::NotFound(err) => (StatusCode::NOT_FOUND, err.to_string()),
            CherryError::EnvVar { source: _, var: _ } => (
                StatusCode::INTERNAL_SERVER_ERROR,
                "missing env var".to_string(),
            ),
            CherryError::Migration(err) => (StatusCode::INTERNAL_SERVER_ERROR, err.to_string()),
        };

        let body = Json(ErrorMessage {
            error: error_message,
        });

        (status, body).into_response()
    }
}

#[derive(serde::Serialize)]
pub struct ErrorMessage {
    error: String,
}
