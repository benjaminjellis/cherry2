import cherry/dtos.{type CoffeeDto, type RoasterDto}
import cherry/model.{type Model, Model, NewCoffeeInput}
import cherry/route.{type Route}
import gleam/io
import gleam/option.{Some}
import lustre_http.{type HttpError}

pub type Msg {
  OnRouteChange(Route)
  AddNewCoffeeInput(AddNewCoffeeInputMsg)
  EmiaiInput(value: String)
  PasswordInput(value: String)
  UserRequestedLogIn(password: String, email: String)
  UserRequestedSignUp(password: String, email: String)
  UserAddedNewCoffee(model.NewCoffeeInput)
  NewCoffeeApiResponse(Result(CoffeeDto, HttpError))
  RoastersApiResponse(Result(List(RoasterDto), HttpError))
  CoffeesApiRsesponse(Result(List(CoffeeDto), HttpError))
  CoffeeApiRsesponse(Result(CoffeeDto, HttpError))
  GetRoasters
  GetExperiments(coffee_id: String)
  ExperimentsApiResponse(Result(List(dtos.ExperimentDto), HttpError))
}

pub type AddNewCoffeeInputMsg {
  VaretialInput(value: String)
  ProcessInput(value: String)
  NameInput(value: String)
  OriginInput(value: String)
  TastingNotesInput(value: String)
  RoasterInput(value: String)
  RoastDate(value: String)
}

pub fn process_add_new_coffee_message(
  model: model.Model,
  msg: AddNewCoffeeInputMsg,
) -> model.Model {
  io.debug(msg)
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
    TastingNotesInput(input) ->
      Model(
        ..model,
        new_coffee_input: NewCoffeeInput(
          ..model.new_coffee_input,
          tasting_notes: Some(input),
        ),
      )
    RoastDate(input) ->
      Model(
        ..model,
        new_coffee_input: NewCoffeeInput(
          ..model.new_coffee_input,
          roast_date: Some(input),
        ),
      )
    RoasterInput(input) ->
      Model(
        ..model,
        new_coffee_input: NewCoffeeInput(
          ..model.new_coffee_input,
          roaster: Some(input),
        ),
      )
    ProcessInput(input) ->
      Model(
        ..model,
        new_coffee_input: NewCoffeeInput(
          ..model.new_coffee_input,
          process: Some(input),
        ),
      )
  }
}
