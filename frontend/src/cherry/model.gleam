import cherry/route.{type Route}
import cherry/types.{type CoffeeData, type Experiments}
import gleam/dict

pub type Model {
  Model(
    coffees: dict.Dict(String, CoffeeData),
    current_route: Route,
    experiments_by_coffee: dict.Dict(String, Experiments),
    is_user_logged_in: Bool,
  )
}
