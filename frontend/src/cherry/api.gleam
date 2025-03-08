import cherry/dtos.{CoffeeDto}
import cherry/model
import cherry/msg
import decode/zero as decode
import gleam/dynamic.{type Dynamic}
import gleam/http.{type Method, Get}
import gleam/http/request.{Request}
import gleam/io
import gleam/json
import gleam/option.{None}
import lustre_http

fn roaster_decoder() {
  use name <- decode.field("name", decode.string)
  use id <- decode.field("id", decode.string)
  decode.success(dtos.RoasterDto(name:, id:))
}

fn experiment_decoder() {
  use id <- decode.field("id", decode.string)
  use date <- decode.field("date", decode.string)
  use coffee_id <- decode.field("coffee_id", decode.string)
  use brew_method <- decode.field("brew_method", decode.string)
  use grinder <- decode.field("grinder", decode.string)
  use grind_setting <- decode.field("grind_setting", decode.string)
  use recipe <- decode.field("recipe", decode.string)
  use liked <- decode.field("liked", decode.bool)
  use notes <- decode.field("notes", decode.string)
  use added <- decode.field("added", decode.string)
  use last_updated <- decode.field("last_updated", decode.string)

  decode.success(dtos.ExperimentDto(
    id:,
    date:,
    coffee_id:,
    brew_method:,
    grinder:,
    grind_setting:,
    recipe:,
    liked:,
    notes:,
    added:,
    last_updated:,
  ))
}

fn coffee_decoder() {
  use name <- decode.field("name", decode.string)
  use id <- decode.field("id", decode.string)
  use roaster <- decode.field("roaster", decode.string)
  use roaster_name <- decode.field("roaster_name", decode.string)
  use roast_date <- decode.field("roast_date", decode.string)
  use origin <- decode.field("origin", decode.string)
  use varetial <- decode.field("varetial", decode.string)
  use in_current_rotation <- decode.field("in_current_rotation", decode.bool)
  use process <- decode.field("process", decode.string)

  decode.success(CoffeeDto(
    name:,
    id:,
    roaster:,
    roaster_name:,
    roast_date:,
    origin:,
    varetial:,
    in_current_rotation:,
    process:,
  ))
}

fn decode_experiments(data: Dynamic) {
  decode.run(data, decode.list(experiment_decoder()))
}

fn decode_roasters(data: Dynamic) {
  decode.run(data, decode.list(roaster_decoder()))
}

fn decode_coffees(data: Dynamic) {
  decode.run(data, decode.list(coffee_decoder()))
}

fn decode_coffee(data: Dynamic) {
  io.debug("Decoding...")
  decode.run(data, coffee_decoder())
}

pub fn get_coffee(coffee_id: String, config: model.Config) {
  let request =
    Request(
      method: Get,
      headers: [],
      body: "",
      scheme: case config.use_https {
        True -> http.Https
        False -> http.Http
      },
      host: config.host,
      port: None,
      path: "/api/coffee/" <> coffee_id,
      query: None,
    )
  lustre_http.send(
    request,
    lustre_http.expect_json(decode_coffee, msg.CoffeeApiRsesponse),
  )
}

pub fn get_all_rasters(config: model.Config) {
  let request = create_request(config, Get, "", "/api/roaster/all")
  lustre_http.send(
    request,
    lustre_http.expect_json(decode_roasters, msg.RoastersApiResponse),
  )
}

pub fn get_experiments_for_coffee(coffee_id: String, config: model.Config) {
  let request =
    create_request(
      config,
      Get,
      "",
      "/api/coffee/" <> coffee_id <> "/experiment",
    )
  lustre_http.send(
    request,
    lustre_http.expect_json(decode_experiments, msg.ExperimentsApiResponse),
  )
}

pub fn get_coffees(config: model.Config) {
  let request = create_request(config, Get, "", "/api/coffee")

  lustre_http.send(
    request,
    lustre_http.expect_json(decode_coffees, msg.CoffeesApiRsesponse),
  )
}

pub fn add_new_coffee(config: model.Config, new_coffee: model.NewCoffeeInput) {
  let body = new_coffee_input_to_string(new_coffee)
  io.debug(body)
  let request = create_request(config, http.Post, body, "/api/coffee")
  io.debug(request)
  lustre_http.send(
    request,
    lustre_http.expect_json(decode_coffee, msg.NewCoffeeApiResponse),
  )
}

// TODO: might be better to raise an error here rather than just defaulting to an empty string / value
fn new_coffee_input_to_string(new_coffee: model.NewCoffeeInput) -> String {
  let json_object =
    json.object([
      #("name", json.string(new_coffee.name |> option.unwrap(""))),
      #("roaster", json.string(new_coffee.roaster |> option.unwrap(""))),
      #("roast_date", json.string(new_coffee.roast_date |> option.unwrap(""))),
      #("origin", json.string(new_coffee.origin |> option.unwrap(""))),
      #("varetial", json.string(new_coffee.varietal |> option.unwrap(""))),
      #("process", json.string(new_coffee.process |> option.unwrap(""))),
      #(
        "tasting_notes",
        json.string(new_coffee.tasting_notes |> option.unwrap("")),
      ),
      #("liked", json.bool(False)),
      #("in_current_rotation", json.bool(True)),
    ])
  json_object |> json.to_string
}

fn create_request(
  config: model.Config,
  method: Method,
  body: String,
  path: String,
) {
  let headers = case method {
    http.Post -> [#("Content-Type", "application/json")]

    _ -> []
  }
  Request(
    method:,
    headers:,
    body:,
    scheme: case config.use_https {
      True -> http.Https
      False -> http.Http
    },
    host: config.host,
    port: None,
    path:,
    query: None,
  )
}
