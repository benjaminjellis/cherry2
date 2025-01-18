import cherry/route.{type Route}

pub type Msg {
  OnRouteChange(Route)
  EmiaiInput(value: String)
  PasswordInput(value: String)
  LogInFormSubmit(password: String, email: String)
}
