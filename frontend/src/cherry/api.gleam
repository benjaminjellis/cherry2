import cherry/dtos.{CoffeeDto}
import cherry/model
import cherry/msg
import decode/zero as decode
import gleam/dynamic.{type Dynamic}
import gleam/http.{type Method, Get}
import gleam/http/request.{Request}
import gleam/option.{None}
import lustre_http

fn roaster_decoder() {
  use name <- decode.field("name", decode.string)
  use id <- decode.field("id", decode.string)
  decode.success(dtos.RoasterDto(name:, id:))
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
  decode.success(CoffeeDto(
    name:,
    id:,
    roaster:,
    roaster_name:,
    roast_date:,
    origin:,
    varetial:,
    in_current_rotation:,
  ))
}

fn decode_roasters(data: Dynamic) {
  decode.run(data, decode.list(roaster_decoder()))
}

fn decode_coffees(data: Dynamic) {
  decode.run(data, decode.list(coffee_decoder()))
}

fn decode_coffee(data: Dynamic) {
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

pub fn get_coffees(config: model.Config) {
  let request = create_request(config, Get, "", "/api/coffee")

  lustre_http.send(
    request,
    lustre_http.expect_json(decode_coffees, msg.CoffeesApiRsesponse),
  )
}

fn create_request(
  config: model.Config,
  method: Method,
  body: String,
  path: String,
) {
  Request(
    method:,
    headers: [],
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
