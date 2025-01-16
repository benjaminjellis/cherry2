import components/table
import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import model.{type Model}
import msg
import types.{type TableData}

pub fn coffees_view(model: Model) -> element.Element(msg.Msg) {
  html.div([class("min-h-screen flex flex-col")], [
    header(),
    main_content(model.coffees),
    footer(),
  ])
}

fn main_content(data: TableData) -> element.Element(msg.Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([class("min-h-screen flex flex-col")], [table.simple_table(data)]),
  ])
}

fn header() -> element.Element(a) {
  html.header(
    [class("flex justify-between items-center p-4 border-b-2 border-red-300")],
    [
      html.div([class("text-2xl font-bold")], [
        html.img([
          class("object-cover h-14 w-30 "),
          attribute.src("./priv/static/assets/logo.png"),
        ]),
      ]),
      header_nav(),
    ],
  )
}

fn li_item(text: String) {
  html.li([class("text-lg font-bold")], [
    html.a([class("hover:underline hover:decoration-pink-300 decoration-4")], [
      html.text(text),
    ]),
  ])
}

fn header_nav() {
  html.nav([], [
    html.ul([class("flex space-x-4")], [
      li_item("coffees ☕"),
      li_item("experiments 🧪"),
      li_item("about 🔎"),
    ]),
  ])
}

fn footer() -> element.Element(a) {
  html.footer([class("bg-pink-200 text-white p-4")], [
    html.div([class("px-5")], [html.text("footer")]),
    html.div([class("px-5")], [html.text("footer 2")]),
  ])
}
