use std::str::FromStr;

use chrono::{DateTime, NaiveDate, Utc};
use strum::{Display, EnumString};

use uuid::Uuid;

use crate::{
    db::{experiments::ExperimentDb, CherryDbError},
    impl_new_type_id,
};

use super::{coffee::CoffeeId, UserId};

#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub(crate) struct ExperimentId(Uuid);

impl_new_type_id!(ExperimentId);

#[derive(Debug, EnumString, Display, Copy, Clone)]
pub(crate) enum BrewMethod {
    Espresso,
    Filter,
    MokaPot,
}

pub(crate) struct Experiment {
    pub(crate) id: ExperimentId,
    pub(crate) date: NaiveDate,
    pub(crate) brew_method: BrewMethod,
    pub(crate) grinder: String,
    pub(crate) grind_setting: String,
    pub(crate) recipe: String,
    pub(crate) liked: bool,
    pub(crate) notes: String,
    pub(crate) coffee_id: CoffeeId,
    pub(crate) added: DateTime<Utc>,
    pub(crate) last_updated: DateTime<Utc>,
}

pub(crate) struct NewExperiment {
    pub(crate) date: NaiveDate,
    pub(crate) grinder: String,
    pub(crate) brew_method: BrewMethod,
    pub(crate) grind_setting: String,
    pub(crate) recipe: String,
    pub(crate) liked: bool,
    pub(crate) notes: String,
}

impl NewExperiment {
    pub(crate) fn into_db(self, user_id: &UserId, coffee_isd: &CoffeeId) -> ExperimentDb {
        let now = Utc::now().naive_utc();
        ExperimentDb {
            id: *ExperimentId::new().as_uuid(),
            coffee_id: *coffee_isd.as_uuid(),
            date: self.date,
            brew_method: self.brew_method.to_string(),
            grinder: self.grinder,
            grind_setting: self.grind_setting,
            recipe: self.recipe,
            liked: self.liked,
            user_id: *user_id.as_uuid(),
            notes: self.notes,
            added: now,
            last_updated: now,
        }
    }
}

impl TryFrom<ExperimentDb> for Experiment {
    type Error = CherryDbError;

    fn try_from(value: ExperimentDb) -> Result<Self, Self::Error> {
        let bm = BrewMethod::from_str(&value.brew_method).map_err(CherryDbError::DbParse)?;
        Ok(Self {
            id: value.id.into(),
            date: value.date,
            brew_method: bm,
            grinder: value.grinder,
            grind_setting: value.grind_setting,
            recipe: value.recipe,
            liked: value.liked,
            notes: value.notes,
            coffee_id: value.coffee_id.into(),
            added: value.added.and_utc(),
            last_updated: value.last_updated.and_utc(),
        })
    }
}
