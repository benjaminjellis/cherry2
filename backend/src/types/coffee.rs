use chrono::{DateTime, NaiveDate, Utc};
use uuid::Uuid;

use super::roaster::RoasterId;

#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub(crate) struct CoffeeId(Uuid);

impl CoffeeId {
    pub(crate) fn as_uuid(&self) -> &Uuid {
        &self.0
    }

    pub(crate) fn new() -> Self {
        Self(Uuid::now_v7())
    }
}

impl From<Uuid> for CoffeeId {
    fn from(value: Uuid) -> Self {
        Self(value)
    }
}

#[derive(Debug, PartialEq, Eq)]
pub(crate) struct NewCoffee {
    pub(crate) id: CoffeeId,
    pub(crate) name: String,
    pub(crate) roaster: RoasterId,
    pub(crate) roast_date: NaiveDate,
    pub(crate) origin: String,
    pub(crate) varetial: String,
    pub(crate) process: String,
    pub(crate) tasting_notes: String,
    pub(crate) liked: bool,
    pub(crate) in_current_rotation: bool,
    pub(crate) added: DateTime<Utc>,
}

#[derive(Debug, PartialEq, Eq)]
pub(crate) struct Coffee {
    pub(crate) id: CoffeeId,
    pub(crate) name: String,
    pub(crate) roaster_name: String,
    pub(crate) roaster: RoasterId,
    pub(crate) roast_date: NaiveDate,
    pub(crate) origin: String,
    pub(crate) varetial: String,
    pub(crate) process: String,
    pub(crate) tasting_notes: String,
    pub(crate) liked: bool,
    pub(crate) in_current_rotation: bool,
    pub(crate) added: DateTime<Utc>,
    pub(crate) last_updated: DateTime<Utc>,
}
