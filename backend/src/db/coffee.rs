use crate::types::{
    coffee::{Coffee, CoffeeId, NewCoffee},
    UserId,
};
use chrono::{NaiveDate, NaiveDateTime};
use sqlx::postgres::{PgPool, PgQueryResult};
use uuid::Uuid;

use super::CherryDbError;

pub(crate) struct CoffeeDb {
    id: Uuid,
    #[allow(dead_code)]
    user_id: Uuid,
    name: String,
    roaster: Uuid,
    roaster_name: String,
    roast_date: NaiveDate,
    origin: String,
    varetial: String,
    process: String,
    tasting_notes: String,
    liked: bool,
    in_current_rotation: bool,
    added: NaiveDateTime,
    last_updated: NaiveDateTime,
}

impl From<CoffeeDb> for Coffee {
    fn from(value: CoffeeDb) -> Self {
        Self {
            id: value.id.into(),
            name: value.name,
            roaster_name: value.roaster_name,
            roaster: value.roaster.into(),
            roast_date: value.roast_date,
            origin: value.origin,
            varetial: value.varetial,
            process: value.process,
            tasting_notes: value.tasting_notes,
            liked: value.liked,
            in_current_rotation: value.in_current_rotation,
            added: value.added.and_utc(),
            last_updated: value.last_updated.and_utc(),
        }
    }
}

pub(crate) async fn add_coffee(
    pool: &PgPool,
    user_id: &UserId,
    coffee: &NewCoffee,
) -> Result<Coffee, CherryDbError> {
    let coffee = sqlx::query_as!(
        CoffeeDb,
        r#"
        with inserted as (
        insert into coffees (id, user_id, name, roaster,
            roast_date, origin, varetial, process, tasting_notes, 
            liked, in_current_rotation, added, last_updated)
        values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
        returning *
        )
        select 
            inserted.*,  roasters.name AS roaster_name 
        from inserted
        inner join 
         roasters
        on
            inserted.roaster = roasters.id;
        "#,
        coffee.id.as_uuid(),
        user_id.as_uuid(),
        coffee.name,
        coffee.roaster.as_uuid(),
        coffee.roast_date,
        coffee.origin,
        coffee.varetial,
        coffee.process,
        coffee.tasting_notes,
        coffee.liked,
        coffee.in_current_rotation,
        coffee.added.naive_utc(),
        coffee.added.naive_utc()
    )
    .fetch_one(pool)
    .await
    .map_err(|e| match e {
        sqlx::Error::Database(db_error) if db_error.constraint() == Some("coffees_id_key") => {
            CherryDbError::KeyConflict("id already used".into())
        }
        _ => CherryDbError::InsertFailed(e.to_string()),
    })?;
    Ok(coffee.into())
}

pub(crate) async fn delete_coffee(
    pool: &PgPool,
    user_id: &UserId,
    coffee_id: &CoffeeId,
) -> Result<PgQueryResult, CherryDbError> {
    sqlx::query!(
        r#"
        delete from coffees
        where coffees.id = $1 and coffees.user_id = $2;
        "#,
        coffee_id.as_uuid(),
        user_id.as_uuid(),
    )
    .execute(pool)
    .await
    .map_err(|err| CherryDbError::Delete(err.to_string()))
}

pub(crate) async fn get_coffee_by_id(
    pool: &PgPool,
    user_id: &UserId,
    coffee_id: &CoffeeId,
) -> Result<Option<Coffee>, CherryDbError> {
    let coffee = sqlx::query_as!(
        CoffeeDb,
        r#"
        select
            coffees.*, roasters.name AS roaster_name
        from
            coffees
        inner join
            roasters
        on
            coffees.roaster = roasters.id
        where
            coffees.id = $1 
            and coffees.user_id = $2
        limit 1;"#,
        coffee_id.as_uuid(),
        user_id.as_uuid()
    )
    .fetch_optional(pool)
    .await
    .map_err(|err| CherryDbError::Select(err.to_string()))?;
    Ok(coffee.map(Into::into))
}

pub(crate) async fn get_all_coffees_for_user(
    pool: &PgPool,
    user_id: &UserId,
) -> Result<Vec<Coffee>, CherryDbError> {
    let coffee = sqlx::query_as!(
        CoffeeDb,
        r#"
        select
            coffees.*, roasters.name AS roaster_name
        from
            coffees
        inner join
            roasters
        on
            coffees.roaster = roasters.id
        where
            coffees.user_id = $1;"#,
        user_id.as_uuid()
    )
    .fetch_all(pool)
    .await
    .map_err(|err| CherryDbError::Select(err.to_string()))?;
    Ok(coffee.into_iter().map(Into::into).collect())
}

