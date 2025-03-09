use chrono::{DateTime, NaiveDate, Utc};
use uuid::Uuid;

use crate::impl_new_type_id;

use super::roaster::RoasterId;

#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub(crate) struct CoffeeId(Uuid);

impl_new_type_id!(CoffeeId);

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
