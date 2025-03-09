use uuid::Uuid;

use crate::impl_new_type_id;

#[derive(Debug, Clone, Copy, PartialEq, PartialOrd, Eq, Ord)]
pub(crate) struct RoasterId(Uuid);

impl_new_type_id!(RoasterId);

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
