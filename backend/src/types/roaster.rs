use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, PartialOrd, Eq, Ord)]
pub(crate) struct RoasterId(Uuid);

impl RoasterId {
    pub(crate) fn as_uuid(&self) -> &Uuid {
        &self.0
    }
    pub(crate) fn new() -> Self {
        Self(Uuid::now_v7())
    }
}

impl From<Uuid> for RoasterId {
    fn from(value: Uuid) -> Self {
        Self(value)
    }
}

#[derive(Debug)]
pub(crate) struct NewRoaster {
    pub(crate) id: RoasterId,
    pub(crate) name: String,
}

#[derive(Debug)]
pub(crate) struct Roaster {
    pub(crate) id: RoasterId,
    pub(crate) name: String,
}
