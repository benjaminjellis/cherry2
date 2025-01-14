pub(crate) mod coffee;
pub(crate) mod roaster;
use uuid::Uuid;

#[derive(Debug, Copy, Clone)]
pub(crate) struct UserId(Uuid);

impl UserId {
    #[cfg(test)]
    pub(crate) fn new() -> Self {
        Self(Uuid::new_v4())
    }

    pub(crate) fn to_uuid(&self) -> &Uuid {
        &self.0
    }
}

impl From<Uuid> for UserId {
    fn from(value: Uuid) -> Self {
        UserId(value)
    }
}
