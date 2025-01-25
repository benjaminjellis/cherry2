import cherry/dtos.{type CoffeeDto, type RoasterDto}
import cherry/route.{type Route}
import lustre_http.{type HttpError}

pub type Msg {
  OnRouteChange(Route)
  EmiaiInput(value: String)
  PasswordInput(value: String)
  UserRequestedLogIn(password: String, email: String)
  UserRequestedSignUp(password: String, email: String)
  RoastersApiResponse(Result(List(RoasterDto), HttpError))
  CoffeesApiRsesponse(Result(List(CoffeeDto), HttpError))
  CoffeeApiRsesponse(Result(CoffeeDto, HttpError))
  GetRoasters
}
