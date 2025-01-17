import gleam/uri.{type Uri}
import lustre
import lustre/effect
import lustre/element
import model.{type Model, Model}
import modem
import msg.{type Msg, OnRouteChange}
import route.{About, Coffees, Experiments, Splash}
import types.{TableData}
import views/about.{about_view}
import views/coffees.{coffees_view}
import views/experiments.{experiments_view}
import views/splash.{splash_view}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

fn view(model: Model) -> element.Element(Msg) {
  case model.current_route {
    Coffees -> coffees_view(model)
    Splash -> splash_view(model)
    Experiments -> experiments_view(model)
    About -> about_view(model)
  }
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  let data =
    TableData(header: ["Coffee", "Roaster", "Roast Date"], content: [
      ["La Senda", "Plot", "1/6/25"],
      ["El Burro Lot #16", "Special Guests", "7/1/25"],
      ["Catarina Ramirez", "Curve Coffee", "26/8/24"],
    ])
  #(Model(data, Splash), modem.init(on_route_change))
}

fn on_route_change(uri: Uri) -> Msg {
  case uri.path_segments(uri.path) {
    ["coffees"] -> OnRouteChange(Coffees)
    ["experiments"] -> OnRouteChange(Experiments)
    ["about"] -> OnRouteChange(About)
    _ -> OnRouteChange(Splash)
  }
}

pub fn update(model: Model, msg: msg.Msg) -> #(Model, effect.Effect(msg.Msg)) {
  case msg {
    OnRouteChange(route) -> #(
      Model(..model, current_route: route),
      effect.none(),
    )
  }
}
