import cherry/model.{type Model, Model}
import cherry/msg.{type Msg, OnRouteChange}
import cherry/route.{About, Coffees, Experiments, Splash}
import cherry/types.{TableData}
import cherry/views/about.{about_view}
import cherry/views/coffees.{coffees_view}
import cherry/views/experiments.{experiments_view}
import cherry/views/splash.{splash_view}
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
