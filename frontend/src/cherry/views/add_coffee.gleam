import cherry/model
import cherry/msg
import cherry/types
import cherry/views/shared.{footer, header, main_class, view_class}
import gleam/list
import gleam/result
import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import lustre/event

pub fn view(
  list_of_roasters: List(types.RoasterData),
  new_coffee_inputs: model.NewCoffeeInput,
) -> element.Element(msg.Msg) {
  html.div([view_class()], [
    header(),
    main_content(list_of_roasters, new_coffee_inputs),
    footer(),
  ])
}

fn main_content(
  list_of_roasters: List(types.RoasterData),
  new_coffee_inputs: model.NewCoffeeInput,
) -> element.Element(msg.Msg) {
  html.main([main_class()], [
    html.div([], [
      html.div([class("p-6 bg-pink-300 rounded-lg shadow-md")], [
        html.form([event.on_submit(msg.UserAddedNewCoffee(new_coffee_inputs))], [
          first_row(list_of_roasters),
          second_row(),
          third_row(),
          foruth_row(),
          submit(),
        ]),
      ]),
    ]),
  ])
}

fn third_row() {
  html.div([class("flex space-x-4")], [
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [
        html.text("Process"),
      ]),
      html.input([
        event.on_input(fn(x) { msg.AddNewCoffeeInput(msg.ProcessInput(x)) }),
        attribute.type_("process"),
        attribute.id("process"),
        attribute.class(
          "w-full p-2 border border-red-200 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-200 focus:border-transparent",
        ),
        attribute.placeholder("e.g. Naturla"),
        attribute.required(True),
      ]),
    ]),
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [
        html.text("Roast Date"),
      ]),
      html.input([
        event.on_input(fn(x) { msg.AddNewCoffeeInput(msg.RoastDate(x)) }),
        attribute.type_("date"),
        attribute.id("roast-date"),
        attribute.class(
          "w-full p-2 border border-red-200 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-200 focus:border-transparent",
        ),
        attribute.required(True),
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
        event.on_input(fn(x) { msg.AddNewCoffeeInput(msg.VaretialInput(x)) }),
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
        event.on_input(fn(x) { msg.AddNewCoffeeInput(msg.OriginInput(x)) }),
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

fn foruth_row() {
  html.div([class("mt-4")], [
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [
        html.text("Tasting Notes"),
      ]),
      html.input([
        event.on_input(fn(x) { msg.AddNewCoffeeInput(msg.TastingNotesInput(x)) }),
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

fn first_row(list_of_roasters: List(types.RoasterData)) {
  html.div([class("flex space-x-4")], [
    html.div([class("m-4")], [
      html.label([class("block mb-2 text-sm font-medium")], [html.text("Name")]),
      html.input([
        event.on_input(fn(x) { msg.AddNewCoffeeInput(msg.NameInput(x)) }),
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
          event.on_input(fn(roaster_name) {
            let roaster =
              list_of_roasters
              |> list.find(fn(roaster) { roaster.name == roaster_name })
              // HACK: the list is only ever built from the data returned by the server so 
              // we should never actually need to insert the case provided
              |> result.unwrap(types.RoasterData("", ""))
            msg.AddNewCoffeeInput(msg.RoasterInput(roaster.id))
          }),
          attribute.id("roaster"),
          attribute.name("roaster"),
          class(
            "flex-1 p-2 border border-red-200 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-200 focus:border-transparent",
          ),
        ],
        create_options(
          list_of_roasters |> list.map(fn(roaster) { roaster.name }),
          [],
        ),
      ),
    ]),
  ])
}

fn submit() {
  html.div([class("m-4")], [
    html.button(
      [
        attribute.type_("submit"),
        class("w-full px-4 py-2 bg-lime-200 rounded-md hover:bg-lime-500"),
      ],
      [html.text("🚀")],
    ),
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
