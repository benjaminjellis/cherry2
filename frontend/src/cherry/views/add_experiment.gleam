import cherry/components/spinner
import cherry/msg
import cherry/views/shared.{footer, header, main_div_class, view_class}
import lustre/attribute.{class}

import lustre/element

import lustre/element/html

pub fn view() -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(), footer()])
}

fn main_content() {
  html.main([class("flex-grow p-4")], [
    html.div([main_div_class()], [spinner.spinner()]),
  ])
}
