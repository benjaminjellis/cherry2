use chrono::{DateTime, Utc};
use uuid::Uuid;

#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub(crate) struct ExperimentId(Uuid);

impl ExperimentId {
    pub(crate) fn as_uuid(&self) -> &Uuid {
        &self.0
    }

    pub(crate) fn new() -> Self {
        Self(Uuid::now_v7())
    }
}

impl From<Uuid> for ExperimentId {
    fn from(value: Uuid) -> Self {
        Self(value)
    }
}

pub(crate) enum BrewMethod {
    Espresso,
    Filter,
    MokaPot,
}

pub(crate) struct Experiment {
    pub(crate) id: ExperimentId,
    pub(crate) date: DateTime<Utc>,
    pub(crate) variant: BrewMethod,
}

