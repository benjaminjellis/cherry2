import cherry/api
import cherry/model.{type Model, Model}
import cherry/msg.{type Msg}
import cherry/route.{
  About, AddCoffee, AddExperiment, CoffeeOverview, Coffees, Experiments,
  NotFound, Profile, SignUp, Splash,
}
import cherry/types
import cherry/views/about
import cherry/views/add_coffee
import cherry/views/add_experiment
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
import gleam/result
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
    AddCoffee ->
      add_coffee.view(
        model |> model.get_list_of_roasters,
        model.new_coffee_input,
      )
    route.AddExperiment -> add_experiment.view()
  }
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  io.debug("init")
  let config = model.get_confg()
  let coffees = dict.new()
  let dict = dict.new()
  let roasters = dict.new()
  let load_route = case modem.initial_uri() {
    Ok(uri) -> map_uri_to_route(uri)
    Error(_) -> Splash
  }
  let effects = case load_route {
    About
    | AddCoffee
    | AddExperiment
    | Experiments
    | Splash
    | SignUp
    | Profile
    | NotFound
    | Coffees -> []
    CoffeeOverview(id) -> [api.get_experiments_for_coffee(id, config)]
  }
  let effects = [
    modem.init(on_route_change),
    api.get_all_rasters(config),
    api.get_coffees(config),
    ..effects
  ]
  #(
    Model(
      coffees,
      roasters,
      load_route,
      dict,
      False,
      model.LogInInput(None, None),
      model.new_coffee_input(),
      config,
    ),
    // on init: 
    // - create the modem router
    // - get coffees from the api
    // - get roasters from the api
    effect.batch(effects),
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
    ["profile"] -> Profile
    ["add_coffee"] -> AddCoffee
    _ -> Splash
  }
}

pub fn update(
  model: Model,
  message: msg.Msg,
) -> #(Model, effect.Effect(msg.Msg)) {
  case message {
    msg.OnRouteChange(route) -> update_on_route_change(model, route)
    msg.UserAddedNewCoffee(new_coffee) -> {
      #(
        Model(..model, current_route: route.Coffees),
        effect.batch([api.add_new_coffee(model.config, new_coffee)]),
      )
    }
    msg.AddNewCoffeeInput(add_new_coffee_msg) -> {
      #(
        msg.process_add_new_coffee_message(model, add_new_coffee_msg),
        effect.none(),
      )
    }
    msg.GetRoasters -> {
      #(model, effect.none())
    }
    msg.EmiaiInput(input) -> {
      let log_in_input =
        model.LogInInput(..model.log_in_input, email: Some(input))
      #(Model(..model, log_in_input:), effect.none())
    }
    msg.PasswordInput(input) -> {
      let log_in_input =
        model.LogInInput(..model.log_in_input, password: Some(input))
      #(Model(..model, log_in_input:), effect.none())
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
    msg.RoastersApiResponse(Ok(roasters)) -> {
      let roasters_dict =
        roasters
        |> list.map(types.convert_dto_to_roaster_data)
        |> list.map(fn(x) { #(x.id, x) })
        |> dict.from_list
      #(Model(..model, roasters: roasters_dict), effect.none())
    }
    msg.RoastersApiResponse(Error(error)) -> {
      io.debug(error)
      #(model, effect.none())
    }
    msg.CoffeesApiRsesponse(response) -> {
      case response {
        Ok(coffee) -> {
          let coffees =
            coffee
            |> list.try_map(types.convert_dto_to_coffee_data)
          case coffees {
            Ok(coffees) -> {
              let coffees =
                coffees
                |> list.map(fn(x) { #(x.id, x) })
                |> dict.from_list
              #(Model(..model, coffees:), effect.none())
            }
            Error(_) -> #(model, effect.none())
          }
        }
        Error(error) -> {
          io.debug(error)
          #(model, effect.none())
        }
      }
    }
    msg.CoffeeApiRsesponse(resp) -> {
      case resp {
        Ok(coffee) -> {
          let coffee = coffee |> types.convert_dto_to_coffee_data
          case coffee {
            Ok(coffee) -> {
              let new_coffees = model.coffees |> dict.insert(coffee.id, coffee)
              #(Model(..model, coffees: new_coffees), effect.none())
            }
            Error(_) -> #(model, effect.none())
          }
        }
        Error(error) -> {
          io.debug(error)
          #(model, effect.none())
        }
      }
    }
    msg.NewCoffeeApiResponse(resp) -> {
      io.debug("Got Resp")
      case resp {
        Ok(new_coffee) -> {
          let coffee = new_coffee |> types.convert_dto_to_coffee_data
          case coffee {
            Ok(coffee) -> {
              let new_coffees = model.coffees |> dict.insert(coffee.id, coffee)
              #(Model(..model, coffees: new_coffees), effect.none())
            }
            Error(_) -> #(model, effect.none())
          }
        }
        Error(error) -> {
          io.debug(error)
          #(model, effect.none())
        }
      }
    }
    msg.ExperimentsApiResponse(response) -> {
      io.debug("Got experiments response")
      case response {
        Error(error) -> {
          io.debug(error)
          #(model, effect.none())
        }
        Ok(experiments) -> {
          case experiments |> list.first {
            Ok(first) -> {
              let id = first.coffee_id
              let experiments =
                experiments
                |> list.try_map(types.convert_dto_to_experiment)
              case experiments {
                Ok(experiments) -> {
                  let new_experiments =
                    dict.insert(model.experiments_by_coffee, id, experiments)
                  #(
                    Model(..model, experiments_by_coffee: new_experiments),
                    effect.none(),
                  )
                }
                Error(_) -> #(model, effect.none())
              }
            }
            Error(_) -> #(model, effect.none())
          }
        }
      }
    }
    msg.GetExperiments(coffee_id) -> {
      io.debug("Getting experiment")
      #(
        model,
        effect.batch([api.get_experiments_for_coffee(coffee_id, model.config)]),
      )
    }
  }
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
        modem.replace(route_string, None, None),
        // modem.push(route_string, None, None),
      ]
    }
    True -> []
  }
  case route {
    About
    | Coffees
    | NotFound
    | Splash
    | Experiments
    | Profile
    | AddExperiment
    | SignUp -> #(Model(..model, current_route: route), effect.batch(effects))

    AddCoffee -> {
      let roaster =
        model
        |> model.get_list_of_roasters
        |> list.first
        |> result.unwrap(types.RoasterData("", ""))
      #(
        Model(
          ..model,
          current_route: route,
          new_coffee_input: model.NewCoffeeInput(
            ..model.new_coffee_input,
            roaster: Some(roaster.id),
          ),
        ),
        effect.batch(effects),
      )
    }
    CoffeeOverview(id) -> {
      io.debug("Update on change for coffee overview")
      #(
        Model(..model, current_route: route),
        effect.batch([
          api.get_experiments_for_coffee(id, model.config),
          ..effects
        ]),
      )
    }
  }
}
