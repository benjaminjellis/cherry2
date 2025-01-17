import cherry/route.{type Route}
import cherry/types.{type TableData}

pub type Model {
  Model(coffees: TableData, current_route: Route)
}
