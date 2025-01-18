import lustre/attribute.{class}
import lustre/element
import lustre/element/html

pub fn view_class() {
  class("bg-yellow-50 min-h-svh flex flex-col")
}

pub fn main_div_class() {
  class("min-h-100 flex flex-col")
}

pub fn header() -> element.Element(a) {
  html.header(
    [class("flex justify-between items-center p-4 border-b-2 border-red-200")],
    [
      html.div([class("text-2xl font-bold")], [
        html.a([attribute.href("./splash")], [
          html.img([
            class("object-cover h-14 w-30 "),
            attribute.src("./priv/static/assets/logo.png"),
          ]),
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
      li_item("profile 👤", "/profile"),
    ]),
  ])
}

pub fn footer() -> element.Element(a) {
  html.footer([class("p-4 border-t-2 border-red-200")], [
    html.div([class("flex justify-center")], [
      html.a(
        [
          attribute.href("https://github.com/benjaminjellis/cherry2"),
          attribute.target("_blank"),
          class("mx-2"),
        ],
        [
          html.img([
            class("h-7 w-7"),
            attribute.src("https://cdn-icons-png.flaticon.com/512/25/25231.png"),
            attribute.alt("GitHub"),
          ]),
        ],
      ),
      html.a(
        [
          attribute.href("https://ko-fi.com/benjaminjellis"),
          attribute.target("_blank"),
          class("mx-2"),
        ],
        [
          html.img([
            class("h-7 w-7"),
            attribute.src("https://cdn-icons-png.flaticon.com/512/25/25231.png"),
            attribute.alt("Kofi"),
          ]),
        ],
      ),
    ]),
  ])
}
