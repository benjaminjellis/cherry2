use crate::types::coffee::{CoffeeId, NewCoffee};
use chrono::{DateTime, NaiveDate, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
pub(crate) struct NewCoffeeRequestDto {
    pub(crate) name: String,
    pub(crate) roaster: Uuid,
    pub(crate) roast_date: NaiveDate,
    pub(crate) origin: String,
    pub(crate) varetial: String,
    pub(crate) process: String,
    pub(crate) tasting_notes: String,
    pub(crate) liked: bool,
    pub(crate) in_current_rotation: bool,
}

impl NewCoffeeRequestDto {
    pub(crate) fn to_new_coffee(self, coffee_id: CoffeeId, added: DateTime<Utc>) -> NewCoffee {
        NewCoffee {
            id: coffee_id,
            name: self.name,
            roaster: self.roaster.into(),
            roast_date: self.roast_date,
            origin: self.origin,
            varetial: self.varetial,
            process: self.process,
            tasting_notes: self.tasting_notes,
            liked: self.liked,
            in_current_rotation: self.in_current_rotation,
            added,
        }
    }
}

#[derive(Serialize, Deserialize)]
pub(crate) struct CoffeeDto {
    pub(crate) name: String,
    pub(crate) id: Uuid,
    pub(crate) roaster: Uuid,
    pub(crate) roast_date: NaiveDate,
    pub(crate) origin: String,
    pub(crate) varetial: String,
    pub(crate) process: String,
    pub(crate) tasting_notes: String,
    pub(crate) liked: bool,
    pub(crate) in_current_rotation: bool,
}

impl From<NewCoffee> for CoffeeDto {
    fn from(value: NewCoffee) -> Self {
        Self {
            name: value.name,
            id: *value.id.as_uuid(),
            roaster: *value.roaster.as_uuid(),
            roast_date: value.roast_date,
            origin: value.origin,
            varetial: value.varetial,
            process: value.process,
            tasting_notes: value.tasting_notes,
            liked: value.liked,
            in_current_rotation: value.in_current_rotation,
        }
    }
}
