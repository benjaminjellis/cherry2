import cherry/dtos.{CoffeeDto}
import cherry/model
import cherry/msg
import decode/zero as decode
import gleam/dynamic.{type Dynamic}
import gleam/http.{Get}
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
  decode.run(data, decode.list(decoder))
}

pub fn get_coffees(config: model.Config) -> effect.Effect(msg.Msg) {
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
      path: "/api/coffee",
      query: None,
    )

  lustre_http.send(
    request,
    lustre_http.expect_json(decode_json_to_coffee_dto, msg.CoffeeApiRsesponse),
  )
}
