import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import model.{type Model}
import msg
import types.{type TableData}
import views/shared.{footer, header, view_class}

pub fn about_view(model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(model.coffees), footer()])
}

fn main_content(_data: TableData) -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([class("min-h-screen flex flex-col px-10")], [
      html.h1([class("font-bold ")], [
        html.text(
          "Cherry is a coffee log book build to help you brew better coffee",
        ),
      ]),
    ]),
  ])
}
