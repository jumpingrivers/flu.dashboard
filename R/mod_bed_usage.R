bed_usage_ui <- function(id,
                         cause) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::h1(cause),
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
        shiny::p("Based on number of laboratory-confirmed cases")
      )
    )
  )
}

#' @importFrom rlang .data .env
bed_usage_server <- function(id,
                             board_ref,
                             pin_name,
                             selected_trusts) {
  shiny::moduleServer(id, function(input, output, session) {
    ## Load data ----
    requireNamespace("nanoparquet", quietly = TRUE)
    dataset <- pins::pin_read(board = board_ref,
                              name = pin_name)

    filtered_data <- shiny::reactiveValues(
      full = dataset
    )

    shiny::observe({
      req(selected_trusts())
      filtered_data$full <- dplyr::filter(dataset, .data$code %in% .env$selected_trusts())
    }) |>
      shiny::bindEvent(selected_trusts(), ignoreNULL = TRUE, ignoreInit = TRUE)

    ## Value boxes ----
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

  })
}
