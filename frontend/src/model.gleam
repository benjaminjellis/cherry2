import route.{type Route}
import types.{type TableData}

pub type Model {
  Model(coffees: TableData, current_route: Route)
}
