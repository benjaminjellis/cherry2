import lustre
import lustre/effect
import lustre/element
import model.{type Model, Model}
import msg.{UserDecrementedCount, UserIncrementedCount}
import types.{TableData}
import views/coffees.{coffees_view}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

fn view(model: Model) -> element.Element(msg.Msg) {
  coffees_view(model)
}

fn init(_flags) -> #(Model, effect.Effect(msg.Msg)) {
  let data =
    TableData(header: ["Coffee", "Roaster", "Roast Date"], content: [
      ["La Senda", "Plot", "1/6/25"],
      ["El Burro Lot #16", "Special Guests", "7/1/25"],
      ["Catarina Ramirez", "Curve Coffee", "26/8/24"],
    ])
  #(Model(0, data), effect.none())
}

pub fn update(model: Model, msg: msg.Msg) -> #(Model, effect.Effect(msg.Msg)) {
  case msg {
    UserIncrementedCount -> #(
      Model(..model, count: model.count + 1),
      effect.none(),
    )
    UserDecrementedCount -> #(
      Model(..model, count: model.count - 1),
      effect.none(),
    )
  }
}
