import cherry/msg.{type Msg}
import cherry/types.{type CoffeeData, type CoffeesData}
import gleam/list
import lustre/attribute.{class}
import lustre/element/html
import lustre/event
import lustre/internals/vdom

fn table_class() {
  class("table-auto border-collapse w-full")
}

fn row_class(coffee_id: String) {
  [class("hover:bg-pink-300"), event.on_click(msg.UserClickedRow(coffee_id))]
}

pub fn coffees_table(data: CoffeesData) -> vdom.Element(msg.Msg) {
  html.table([table_class()], [
    html.thead([], header()),
    html.tbody([], list.reverse(rows(data.coffees, []))),
  ])
}

fn header() {
  [
    one_th_for_header("name"),
    one_th_for_header("roaster"),
    one_th_for_header("roast date"),
  ]
}

fn rows(coffees: List(CoffeeData), out: List(vdom.Element(msg.Msg))) {
  case coffees {
    [] -> out
    [h] -> [build_row(h), ..out]
    [h, ..t] -> rows(t, [build_row(h), ..out])
  }
}

fn build_row(coffee: CoffeeData) {
  html.tr(row_class(coffee.id), [
    one_table_element(coffee.name),
    one_table_element(coffee.roaster),
    one_table_element(coffee.roast_date),
  ])
}

fn table_header(
  header: List(String),
  out: List(vdom.Element(a)),
) -> List(vdom.Element(a)) {
  case header {
    [] -> out
    [h] -> [one_th_for_header(h), ..out]
    [h, ..t] -> table_header(t, [one_th_for_header(h), ..out])
  }
}

fn one_th_for_header(value: String) {
  html.th([class("border-b-4 border-lime-200 text-left p-2")], [
    html.p([class("")], [html.text(value)]),
  ])
}

fn one_table_row(value: List(String), out: List(vdom.Element(a))) {
  case value {
    [] -> out
    [h] -> [one_table_element(h), ..out]
    [h, ..t] -> one_table_row(t, [one_table_element(h), ..out])
  }
}

fn one_table_element(value: String) {
  html.td([class("border-b border-lime-200 text-left p-2")], [
    html.p([class("")], [html.text(value)]),
  ])
}
