#' Add a row of key statistics in value boxes
#'
#' Shiny module for including a row of 4 key statistics as [bslib::value_box] objects.
#'
#' @inheritParams bed_usage_ui
#' @rdname value_box_row
value_box_row_ui <- function(id, cause) {
  ns <- shiny::NS(id)
  bslib::layout_columns(
    bslib::value_box(
      title = "Number of Trusts",
      value = shiny::textOutput(ns("number_of_filtered_trusts")),
      showcase = bsicons::bs_icon("hospital")
    ),
    bslib::value_box(
      title = "Current bed occupancy",
      value = shiny::textOutput(ns("current_bed_occupancy")),
      showcase = bsicons::bs_icon("person-bounding-box"),
      shiny::p("Based on number of laboratory-confirmed cases of ", cause)
    ),
    value_box_change_ui(id = ns("last_year"), period_label = "this time last year"),
    value_box_change_ui(id = ns("last_week"), period_label = "one week ago")
  )
}

#' @param filtered_data A [shiny::reactiveValues] object containing an entry called `full` which has
#'   the data only for the trusts selected in the user's filtering options.
#' @inheritParams bed_usage_server
#' @rdname value_box_row
value_box_row_server <- function(id, selected_trusts, filtered_data) {
  shiny::moduleServer(id, function(input, output, session) {
    output$number_of_filtered_trusts <- renderText(length(selected_trusts()))

    output$current_bed_occupancy <- renderText({
      current_usage <- filtered_data |>
        purrr::chuck("full") |>
        dplyr::slice_max(order_by = .data$date, n = 1, by = "code", with_ties = TRUE)
      formatC(
        sum(current_usage$occupancy, na.rm = TRUE),
        format = "f",
        big.mark = ",",
        digits = 0L
      )
    })

    value_box_change_server(
      id = "last_year",
      filtered_data = filtered_data,
      time_period = lubridate::years(1)
    )

    value_box_change_server(
      id = "last_week",
      filtered_data = filtered_data,
      time_period = lubridate::weeks(1)
    )
  })
}
