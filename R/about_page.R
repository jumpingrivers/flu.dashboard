#' @importFrom markdown mark
about_page <- function() {
  processing_description <- yaml::read_yaml(system.file("about", "about_how_it_works.yaml",
                                                        package = "flu.dashboard")) |>
    purrr::chuck("processing_stages")

  shiny::fluidRow(
    shiny::column(
      width = 12,
      shiny::h1("About this app"),
    ),
    shiny::column(
      width = 6,
      shiny::includeMarkdown(system.file("about", "about_main.md", package = "flu.dashboard"))
    ),
    shiny::column(
      width = 6,
      shiny::includeMarkdown(system.file("about", "about_how_it_works.md",
                                         package = "flu.dashboard")),
      shiny::h3("How we prepare the data"),
      bslib::accordion(!!!unname(purrr::imap(processing_description, accordion_panel_maker)),
                       multiple = FALSE)
    )
  )
}

accordion_panel_maker <- function(x, idx) {
  bslib::accordion_panel(title = paste0(idx, ": ", x$title), shiny::includeMarkdown(x$body))
}