#[cfg(test)]
mod test {
    use chrono::{DateTime, NaiveDate, Utc};
    use sqlx::PgPool;

    use crate::{
        db::coffee::{add_coffee, delete_coffee, Coffee},
        types::UserId,
    };
    use uuid::Uuid;

    use super::{get_coffee_by_id, NewCoffee};

    fn date_to_midnight_utc(year: i32, month: u32, day: u32) -> DateTime<Utc> {
        NaiveDate::from_ymd_opt(year, month, day)
            .unwrap()
            .and_hms_opt(0, 0, 0)
            .unwrap()
            .and_utc()
    }

    #[sqlx::test]
    async fn test_add_new_coffee(pool: PgPool) -> sqlx::Result<()> {
        let user_id = UserId::from(Uuid::now_v7());
        let coffee = NewCoffee {
            id: Uuid::now_v7().into(),
            name: "Test coffee".into(),
            roaster: Uuid::now_v7().into(),
            roast_date: NaiveDate::from_ymd_opt(2024, 1, 1).unwrap(),
            origin: "Colombia".into(),
            varetial: "Geisha".into(),
            process: "Anerobic".into(),
            tasting_notes: "Peach, pecan".into(),
            liked: true,
            in_current_rotation: true,
            added: date_to_midnight_utc(2024, 1, 1),
        };
        add_coffee(&pool, &user_id, &coffee).await.unwrap();

        Ok(())
    }

    #[sqlx::test]
    async fn test_delete_coffee(pool: PgPool) -> sqlx::Result<()> {
        let user_id = UserId::from(Uuid::now_v7());
        let coffee = NewCoffee {
            id: Uuid::now_v7().into(),
            name: "Test coffee".into(),
            roaster: Uuid::now_v7().into(),
            roast_date: NaiveDate::from_ymd_opt(2024, 1, 1).unwrap(),
            origin: "Colombia".into(),
            varetial: "Geisha".into(),
            process: "Anerobic".into(),
            tasting_notes: "Peach, pecan".into(),
            liked: true,
            in_current_rotation: true,
            added: date_to_midnight_utc(2024, 1, 1),
        };
        add_coffee(&pool, &user_id, &coffee).await.unwrap();

        let res = delete_coffee(&pool, &user_id, &coffee.id).await.unwrap();

        assert!(res.rows_affected() == 1);

        Ok(())
    }

    #[sqlx::test]
    // TODO: add roaster
    async fn test_get_coffee_by_id_no_roaster(pool: PgPool) {
        let user_id = Uuid::now_v7().into();
        let coffee_id = Uuid::now_v7().into();

        let coffee_in = NewCoffee {
            id: coffee_id,
            name: "Test coffee".into(),
            roaster: Uuid::now_v7().into(),
            roast_date: NaiveDate::from_ymd_opt(2024, 1, 1).unwrap(),
            origin: "Colombia".into(),
            varetial: "Geisha".into(),
            process: "Anerobic".into(),
            tasting_notes: "Peach, pecan".into(),
            liked: true,
            in_current_rotation: true,
            added: date_to_midnight_utc(2024, 1, 1),
        };

        add_coffee(&pool, &user_id, &coffee_in).await.unwrap();

        let res = get_coffee_by_id(&pool, &user_id, &coffee_id).await.unwrap();
        assert!(res.is_none());
    }

    #[sqlx::test]
    async fn test_delete_coffee_different_user(pool: PgPool) -> sqlx::Result<()> {
        let user_id = Uuid::now_v7().into();

        let coffee = NewCoffee {
            id: Uuid::now_v7().into(),
            name: "Test coffee".into(),
            roaster: Uuid::now_v7().into(),
            roast_date: NaiveDate::from_ymd_opt(2024, 1, 1).unwrap(),
            origin: "Colombia".into(),
            varetial: "Geisha".into(),
            process: "Anerobic".into(),
            tasting_notes: "Peach, pecan".into(),
            liked: true,
            in_current_rotation: true,
            added: date_to_midnight_utc(2024, 1, 1),
        };

        add_coffee(&pool, &user_id, &coffee).await.unwrap();

        let user_2_id = Uuid::now_v7().into();

        let res = delete_coffee(&pool, &user_2_id, &coffee.id).await.unwrap();

        assert!(res.rows_affected() == 0);

        Ok(())
    }
}
