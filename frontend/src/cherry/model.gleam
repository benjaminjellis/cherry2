import cherry/route.{type Route}
import cherry/types.{type CoffeeData}
import envoy
import gleam/dict
import gleam/io
import gleam/option.{type Option, None}
import gleam/result

pub type Config {
  Local(use_https: Bool, host: String)
  Prod(use_https: Bool, host: String)
}

pub fn get_confg() {
  let env = envoy.get("CHERRY_ENV") |> result.unwrap("local")
  let local = Local(False, "0.0.0.0:3000")
  case env {
    "prod" -> Prod(True, "TODO")
    "local" -> local
    a -> {
      io.debug("got unrecognised env var:" <> a)
      local
    }
  }
}

pub type Model {
  Model(
    /// Coffees
    coffees: dict.Dict(String, CoffeeData),
    roasters: dict.Dict(String, types.RoasterData),
    current_route: Route,
    experiments_by_coffee: dict.Dict(String, List(types.Experiment)),
    is_user_logged_in: Bool,
    log_in_input: LogInInput,
    new_coffee_input: NewCoffeeInput,
    config: Config,
  )
}

pub fn get_list_of_roasters(model: Model) -> List(types.RoasterData) {
  model.roasters |> dict.values
}

pub type LogInInput {
  LogInInput(email: Option(String), password: Option(String))
}

pub type NewCoffeeInput {
  NewCoffeeInput(
    varietal: Option(String),
    name: Option(String),
    origin: Option(String),
    tasting_notes: Option(String),
    roaster: Option(String),
    process: Option(String),
    roast_date: Option(String),
  )
}

pub fn new_coffee_input() {
  NewCoffeeInput(None, None, None, None, None, None, None)
}
