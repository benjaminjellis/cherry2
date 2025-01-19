import cherry/model.{type Model}
import cherry/msg
import cherry/views/shared.{
  footer, header, log_in_body, main_class, main_div_class, view_class,
}
import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn view(model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(model), footer()])
}

fn profile_body() {
  html.div([class("w-full max-w-sm p-6 bg-white rounded-lg shadow-md")], [
    html.h2([], [html.text("Profile goes here")]),
  ])
}

fn main_content(model: Model) -> element.Element(msg.Msg) {
  let body = case model.is_user_logged_in {
    True -> profile_body()
    False -> log_in_body(model)
  }
  html.main([main_class()], [html.div([main_div_class()], [body])])
}
