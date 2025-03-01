import cherry/components/table
import cherry/model.{type Model}
import cherry/msg
import cherry/route
import cherry/types.{type CoffeeData}
import cherry/views/shared.{footer, header, main_div_class, view_class}
import gleam/dict
import gleam/list
import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import lustre/event
import lustre/internals/vdom
import rada/date

fn filter_data(data: dict.Dict(String, CoffeeData)) {
  data
  |> dict.to_list()
  |> list.filter_map(fn(x) {
    let coffee = x.1
    case coffee.in_current_rotation == True {
      False -> Error("")
      True -> Ok(coffee)
    }
  })
  |> list.sort(fn(a, b) { date.compare(a.roast_date, b.roast_date) })
}

fn build_row_for_coffee(coffee: CoffeeData) {
  html.tr(table.row_class(coffee.id), [
    table.table_element(coffee.name),
    table.table_element(coffee.roaster),
    table.table_element(coffee.origin),
    table.table_element(coffee.varetial),
    table.table_element(date.to_iso_string(coffee.roast_date)),
  ])
}

pub fn coffees_table(data: List(CoffeeData)) -> vdom.Element(msg.Msg) {
  table.generic_table(
    ["name", "roaster", "origin", "varetial", "roast date"],
    data,
    build_row_for_coffee,
  )
}

pub fn view(model: Model) {
  let ordered_coffee = filter_data(model.coffees)
  html.div([view_class()], [header(), main_content(ordered_coffee), footer()])
}

fn add_new_coffee_button() {
  html.div([class("flex justify-between items-center mb-2")], [
    html.h2([class("text-lg font-semibold")], []),
    html.button(
      [
        class(
          "px-4 py-2 text-sm bg-lime-200 text-white rounded hover:bg-lime-500 transition",
        ),
        attribute.alt("Add a new coffee"),
        event.on_click(msg.OnRouteChange(route.AddCoffee)),
      ],
      [html.text("➕")],
    ),
  ])
}

fn main_content(data: List(CoffeeData)) -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([main_div_class()], [coffees_table(data), add_new_coffee_button()]),
  ])
}
