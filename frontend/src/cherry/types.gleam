pub type CoffeesData {
  CoffeesData(coffees: List(CoffeeData))
}

pub type CoffeeData {
  CoffeeData(id: String, name: String, roaster: String, roast_date: String)
}

pub type Experiments {
  Experiments(experiments: List(Experiment))
}

pub type Experiment {
  Experiment(id: String)
}
