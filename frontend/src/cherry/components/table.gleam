import cherry/msg
import cherry/route
import cherry/types.{type CoffeeData}
import gleam/dict
import gleam/list
import lustre/attribute.{class}
import lustre/element/html
import lustre/event
import lustre/internals/vdom
import rada/date

fn table_class() {
  class("table-auto border-collapse w-full mb-4")
}

fn row_class(coffee_id: String) {
  [
    class("hover:bg-pink-300"),
    event.on_click(msg.OnRouteChange(route.CoffeeOverview(coffee_id))),
  ]
}

pub fn coffees_table(data: List(CoffeeData)) -> vdom.Element(msg.Msg) {
  html.table([table_class()], [
    html.thead([], header()),
    html.tbody([], list.reverse(rows(data, []))),
  ])
}

fn header() {
  [
    one_th_for_header("name"),
    one_th_for_header("roaster"),
    one_th_for_header("origin"),
    one_th_for_header("varetial"),
    one_th_for_header("roast date"),
  ]
}

fn rows(coffees: List(CoffeeData), out: List(vdom.Element(msg.Msg))) {
  case coffees {
    [] -> out
    [h, ..t] -> rows(t, [build_row(h.id, h), ..out])
  }
}

fn build_row(id: String, coffee: CoffeeData) {
  html.tr(row_class(id), [
    table_element(coffee.name),
    table_element(coffee.roaster),
    table_element(coffee.origin),
    table_element(coffee.varetial),
    table_element(date.to_iso_string(coffee.roast_date)),
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

fn table_row(value: List(String), out: List(vdom.Element(a))) {
  case value {
    [] -> out
    [h] -> [table_element(h), ..out]
    [h, ..t] -> table_row(t, [table_element(h), ..out])
  }
}

fn table_element(value: String) {
  html.td([class("border-b border-lime-200 text-left p-2")], [
    html.p([class("")], [html.text(value)]),
  ])
}
