import cherry/model.{type Model}
import cherry/msg
import cherry/views/shared.{footer, header, main_div_class, view_class}
import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn view(_model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(), footer()])
}

fn main_content() -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([main_div_class()], [
      html.h1([class("font-bold ")], [
        html.text(
          "Cherry is a coffee log book built to help you brew better coffee",
        ),
      ]),
    ]),
  ])
}
