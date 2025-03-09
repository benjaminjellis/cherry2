import cherry/components/spinner
import cherry/components/table
import cherry/model.{type Model}
import cherry/msg
import cherry/route
import cherry/types.{type CoffeeData}
import cherry/views/shared.{footer, header, main_div_class, view_class}
import gleam/dict
import gleam/io
import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import lustre/event
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

fn display_heart(liked) -> String {
  case liked {
    True -> "⭐"
    False -> ""
  }
}

fn build_row_for_experiments(experiment: types.Experiment) {
  html.tr(table.row_class(experiment.id), [
    table.table_element(experiment.date |> date.to_iso_string),
    table.table_element(experiment.grinder),
    table.table_element(experiment.grind_setting),
    table.table_element(experiment.liked |> display_heart),
  ])
}

fn experiments_table(experiment_data: List(types.Experiment)) {
  table.generic_table(
    ["date", "grinder", "grind setting", ""],
    experiment_data,
    build_row_for_experiments,
  )
}

fn add_new_experiment_button() {
  html.div([class("flex justify-between items-center mb-2")], [
    html.h2([class("text-lg font-semibold")], []),
    html.button(
      [
        class(
          "px-4 py-2 text-sm bg-lime-200 text-white rounded hover:bg-lime-500 transition",
        ),
        attribute.alt("Add a new experiment"),
        event.on_click(msg.OnRouteChange(route.AddCoffee)),
      ],
      [html.text("➕")],
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
  experiments: Result(List(types.Experiment), Nil),
) -> element.Element(msg.Msg) {
  let experiments = case experiments {
    Error(_) -> {
      io.debug("no experiment")
      []
    }
    Ok(experiments) -> {
      experiments
    }
  }
  let _ = case coffee_data {
    Error(_) ->
      html.main([class("flex-grow p-4")], [
        html.div([main_div_class()], [spinner.spinner()]),
      ])
    Ok(coffee) ->
      html.main([class("p-8 flex justify-center")], [
        html.div([], [
          coffee_overview(coffee),
          html.br([]),
          html.div([], [
            experiments_table(experiments),
            add_new_experiment_button(),
          ]),
        ]),
      ])
  }
}
