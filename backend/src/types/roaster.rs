use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, PartialOrd, Eq, Ord)]
pub(crate) struct RoasterId(Uuid);

impl RoasterId {
    pub(crate) fn as_uuid(&self) -> &Uuid {
        &self.0
    }
}

impl From<Uuid> for RoasterId {
    fn from(value: Uuid) -> Self {
        Self(value)
    }
}
