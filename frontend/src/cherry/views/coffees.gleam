import cherry/components/table
import cherry/model.{type Model}
import cherry/msg
import cherry/types
import cherry/views/shared.{footer, header, view_class}
import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn view(model: Model) {
  html.div([view_class()], [header(), main_content(model.coffees), footer()])
}

fn main_content(data: types.CoffeesData) -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([class("min-h-screen flex flex-col")], [table.coffees_table(data)]),
  ])
}
