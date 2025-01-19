import cherry/dtos.{type CoffeeDto}
import cherry/route.{type Route}
import lustre_http.{type HttpError}

pub type Msg {
  OnRouteChange(Route)
  EmiaiInput(value: String)
  PasswordInput(value: String)
  UserRequestedLogIn(password: String, email: String)
  UserRequestedSignUp(password: String, email: String)
  CoffeeApiRsesponse(Result(List(CoffeeDto), HttpError))
}
