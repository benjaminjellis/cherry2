import cherry/route.{type Route}

pub type Msg {
  OnRouteChange(Route)
  EmiaiInput(value: String)
  PasswordInput(value: String)
  UserRequestedLogIn(password: String, email: String)
  UserRequestedSignUp(password: String, email: String)
}
