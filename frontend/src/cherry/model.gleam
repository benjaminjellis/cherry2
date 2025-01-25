import cherry/route.{type Route}
import cherry/types.{type CoffeeData, type Experiments}
import envoy
import gleam/dict
import gleam/io
import gleam/option.{type Option}
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
    experiments_by_coffee: dict.Dict(String, Experiments),
    is_user_logged_in: Bool,
    log_in_input: LogInInput,
    config: Config,
  )
}

pub type LogInInput {
  LogInInput(email: Option(String), password: Option(String))
}
