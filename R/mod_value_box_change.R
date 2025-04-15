#' Single value box for showing change over time
#'
#' One value box for showing the change in bed occupancy over a given time period
#'
#' @param period_label Character description of the time period that will be quoted in the value box title.
#'   The title will be prefixed with the words "Change since", before printing your period label afterwards.
#'   Aim to keep this concise.
#' @inheritParams value_box_row_ui
#' @rdname value_box_change
value_box_change_ui <- function(id, period_label) {
  ns <- shiny::NS(id)
  bslib::value_box(
    title = paste("Change since", period_label),
    value = shiny::textOutput(ns("difference")),
    showcase = bsicons::bs_icon("arrow-up-right")
  )
}

#' @inheritParams value_box_row_server
#' @inheritParams change_over_time
#' @rdname value_box_change
value_box_change_server <- function(id, filtered_data, time_period) {
  shiny::moduleServer(id, function(input, output, session) {
    output$difference <- shiny::renderText({
      change_over_time(filtered_data(), time_period) |>
        dplyr::pull("change") |>
        sum(na.rm = TRUE) |>
        formatC(format = "f", big.mark = ",", digits = 0L)
    })
  })
}
