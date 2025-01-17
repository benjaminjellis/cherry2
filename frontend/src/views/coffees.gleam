import components/table
import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import model.{type Model}
import msg
import types.{type TableData}
import views/shared.{footer, header}

pub fn coffees_view(model: Model) -> element.Element(msg.Msg) {
  html.div([class("min-h-screen flex flex-col")], [
    header(),
    main_content(model.coffees),
    footer(),
  ])
}

fn main_content(data: TableData) -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([class("min-h-screen flex flex-col")], [table.simple_table(data)]),
  ])
}
