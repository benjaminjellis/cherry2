import gleam/list
import lustre/attribute.{class}
import lustre/element/html
import lustre/internals/vdom
import types.{type TableData}

fn table_class() {
  class("table-auto border-collapse w-full")
}

pub fn simple_table(data: TableData) {
  html.table([table_class()], [
    html.thead([], list.reverse(table_header(data.header, []))),
    html.tbody([], list.reverse(table_body(data.content, []))),
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

fn row_class() {
  class("hover:bg-pink-300")
}

fn table_body(
  content: List(List(String)),
  out: List(vdom.Element(a)),
) -> List(vdom.Element(a)) {
  case content {
    [] -> out
    [h] -> [html.tr([row_class()], list.reverse(one_table_row(h, []))), ..out]
    [h, ..t] ->
      table_body(t, [
        html.tr([row_class()], list.reverse(one_table_row(h, []))),
        ..out
      ])
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
