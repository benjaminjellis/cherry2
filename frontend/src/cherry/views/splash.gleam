import cherry/model.{type Model}
import cherry/msg
import cherry/views/shared.{
  footer, header, main_class, main_div_class, view_class,
}
import lustre/element
import lustre/element/html

pub fn view(_model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(), footer()])
}

fn main_content() -> element.Element(msg.Msg) {
  html.main([main_class()], [
    html.div([main_div_class()], [html.text("splash")]),
  ])
}
