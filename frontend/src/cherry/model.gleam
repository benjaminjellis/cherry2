import cherry/route.{type Route}
import cherry/types.{type CoffeesData, type Experiments}
import gleam/dict

pub type Model {
  Model(
    coffees: CoffeesData,
    current_route: Route,
    ecperiments_by_coffee: dict.Dict(String, Experiments),
  )
}
