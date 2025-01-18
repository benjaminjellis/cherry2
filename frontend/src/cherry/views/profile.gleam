import cherry/model.{type Model}
import cherry/msg
import cherry/views/shared.{
  footer, header, main_class, main_div_class, view_class,
}
import gleam/option
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn view(model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(model), footer()])
}

fn log_in_body(model: Model) {
  html.div([class("w-full max-w-sm p-6 bg-pink-300 rounded-lg shadow-md")], [
    html.h2([class("mb-6 text-2xl font-bold text-center text-gray-800")], [
      html.text("Login"),
    ]),
    html.form(
      [
        event.on_submit(msg.LogInFormSubmit(
          password: model.log_in_input.password |> option.unwrap(""),
          email: model.log_in_input.email |> option.unwrap(""),
        )),
      ],
      [email_input(), password_input(), submit()],
    ),
    html.p([class("mt-4 text-sm text-center text-gray-600")], [
      html.text("Don't have an account?"),
    ]),
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
