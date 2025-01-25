import cherry/model.{type Model}
import cherry/msg
import cherry/views/shared.{
  footer, header, main_class, main_div_class, view_class,
}
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

pub fn view(_model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(), footer()])
}

fn main_content() -> element.Element(msg.Msg) {
  html.main([main_class()], [
    html.div([main_div_class()], [html.form([], [first_row(), first_row()])]),
  ])
}

fn first_row() {
  html.div([], [
    html.input([
      event.on_input(msg.EmiaiInput),
      attribute.type_("email"),
      attribute.id("email"),
      attribute.class(
        "w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent",
      ),
      attribute.placeholder("e.g. example@domain.com"),
      attribute.required(True),
    ]),
  ])
}
