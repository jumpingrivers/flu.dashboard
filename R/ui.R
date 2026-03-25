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
    bslib::nav_panel(
      title = "Flu",
      bed_usage_ui(id = "flu", cause = "Flu")
    ),
    bslib::nav_panel(
      title = "About",
      about_page()
    ),
    bslib::nav_spacer(),
    bslib::nav_item(
      shiny::tags$a(
        shiny::icon("github"), "View source code",
        href = "https://github.com/jumpingrivers/flu.dashboard",
        target = "_blank"
      )
    )
  )
}
