import cherr/types.{type TableData}
import cherry/route.{type Route}

pub type Model {
  Model(coffees: TableData, current_route: Route)
}
