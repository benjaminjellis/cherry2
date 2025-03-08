pub type CoffeeDto {
  CoffeeDto(
    name: String,
    id: String,
    roaster: String,
    roaster_name: String,
    roast_date: String,
    origin: String,
    varetial: String,
    in_current_rotation: Bool,
    process: String,
  )
}

pub type NewCoffeeDto {
  NewCoffeeDto(
    name: String,
    raoster: String,
    roast_date: String,
    origin: String,
    varetial: String,
    process: String,
    tasting_notes: String,
    liked: Bool,
    in_current_rotation: Bool,
  )
}

pub type RoasterDto {
  RoasterDto(name: String, id: String)
}

pub type ExperimentDto {
  ExperimentDto(
    id: String,
    date: String,
    coffee_id: String,
    brew_method: String,
    grinder: String,
    grind_setting: String,
    recipe: String,
    liked: Bool,
    notes: String,
    added: String,
    last_updated: String,
  )
}
