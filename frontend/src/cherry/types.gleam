import cherry/dtos.{type CoffeeDto}

pub type CoffeeData {
  CoffeeData(id: String, name: String, roaster: String, roast_date: String)
}

pub fn convert_dto_to_coffee_data(dto: CoffeeDto) {
  CoffeeData(
    id: dto.id,
    name: dto.name,
    roaster: dto.roaster_name,
    roast_date: dto.roast_date,
  )
}

pub type Experiments {
  Experiments(experiments: List(Experiment))
}

pub type Experiment {
  Experiment(id: String)
}
