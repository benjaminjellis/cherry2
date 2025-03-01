import lustre/attribute
import lustre/element/html

pub fn spinner() {
  html.div([attribute.class("flex justify-center items-center")], [
    html.div(
      [
        attribute.class(
          "w-16 h-16 border-4 border-pink-300 border-t-transparent rounded-full animate-spin",
        ),
      ],
      [],
    ),
  ])
}
