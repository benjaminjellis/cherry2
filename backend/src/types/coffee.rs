use chrono::NaiveDate;
use uuid::Uuid;

#[derive(Debug, Copy, Clone)]
pub(crate) struct CoffeeId(Uuid);

impl CoffeeId {
    pub(crate) fn to_uuid(&self) -> &Uuid {
        &self.0
    }
}

impl From<Uuid> for CoffeeId {
    fn from(value: Uuid) -> Self {
        Self(value)
    }
}

#[derive(Debug)]
pub(crate) struct Coffee {
    pub(crate) id: CoffeeId,
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
