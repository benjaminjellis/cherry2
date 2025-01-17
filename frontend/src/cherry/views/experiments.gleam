import cherry/model.{type Model}
import cherry/msg
import cherry/types.{type TableData}
import cherry/views/shared.{footer, header, view_class}
import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn experiments_view(model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(model.coffees), footer()])
}

fn main_content(_data: TableData) -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([class("min-h-screen flex flex-col")], [html.text("Experiments")]),
  ])
}
