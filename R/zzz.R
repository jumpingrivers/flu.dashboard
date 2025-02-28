.onLoad <- function(...) {
  shiny::addResourcePath(
    "img",
    system.file("img", package = "flu.dashboard")
  )
}
