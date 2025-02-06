import cherry/dtos.{type CoffeeDto, type RoasterDto}
import cherry/model.{type Model, Model, NewCoffeeInput}
import cherry/route.{type Route}
import gleam/option.{Some}
import lustre_http.{type HttpError}

pub type Msg {
  OnRouteChange(Route)
  AddNewCoffee(AddNewCoffeeMsg)
  EmiaiInput(value: String)
  PasswordInput(value: String)
  UserRequestedLogIn(password: String, email: String)
  UserRequestedSignUp(password: String, email: String)
  RoastersApiResponse(Result(List(RoasterDto), HttpError))
  CoffeesApiRsesponse(Result(List(CoffeeDto), HttpError))
  CoffeeApiRsesponse(Result(CoffeeDto, HttpError))
  GetRoasters
}

pub type AddNewCoffeeMsg {
  VaretialInput(value: String)
  NameInput(value: String)
  OriginInput(value: String)
  TastingNotes(value: String)
}

pub fn process_add_new_coffee_message(
  model: model.Model,
  msg: AddNewCoffeeMsg,
) -> model.Model {
  case msg {
    VaretialInput(input) ->
      Model(
        ..model,
        new_coffee_input: NewCoffeeInput(
          ..model.new_coffee_input,
          varietal: Some(input),
        ),
      )
    NameInput(input) ->
      Model(
        ..model,
        new_coffee_input: NewCoffeeInput(
          ..model.new_coffee_input,
          name: Some(input),
        ),
      )
    OriginInput(input) ->
      Model(
        ..model,
        new_coffee_input: NewCoffeeInput(
          ..model.new_coffee_input,
          origin: Some(input),
        ),
      )
    TastingNotes(input) ->
      Model(
        ..model,
        new_coffee_input: NewCoffeeInput(
          ..model.new_coffee_input,
          tasting_notes: Some(input),
        ),
      )
  }
}
