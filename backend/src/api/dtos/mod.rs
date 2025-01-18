use crate::types::{
    coffee::{Coffee, CoffeeId, NewCoffee},
    roaster::{NewRoaster, Roaster, RoasterId},
};
use chrono::{DateTime, NaiveDate, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Deserialize)]
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
    pub(crate) fn into_new_coffee(self, coffee_id: CoffeeId, added: DateTime<Utc>) -> NewCoffee {
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
    pub(crate) roaster_name: String,
    pub(crate) roast_date: NaiveDate,
    pub(crate) origin: String,
    pub(crate) varetial: String,
    pub(crate) process: String,
    pub(crate) tasting_notes: String,
    pub(crate) liked: bool,
    pub(crate) in_current_rotation: bool,
}

impl From<Coffee> for CoffeeDto {
    fn from(value: Coffee) -> Self {
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
            roaster_name: value.roaster_name,
        }
    }
}

#[derive(Serialize, Deserialize)]
pub(crate) struct NewRoasterDto {
    pub(crate) name: String,
}

#[derive(Serialize, Deserialize)]
pub(crate) struct RoasterDto {
    pub(crate) id: Uuid,
    pub(crate) name: String,
}

impl From<Roaster> for RoasterDto {
    fn from(value: Roaster) -> Self {
        Self {
            id: *value.id.as_uuid(),
            name: value.name,
        }
    }
}

impl From<NewRoaster> for RoasterDto {
    fn from(value: NewRoaster) -> Self {
        Self {
            id: *value.id.as_uuid(),
            name: value.name,
        }
    }
}

impl NewRoasterDto {
    pub(crate) fn into_new_roaster(self, id: RoasterId) -> NewRoaster {
        NewRoaster {
            id,
            name: self.name,
        }
    }
}
