import cherry/model.{type Model}
import cherry/msg
import cherry/route
import gleam/option
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn view_class() {
  class("bg-yellow-50 min-h-svh flex flex-col")
}

pub fn main_div_class() {
  class("min-h-100 flex flex-col")
}

pub fn main_class() {
  class("p-8 flex justify-center")
}

pub fn header() {
  html.header(
    [class("flex justify-between items-center p-4 border-b-2 border-red-200")],
    [
      html.div([class("text-2xl font-bold")], [
        html.a([attribute.href("./")], [
          html.img([
            class("object-cover h-14 w-30 animate-wiggle"),
            attribute.src("./priv/static/assets/logo.png"),
          ]),
        ]),
      ]),
      header_nav(),
    ],
  )
}

fn li_item(text: String, route: route.Route) {
  html.li(
    [
      class(
        "text-2xl font-bold hover:underline hover:decoration-pink-300 decoration-4",
      ),
      event.on_click(msg.OnRouteChange(route)),
    ],
    [html.text(text)],
  )
}

fn header_nav() {
  html.nav([], [
    html.ul([class("flex space-x-4")], [
      li_item("coffees ☕", route.Coffees),
      li_item("experiments 🧪", route.Experiments),
      li_item("about 🔎", route.About),
      li_item("profile 👤", route.Profile),
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

pub fn log_in_body(model: Model) {
  html.div([class("w-full max-w-sm p-6 bg-pink-300 rounded-lg shadow-md")], [
    html.h2([class("mb-6 text-2xl font-bold text-center text-gray-800")], [
      html.text("Login"),
    ]),
    html.form(
      [
        event.on_submit(msg.UserRequestedLogIn(
          password: model.log_in_input.password |> option.unwrap(""),
          email: model.log_in_input.email |> option.unwrap(""),
        )),
      ],
      [email_input(), password_input(), submit()],
    ),
    html.p(
      [
        class("mt-4 text-sm text-center text-gray-600 hover:underline"),
        event.on_click(msg.OnRouteChange(route.SignUp)),
      ],
      [html.text("Don't have an account?")],
    ),
  ])
}

fn email_input() -> Element(msg.Msg) {
  html.div([class("mb-4")], [
    html.label([class("block mb-2 text-sm font-medium")], [html.text("Email")]),
    html.input([
      event.on_input(msg.EmiaiInput),
      attribute.type_("email"),
      attribute.id("email"),
      attribute.class(
        "w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent",
      ),
      attribute.placeholder("e.g. example@domain.com"),
      attribute.required(True),
    ]),
  ])
}

fn password_input() {
  html.div([class("mb-4")], [
    html.label([class("block mb-2 text-sm font-medium")], [
      html.text("Password"),
    ]),
    html.input([
      event.on_input(msg.PasswordInput),
      attribute.type_("password"),
      attribute.id("password"),
      attribute.class(
        "w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent",
      ),
      attribute.placeholder("pick something secure"),
      attribute.required(True),
    ]),
  ])
}

fn submit() {
  html.button(
    [
      attribute.type_("submit"),
      class("w-full px-4 py-2 bg-lime-200 rounded-md hover:bg-lime-500"),
    ],
    [html.text("🚀")],
  )
}
