import cherry/model.{type Model, Model}
import cherry/msg.{type Msg, OnRouteChange, UserClickedRow}
import cherry/route.{About, CoffeeOverview, Coffees, Experiments, Splash}
import cherry/types.{CoffeeData}
import cherry/views/about
import cherry/views/coffee_overview
import cherry/views/coffees
import cherry/views/experiments
import cherry/views/splash
import gleam/dict
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
  }
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  let data =
    dict.from_list([
      #(
        "1234",
        CoffeeData(
          id: "1234",
          name: "Lot #15",
          roaster: "Special Guests",
          roast_date: "1/1/25",
        ),
      ),
    ])
  let dict = dict.new()
  #(Model(data, Splash, dict), modem.init(on_route_change))
}

fn on_route_change(uri: Uri) -> Msg {
  case uri.path_segments(uri.path) {
    ["coffees"] -> OnRouteChange(Coffees)
    ["coffee", id] -> OnRouteChange(CoffeeOverview(id))
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
    // when a user clicks a row in the coffee table we change the route and fetch the 
    UserClickedRow(id) -> #(
      Model(..model, current_route: CoffeeOverview(id)),
      effect.none(),
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
