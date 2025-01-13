use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use thiserror::Error;
use tracing::error;

#[derive(Error, Debug)]
pub(crate) enum CherryError {
    #[error("Encountered error when setting up server: `{0}`")]
    Setup(String),
}

impl IntoResponse for CherryError {
    fn into_response(self) -> Response {
        let (status, error_message) = match self {
            CherryError::Setup(err) => (StatusCode::INTERNAL_SERVER_ERROR, err.to_string()),
        };
        error!(error_message);

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
