import cherry/msg
import cherry/route
import gleam/io
import gleam/list
import lustre/attribute.{class}
import lustre/element/html
import lustre/event
import lustre/internals/vdom

fn table_class() {
  class("table-auto border-collapse w-full mb-4")
}

pub fn row_class(coffee_id: String) {
  [
    class("hover:bg-pink-300"),
    event.on_click(msg.OnRouteChange(route.CoffeeOverview(coffee_id))),
  ]
}

pub fn generic_table(
  headers: List(String),
  data: List(a),
  build_row: fn(a) -> vdom.Element(msg.Msg),
) {
  let headers = header(headers)
  html.table([table_class()], [
    html.thead([], headers),
    html.tbody([], list.reverse(rows(data, [], build_row))),
  ])
}

fn header(column_names: List(String)) {
  header_aux([], column_names)
}

fn header_aux(output, column_names: List(String)) {
  case column_names {
    [] -> list.reverse(output)
    [h, ..tail] -> header_aux([one_th_for_header(h), ..output], tail)
  }
}

fn rows(coffees: List(a), out: List(vdom.Element(msg.Msg)), build_row) {
  case coffees {
    [] -> out
    [h, ..t] -> rows(t, [build_row(h), ..out], build_row)
  }
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

pub fn table_element(value: String) {
  html.td([class("border-b border-lime-200 text-left p-2")], [
    html.p([class("")], [html.text(value)]),
  ])
}
