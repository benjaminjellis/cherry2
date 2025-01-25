import cherry/model.{type Model}
import cherry/msg
import cherry/views/shared.{
  footer, header, main_class, main_div_class, view_class,
}
import gleam/dict
import gleam/list
import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import lustre/event

pub fn view(model: Model) -> element.Element(msg.Msg) {
  html.div([view_class()], [header(), main_content(model), footer()])
}

fn main_content(model: Model) -> element.Element(msg.Msg) {
  html.main([main_class()], [
    html.div([class("")], [
      html.div([class("p-6 bg-pink-300 rounded-lg shadow-md")], [
        html.form([], [first_row(model), second_row(), third_row()]),
      ]),
    ]),
  ])
}

fn second_row() {
  html.div([class("flex space-x-4")], [
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [
        html.text("Varetial"),
      ]),
      html.input([
        event.on_input(msg.EmiaiInput),
        attribute.type_("varetial"),
        attribute.id("varetial"),
        attribute.class(
          "w-full p-2 border border-red-200 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-200 focus:border-transparent",
        ),
        attribute.placeholder("e.g. Pache"),
        attribute.required(True),
      ]),
    ]),
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [
        html.text("Origin"),
      ]),
      html.input([
        event.on_input(msg.EmiaiInput),
        attribute.type_("origin"),
        attribute.id("origin"),
        attribute.class(
          "w-full p-2 border border-red-200 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-200 focus:border-transparent",
        ),
        attribute.placeholder("e.g. Gutemala"),
        attribute.required(True),
      ]),
    ]),
  ])
}

fn third_row() {
  html.div([class("mt-4")], [
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [
        html.text("Tasting Notes"),
      ]),
      html.input([
        event.on_input(msg.EmiaiInput),
        attribute.type_("Tasting Notes"),
        attribute.id("Tasting Notes"),
        attribute.class(
          "w-full p-2 border border-red-200 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-200 focus:border-transparent",
        ),
        attribute.placeholder("e.g. Finca El Paraiso"),
        attribute.required(True),
      ]),
    ]),
  ])
}

fn first_row(model: Model) {
  let roasters_list =
    model.roasters |> dict.to_list |> list.map(fn(a) { { a.1 }.name })

  html.div([class("flex space-x-4")], [
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [html.text("Name")]),
      html.input([
        event.on_input(msg.EmiaiInput),
        attribute.type_("name"),
        attribute.id("name"),
        attribute.class(
          "w-full p-2 border border-red-200 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-200 focus:border-transparent",
        ),
        attribute.placeholder("e.g. La Senda Champagne Yeast"),
        attribute.required(True),
      ]),
    ]),
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [
        html.text("Roaster"),
      ]),
      html.select(
        [
          attribute.id("roaster"),
          attribute.name("roaster"),
          class(
            "flex-1 p-2 border border-red-200 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-200 focus:border-transparent",
          ),
        ],
        create_options(roasters_list, []),
      ),
    ]),
  ])
}

fn create_options(inputs: List(String), options) {
  case inputs {
    [] -> list.reverse(options)
    [head, ..tail] -> {
      let new_options = [html.option([], head), ..options]
      create_options(tail, new_options)
    }
  }
}
