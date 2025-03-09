pub(crate) mod coffee;
pub(crate) mod experiment;
pub(crate) mod roaster;

use uuid::Uuid;

/// Impl useful functions for New Type Ids
#[macro_export]
macro_rules! impl_new_type_id {
    ($newtypeid:ty) => {
        impl $newtypeid {
            #[allow(dead_code)]
            pub(crate) fn new() -> Self {
                Self(Uuid::now_v7())
            }

            #[allow(dead_code)]
            pub(crate) fn as_uuid(&self) -> &Uuid {
                &self.0
            }

            #[allow(dead_code)]
            pub(crate) fn into_uuid(self) -> Uuid {
                self.0
            }
        }

        impl From<Uuid> for $newtypeid {
            fn from(value: Uuid) -> Self {
                Self(value)
            }
        }

        impl serde::Serialize for $newtypeid {
            fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
            where
                S: serde::Serializer,
            {
                self.0.serialize(serializer)
            }
        }

        impl<'de> serde::Deserialize<'de> for $newtypeid {
            fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
            where
                D: serde::Deserializer<'de>,
            {
                uuid::Uuid::deserialize(deserializer).map(Into::into)
            }
        }
    };
}

#[derive(Debug, Copy, Clone)]
pub(crate) struct UserId(Uuid);

impl_new_type_id!(UserId);
