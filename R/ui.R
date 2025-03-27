#' Shiny UI
#'
#' Core UI of package.
#'
#' @param req The request object.
#'
#' @keywords internal
ui <- function(req) {
  bslib::page_navbar(
    title = "Bed usage dashboard",
    theme = bslib::bs_theme(
      version = 5,
      brand = system.file("brand", "_brand.yml", package = "flu.dashboard")
    ),
    id = "main-menu",
    lang = "en",
    sidebar = bslib::sidebar(trust_filter_ui(id = "trust_filter")),
    shiny::tabPanel(
      title = "Flu",
      bed_usage_ui(id = "flu", cause = "Flu")
    ),
    shiny::tabPanel(
      title = "About",
      shiny::h1("About")
    )
  )
}
