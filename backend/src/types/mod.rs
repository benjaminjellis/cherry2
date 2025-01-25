pub(crate) mod coffee;
pub(crate) mod experiment;
pub(crate) mod roaster;

use uuid::Uuid;

#[derive(Debug, Copy, Clone)]
pub(crate) struct UserId(Uuid);

impl UserId {
    #[cfg(test)]
    #[allow(dead_code)]
    pub(crate) fn new() -> Self {
        Self(Uuid::now_v7())
    }

    pub(crate) const fn test_user() -> Self {
        Self(Uuid::nil())
    }

    pub(crate) fn as_uuid(&self) -> &Uuid {
        &self.0
    }
}

impl From<Uuid> for UserId {
    fn from(value: Uuid) -> Self {
        UserId(value)
    }
}
