use uuid::Uuid;

#[derive(Debug)]
pub(crate) struct RoasterId(Uuid);

impl RoasterId {
    pub(crate) fn to_uuid(&self) -> &Uuid {
        &self.0
    }
}

impl From<Uuid> for RoasterId {
    fn from(value: Uuid) -> Self {
        Self(value)
    }
}
