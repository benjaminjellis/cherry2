use sqlx::PgPool;

#[derive(Clone)]
pub(crate) struct AppState {
    pub(crate) db_pool: PgPool,
}
