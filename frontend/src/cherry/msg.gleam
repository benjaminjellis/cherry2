import cherry/route.{type Route}

pub type Msg {
  OnRouteChange(Route)
  UserClickedRow(row: String)
}
