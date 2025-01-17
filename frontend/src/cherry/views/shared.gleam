import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn view_class() {
  class("bg-yellow-50 min-h-screen flex flex-col")
}

pub fn header() -> element.Element(a) {
  html.header(
    [class("flex justify-between items-center p-4 border-b-2 border-red-200")],
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

fn li_item(text: String, href: String) {
  html.li([class("text-2xl font-bold")], [
    html.a(
      [
        class("hover:underline hover:decoration-pink-300 decoration-4"),
        attribute.href(href),
      ],
      [html.text(text)],
    ),
  ])
}

fn header_nav() {
  html.nav([], [
    html.ul([class("flex space-x-4")], [
      li_item("coffees ☕", "./coffees"),
      li_item("experiments 🧪", "./experiments"),
      li_item("about 🔎", "./about"),
    ]),
  ])
}

pub fn footer() -> element.Element(a) {
  html.footer([class("bg-pink-300 p-4")], [
    html.div([class("flex justify-center")], [
      html.a(
        [
          attribute.href("https://github.com/benjaminjellis/cherry2"),
          attribute.target("_blank"),
        ],
        [
          html.img([
            class("h-10 w-10"),
            attribute.src("https://cdn-icons-png.flaticon.com/512/25/25231.png"),
            attribute.alt("GitHub"),
          ]),
        ],
      ),
    ]),
  ])
}
