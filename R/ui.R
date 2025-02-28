#' Shiny UI
#'
#' Core UI of package.
#'
#' @param req The request object.
#'
#' @keywords internal
ui <- function(req) {
  shiny::navbarPage(
    theme = bslib::bs_theme(version = 5),
    title = "Flu dashboard",
    id = "main-menu",
    shiny::tabPanel(
      "First tab",
      shiny::h1("First tab")
    ),
    shiny::tabPanel(
      "Second tab",
      shiny::h1("Second tab")
    )
  )
}
