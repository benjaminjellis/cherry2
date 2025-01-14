use crate::types::{
    coffee::{Coffee, CoffeeId},
    UserId,
};
use sqlx::postgres::PgPool;

use super::CherryDbError;

pub(crate) async fn add_coffee(
    pool: &PgPool,
    user_id: &UserId,
    coffee: &Coffee,
) -> Result<(), CherryDbError> {
    let _ = sqlx::query!(
        r#"
        insert into coffees (id, user_id, name, roaster, roast_date, origin, varetial, process, tasting_notes, liked, in_current_rotation)
        values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
        "#,
        coffee.id.to_uuid(),
        user_id.to_uuid(),
        coffee.name,
        coffee.roaster,
        coffee.roast_date,
        coffee.origin,
        coffee.varetial,
        coffee.process,
        coffee.tasting_notes,
        coffee.liked,
        coffee.in_current_rotation
    )
    .execute(pool)
    .await
    .map_err(|e| match e {
        sqlx::Error::Database(db_error) if db_error.constraint() == Some("coffees_id_key") => {
            CherryDbError::KeyConflict("id already used".into())
        }
        _ => CherryDbError::InsertFailed(e.to_string()),
    })?;
    Ok(())
}

pub(crate) async fn delete_coffee(
    pool: &PgPool,
    user_id: &UserId,
    coffee_id: &CoffeeId,
) -> Result<(), CherryDbError> {
    let res = sqlx::query!(
        r#"
        delete from coffees
        where coffees.id = $1 and coffees.user_id = $2;
        "#,
        coffee_id.to_uuid(),
        user_id.to_uuid(),
    )
    .execute(pool)
    .await
    .unwrap();
    Ok(())
}

#[cfg(test)]
mod test {
    use chrono::NaiveDate;
    use sqlx::PgPool;

    use crate::{
        db::coffee::{add_coffee, delete_coffee, Coffee},
        types::UserId,
    };
    use uuid::Uuid;

    #[sqlx::test]
    async fn test_add_new_coffee(pool: PgPool) -> sqlx::Result<()> {
        let user_id = UserId::from(Uuid::new_v4());
        let coffee = Coffee {
            id: Uuid::new_v4().into(),
            name: "Test coffee".into(),
            roaster: Uuid::new_v4(),
            roast_date: NaiveDate::from_ymd_opt(2024, 1, 1).unwrap(),
            origin: "Colombia".into(),
            varetial: "Geisha".into(),
            process: "Anerobic".into(),
            tasting_notes: "Peach, pecan".into(),
            liked: true,
            in_current_rotation: true,
        };
        add_coffee(&pool, &user_id, &coffee).await.unwrap();

        Ok(())
    }

    #[sqlx::test]
    async fn test_delete_coffee(pool: PgPool) -> sqlx::Result<()> {
        let user_id = UserId::from(Uuid::new_v4());
        let coffee = Coffee {
            id: Uuid::new_v4().into(),
            name: "Test coffee".into(),
            roaster: Uuid::new_v4(),
            roast_date: NaiveDate::from_ymd_opt(2024, 1, 1).unwrap(),
            origin: "Colombia".into(),
            varetial: "Geisha".into(),
            process: "Anerobic".into(),
            tasting_notes: "Peach, pecan".into(),
            liked: true,
            in_current_rotation: true,
        };
        add_coffee(&pool, &user_id, &coffee).await.unwrap();

        delete_coffee(&pool, &user_id, &coffee.id).await.unwrap();

        Ok(())
    }
}
