import gleam/list
import lustre/attribute.{class}
import lustre/element/html
import lustre/internals/vdom

pub type TableData {
  TableData(header: List(String), content: List(List(String)))
}

fn table_class() {
  class("table-auto border-collapsenpx tailwindcss ")
}

pub fn simple_table(data: TableData) {
  html.table([table_class()], [
    html.thead([], list.reverse(table_header(data.header, []))),
    html.tbody([], []),
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

fn table_body(content: List(List(String))) {
  todo
}

fn one_th_for_header(value: String) {
  html.th([], [html.p([class("")], [html.text(value)])])
}
