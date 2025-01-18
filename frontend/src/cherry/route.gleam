import gleam/option.{None}
import gleam/uri

pub type Route {
  Splash
  Coffees
  Experiments
  About
  CoffeeOverview(id: String)
  NotFound
  Profile
}

pub fn to_string(route: Route) {
  case route {
    About -> "./about"
    CoffeeOverview(id) -> "./coffee/" <> id
    Coffees -> "./coffee"
    Experiments -> "./experiments"
    NotFound -> "./not_found"
    Splash -> "/"
    Profile -> "./profile"
  }
}

pub fn to_uri(route: Route) {
  case route {
    About -> uri.Uri(None, None, None, None, "/about", None, None)
    CoffeeOverview(id) ->
      uri.Uri(
        None,
        None,
        None,
        None,
        "coffee/" <> id <> "/overview",
        None,
        None,
      )
    Coffees -> uri.Uri(None, None, None, None, "/coffee", None, None)
    Experiments -> uri.Uri(None, None, None, None, "/experiments", None, None)
    NotFound -> uri.Uri(None, None, None, None, "/not_found", None, None)
    Splash -> uri.Uri(None, None, None, None, "/", None, None)
    Profile -> uri.Uri(None, None, None, None, "/profile", None, None)
  }
}
