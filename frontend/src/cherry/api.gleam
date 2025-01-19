import cherry/dtos.{CoffeeDto}
import cherry/msg
import decode/zero as decode
import gleam/dynamic.{type Dynamic}
import gleam/http.{Get, Http}
import gleam/http/request.{Request}
import gleam/option.{None}
import lustre/effect
import lustre_http

fn decode_json_to_coffee_dto(data: Dynamic) {
  let decoder = {
    use name <- decode.field("name", decode.string)
    use id <- decode.field("id", decode.string)
    use roaster <- decode.field("roaster", decode.string)
    use roaster_name <- decode.field("roaster_name", decode.string)
    use roast_date <- decode.field("roast_date", decode.string)
    decode.success(CoffeeDto(name:, id:, roaster:, roaster_name:, roast_date:))
  }
  decode.run(data, decode.list(decoder))
}

pub fn get_coffees() -> effect.Effect(msg.Msg) {
  let host = "0.0.0.0:3000"

  let request =
    Request(
      method: Get,
      headers: [],
      body: "",
      scheme: Http,
      host: host,
      port: None,
      path: "/api/coffee",
      query: None,
    )

  lustre_http.send(
    request,
    lustre_http.expect_json(decode_json_to_coffee_dto, msg.CoffeeApiRsesponse),
  )
}
