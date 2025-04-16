last_update_badge_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::HTML("&nbsp;"),
    shiny::span(
      "Last updated: ",
      shiny::textOutput(ns("last_update"), inline = TRUE),
      class = "badge bg-info"
    )
  )
}

last_update_badge_server <- function(id, .data, date_format = "%d %B %Y") {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      output$last_update <- shiny::renderText(
        .data()$date |>
          max(na.rm = TRUE) |>
          format(date_format)
      )
    }
  )
}
