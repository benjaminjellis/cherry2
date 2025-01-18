import cherry/components/table
import cherry/model.{type Model}
import cherry/msg
import cherry/types.{type CoffeeData}
import cherry/views/shared.{footer, header, main_div_class, view_class}
import gleam/dict
import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn view(model: Model) {
  html.div([view_class()], [header(), main_content(model.coffees), footer()])
}

fn main_content(data: dict.Dict(String, CoffeeData)) -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([main_div_class()], [table.coffees_table(data)]),
  ])
}
