import cherry/api
import cherry/model.{type Model, Model}
import cherry/msg.{type Msg}
import cherry/route.{
  About, CoffeeOverview, Coffees, Experiments, NotFound, Profile, SignUp, Splash,
}
import cherry/types
import cherry/views/about
import cherry/views/coffee_overview
import cherry/views/coffees
import cherry/views/experiments
import cherry/views/not_found
import cherry/views/profile
import cherry/views/sign_up
import cherry/views/splash
import gleam/dict
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/uri.{type Uri}
import lustre
import lustre/effect
import lustre/element
import modem

pub fn main() {
  let assert Ok(_) =
    lustre.application(init, update, view)
    |> lustre.start("#app", Nil)

  Nil
}

fn view(model: Model) -> element.Element(Msg) {
  case model.current_route {
    Coffees -> coffees.view(model)
    Splash -> splash.view(model)
    Experiments -> experiments.view(model)
    About -> about.view(model)
    CoffeeOverview(id) -> coffee_overview.view(model, id)
    NotFound -> not_found.view(model)
    Profile -> profile.view(model)
    SignUp -> sign_up.view(model)
  }
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  io.debug("init!")
  let data = dict.new()
  let dict = dict.new()
  let load_route = case modem.initial_uri() {
    Ok(uri) -> map_uri_to_route(uri)
    Error(_) -> Splash
  }
  #(
    Model(data, load_route, dict, False, model.LogInInput(None, None)),
    effect.batch([modem.init(on_route_change), api.get_coffees()]),
  )
}

fn on_route_change(uri: Uri) -> Msg {
  map_uri_to_route(uri) |> msg.OnRouteChange
}

fn map_uri_to_route(uri: Uri) -> route.Route {
  case uri.path_segments(uri.path) {
    ["coffee"] -> Coffees
    ["coffee", id] -> CoffeeOverview(id)
    ["experiments"] -> Experiments
    ["about"] -> About
    ["not_found"] -> NotFound
    _ -> Splash
  }
}

pub fn update(model: Model, msg: msg.Msg) -> #(Model, effect.Effect(msg.Msg)) {
  case msg {
    msg.OnRouteChange(route) -> update_on_route_change(model, route)
    msg.EmiaiInput(input) -> {
      let log_in_input =
        model.LogInInput(..model.log_in_input, email: Some(input))
      #(Model(..model, log_in_input: log_in_input), effect.none())
    }
    msg.PasswordInput(input) -> {
      let log_in_input =
        model.LogInInput(..model.log_in_input, password: Some(input))
      #(Model(..model, log_in_input: log_in_input), effect.none())
    }
    msg.UserRequestedSignUp(_, _) -> {
      // TODO: go through sign up flow
      #(model, effect.none())
    }
    msg.UserRequestedLogIn(password, email) -> {
      io.debug(password)
      io.debug(email)
      // TODO: dispatch this the backend
      let log_in_input = model.LogInInput(None, None)

      #(Model(..model, log_in_input: log_in_input), effect.none())
    }
    msg.CoffeeApiRsesponse(Ok(coffee)) -> {
      let coffees =
        coffee
        |> list.map(types.convert_dto_to_coffee_data)
        |> list.map(to_tuple)
        |> dict.from_list

      #(Model(..model, coffees:), effect.none())
    }
    msg.CoffeeApiRsesponse(Error(error)) -> {
      io.debug(error)
      #(model, effect.none())
    }
  }
}

fn to_tuple(a: types.CoffeeData) {
  #(a.id, a)
}

pub fn update_on_route_change(
  model: Model,
  route: route.Route,
) -> #(Model, effect.Effect(msg.Msg)) {
  let effects = case route == model.current_route {
    False -> {
      io.debug("Changing route so mutating browser state")
      let route_string = route |> route.to_string
      io.debug(route_string)
      [
        // modem.replace(route_string, None, None),
      // modem.push(route_string, None, None),
      ]
    }
    True -> []
  }

  case route {
    About | Coffees | NotFound | Splash | Experiments | Profile | SignUp -> #(
      Model(..model, current_route: route),
      effect.batch(effects),
    )
    // TODO: here the effect should be: if there is no ecxperiment data fetch it
    CoffeeOverview(_) -> #(
      Model(..model, current_route: route),
      effect.batch(effects),
    )
  }
}
// fn get_quote() -> effect.Effect(msg.Msg) {
//   let url = "https://dummyjson.com/quotes/random"
//   let decoder =
//     dynamic.decode2(
//       Quote,
//       dynamic.field("author", dynamic.string),
//       dynamic.field("quote", dynamic.string),
//     )
//
//   lustre_http.get(url, lustre_http.expect_json(decoder, ApiUpdatedQuote))
// }
