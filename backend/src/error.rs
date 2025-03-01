use std::env::VarError;

use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use sqlx::migrate::MigrateError;
use thiserror::Error;
use tracing::error;

use crate::db::CherryDbError;

#[derive(Error, Debug)]
pub(crate) enum CherryError {
    #[error("Failed to load environment variable: {0}")]
    EnvVar(VarError),
    #[error("Server setup failed: {0}")]
    Setup(String),
    #[error("Database migration failed: {0}")]
    Migration(MigrateError),
    #[error(transparent)]
    CherryDbError(#[from] CherryDbError),
    #[error("Resource not found: {0}")]
    NotFound(String),
}

impl IntoResponse for CherryError {
    fn into_response(self) -> Response {
        error!(?self);
        let (status, error_message) = match self {
            CherryError::Setup(err) => (StatusCode::INTERNAL_SERVER_ERROR, err.to_string()),
            CherryError::CherryDbError(err) => match err {
                CherryDbError::KeyConflict(_)
                | CherryDbError::Delete(_)
                | CherryDbError::Select(_)
                | CherryDbError::DbParse(_)
                | CherryDbError::InsertFailed(_) => {
                    (StatusCode::INTERNAL_SERVER_ERROR, err.to_string())
                }
                CherryDbError::Unauthorised => {
                    (StatusCode::UNAUTHORIZED, String::from("Not authorised"))
                }
            },
            CherryError::NotFound(err) => (StatusCode::NOT_FOUND, err.to_string()),
            CherryError::EnvVar(err) => (StatusCode::INTERNAL_SERVER_ERROR, err.to_string()),
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
