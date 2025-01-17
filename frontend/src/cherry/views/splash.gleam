import cherry/model.{type Model}
import cherry/msg
import cherry/views/shared.{footer, header, view_class}
import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn view(model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(), footer()])
}

fn main_content() -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([class("min-h-screen flex flex-col")], [html.text("Splasg")]),
  ])
}
