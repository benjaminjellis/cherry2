use sqlx::{postgres::PgQueryResult, PgPool};
use uuid::Uuid;

use crate::types::{
    roaster::{NewRoaster, Roaster, RoasterId},
    UserId,
};

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

pub(crate) async fn get_all_roasters(pool: &PgPool) -> Result<Vec<Roaster>, CherryDbError> {
    Ok(sqlx::query_as!(RoasterDb, r#"select * from roasters;"#)
        .fetch_all(pool)
        .await
        .map_err(|source| CherryDbError::Select {
            source,
            description: "Failed to get all roasters",
        })?
        .into_iter()
        .map(|a| a.into())
        .collect())
}

pub(crate) async fn search_roasters_by_name(
    pool: &PgPool,
    name: String,
) -> Result<Vec<Roaster>, CherryDbError> {
    let pattern = format!("{name}%");
    Ok(sqlx::query_as!(
        RoasterDb,
        r#"select * from roasters where roasters.name ilike $1 limit 10;"#,
        pattern
    )
    .fetch_all(pool)
    .await
    .map_err(|source| CherryDbError::Select {
        source,
        description: "Failed to select roaster names",
    })?
    .into_iter()
    .map(|a| a.into())
    .collect())
}

pub(crate) async fn get_roasters_for_user(
    pool: &PgPool,
    user_id: &UserId,
) -> Result<Vec<Roaster>, CherryDbError> {
    Ok(sqlx::query_as!(
        RoasterDb,
        r#"select
            *
        from
            roasters
        where
            roasters.id in (select distinct roaster from coffees where user_id = $1 );"#,
        user_id.as_uuid()
    )
    .fetch_all(pool)
    .await
    .map_err(|source| CherryDbError::Select {
        source,
        description: "Failed to select roasters for user",
    })?
    .into_iter()
    .map(|a| a.into())
    .collect())
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
        _ => CherryDbError::Insert {
            source: e,
            description: "Failed to insert roaster",
        },
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
    .map_err(|source| CherryDbError::Select {
        source,
        description: "Failed to select roaseter by id",
    })?;
    Ok(roaster.map(Into::into))
}
