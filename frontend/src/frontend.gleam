import components/table
import gleam/dynamic
import gleam/list
import lustre
import lustre/attribute.{class}
import lustre/effect
import lustre/element
import lustre/element/html
import lustre_http

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

pub type Msg {
  UserIncrementedCount
  UserDecrementedCount
  ApiReturnedCats(Result(List(Cat), lustre_http.HttpError))
}

pub type Cat {
  Cat(id: String, url: String)
}

pub type Model {
  Model(count: Int, cats: List(Cat))
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  #(Model(0, []), effect.none())
}

pub fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg {
    UserIncrementedCount -> #(Model(..model, count: model.count + 1), get_cat())
    UserDecrementedCount -> #(
      Model(count: model.count - 1, cats: list.drop(model.cats, 1)),
      effect.none(),
    )
    ApiReturnedCats(Ok(api_cats)) -> {
      let assert [cat, ..] = api_cats
      #(Model(..model, cats: [cat, ..model.cats]), effect.none())
    }
    ApiReturnedCats(Error(_)) -> #(model, effect.none())
  }
}

fn get_cat() -> effect.Effect(Msg) {
  let decoder =
    dynamic.decode2(
      Cat,
      dynamic.field("id", dynamic.string),
      dynamic.field("url", dynamic.string),
    )
  let expect = lustre_http.expect_json(dynamic.list(decoder), ApiReturnedCats)

  lustre_http.get("https://api.thecatapi.com/v1/images/search", expect)
}

fn view(model: Model) -> element.Element(Msg) {
  let data = table.TableData(header: ["First", "Second", "Third"], content: [])
  html.div([class("min-h-screen flex flex-col")], [
    header(),
    main_content(data),
    footer(),
  ])
}

fn main_content(data: table.TableData) -> element.Element(Msg) {
  html.main([class("flex-grow p-4")], [
    html.div([class("min-h-screen flex flex-col")], [table.simple_table(data)]),
  ])
}

fn header() -> element.Element(a) {
  html.header([class("py-5 px-5 text-white bf-faffpink")], [
    html.img([attribute.src("./priv/static/assets/logo.png")]),
  ])
}

fn footer() -> element.Element(a) {
  html.footer([class("bg-pink-200 text-white p-4")], [
    html.div([class("px-5")], [html.text("footer")]),
    html.div([class("px-5")], [html.text("footer 2")]),
  ])
}
