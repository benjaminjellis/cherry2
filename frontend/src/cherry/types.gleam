import cherry/dtos.{type CoffeeDto, type RoasterDto}
import gleam/result
import rada/date

pub type CoffeeData {
  CoffeeData(
    id: String,
    name: String,
    roaster: String,
    roast_date: date.Date,
    origin: String,
    varetial: String,
    in_current_rotation: Bool,
    process: String,
  )
}

pub fn convert_dto_to_coffee_data(dto: CoffeeDto) {
  use date <- result.try(date.from_iso_string(dto.roast_date))
  Ok(CoffeeData(
    id: dto.id,
    name: dto.name,
    roaster: dto.roaster_name,
    origin: dto.origin,
    varetial: dto.varetial,
    roast_date: date,
    in_current_rotation: dto.in_current_rotation,
    process: dto.process,
  ))
}

pub type Experiment {
  Experiment(
    id: String,
    date: date.Date,
    grinder: String,
    grind_setting: String,
    liked: Bool,
  )
}

pub fn convert_dto_to_experiment(dto: dtos.ExperimentDto) {
  use date <- result.try(date.from_iso_string(dto.date))
  Ok(Experiment(
    id: dto.id,
    date:,
    grind_setting: dto.grind_setting,
    grinder: dto.grinder,
    liked: dto.liked,
  ))
}

pub type RoasterData {
  RoasterData(id: String, name: String)
}

pub fn convert_dto_to_roaster_data(dto: RoasterDto) {
  RoasterData(id: dto.id, name: dto.name)
}
