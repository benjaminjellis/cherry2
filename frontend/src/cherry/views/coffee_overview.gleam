import cherry/model.{type Model}
import cherry/msg
import cherry/types.{type CoffeeData}
import cherry/views/shared.{footer, header, main_div_class, view_class}
import gleam/dict
import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn view(model: Model, id: String) -> element.Element(msg.Msg) {
  let coffee_data = model.coffees |> dict.get(id)
  let experiments = model.experiments_by_coffee |> dict.get(id)
  html.div([view_class()], [
    header(),
    main_content(coffee_data, experiments),
    footer(),
  ])
}

fn spinner() {
  html.div([class("flex justify-center items-center")], [
    html.div(
      [
        class(
          "w-16 h-16 border-4 border-pink-300 border-t-transparent rounded-full animate-spin",
        ),
      ],
      [],
    ),
  ])
}

fn coffee_overview(data: types.CoffeeData) {
  html.div([class("flex justify-center items-center")], [
    html.div([], [html.h1([], [html.text(data.name)])]),
  ])
}

fn main_content(
  coffee_data: Result(CoffeeData, Nil),
  _experiment,
) -> element.Element(msg.Msg) {
  let _ = case coffee_data {
    Error(_) ->
      html.main([class("flex-grow p-4")], [
        html.div([main_div_class()], [spinner()]),
      ])
    Ok(coffee) ->
      html.main([class("flex-grow p-4")], [
        html.div([main_div_class()], [coffee_overview(coffee)]),
      ])
  }
}
