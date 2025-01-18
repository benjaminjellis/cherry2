use sqlx::{postgres::PgQueryResult, PgPool};
use uuid::Uuid;

use crate::types::roaster::{NewRoaster, Roaster, RoasterId};

use super::CherryDbError;

pub(crate) struct RoasterDb {
    id: Uuid,
    name: String,
}

impl From<RoasterDb> for Roaster {
    fn from(value: RoasterDb) -> Self {
        Self {
            id: value.id.into(),
            name: value.name,
        }
    }
}

pub(crate) async fn add_roaster(
    pool: &PgPool,
    new_roaster: &NewRoaster,
) -> Result<PgQueryResult, CherryDbError> {
    sqlx::query!(
        r#"
        insert into roasters (id, name)
        values ($1, $2);
        "#,
        new_roaster.id.as_uuid(),
        new_roaster.name
    )
    .execute(pool)
    .await
    .map_err(|e| match e {
        sqlx::Error::Database(db_error) if db_error.constraint() == Some("coffees_id_key") => {
            CherryDbError::KeyConflict("id already used".into())
        }
        _ => CherryDbError::InsertFailed(e.to_string()),
    })
}

pub(crate) async fn get_roaster_by_id(
    pool: &PgPool,
    roaster_id: RoasterId,
) -> Result<Option<Roaster>, CherryDbError> {
    let roaster = sqlx::query_as!(
        RoasterDb,
        r#"
        select * from roasters where roasters.id = $1;
        "#,
        roaster_id.as_uuid()
    )
    .fetch_optional(pool)
    .await
    .map_err(|err| CherryDbError::Select(err.to_string()))?;
    Ok(roaster.map(Into::into))
}
