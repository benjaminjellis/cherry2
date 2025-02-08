import cherry/model.{type Model}
import cherry/msg
import cherry/types.{type CoffeeData}
import cherry/views/shared.{footer, header, main_div_class, view_class}
import gleam/dict
import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import rada/date

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
  html.div([class("p-6 bg-pink-300 rounded-lg shadow-md")], [
    html.h2([class("text-xl font-bold mb-4")], [html.text(data.name)]),
    three_element_row(
      "Roaster:",
      data.roaster,
      "Vareital:",
      data.varetial,
      "Origin:",
      data.origin,
    ),
    three_element_row(
      "Process:",
      data.process,
      "Roast Date:",
      data.roast_date |> date.to_iso_string,
      "",
      "",
    ),
  ])
}

fn three_element_row(
  header_one: String,
  data_one: String,
  header_two: String,
  data_two: String,
  header_three: String,
  data_three: String,
) {
  html.div([class("flex space-x-4")], [
    html.div([class("m-4")], [
      html.p([class("text-sm font-medium text-bold")], [
        html.text(header_one <> " " <> data_one),
      ]),
    ]),
    html.div([class("m-4")], [
      html.p([class("text-sm font-medium text-bold")], [
        html.text(header_two <> " " <> data_two),
      ]),
    ]),
    html.div([class("m-4")], [
      html.p([class("text-sm font-medium text-bold")], [
        html.text(header_three <> " " <> data_three),
      ]),
    ]),
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
      html.main([class("p-8 flex justify-center")], [
        html.div([], [coffee_overview(coffee)]),
      ])
  }
}
