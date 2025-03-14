#' Create a page for displaying bed usage
#'
#' Dashboard content for displaying summary information about bed-occupancy for a particular cause
#' of illness.
#'
#' @param id Unique Shiny module ID to link the UI and Server components together.
#' @param cause Display name of the illness that a patient occupies a bed for. Write in lower case
#'   unless capitalisation is needed to denote an acronym of proper noun, since this will be
#'   displayed as text in the middle of sentences where needed.
#' @rdname bed_usage
bed_usage_ui <- function(id,
                         cause) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::h1(cause),
    value_box_row_ui(id = ns("value_boxes"), cause = cause)
  )
}

#' @rdname bed_usage
#' @param board_ref A pointer to a Posit Connect board created by [pins::board_connect] or an
#'   alternative location.
#' @param pin_name Name of the pin on the Posit Connect board containing the bed usage data for this
#'   particular illness. This data should have been pre-processed. If the data is in parquet format,
#'   then the nanoparquet package is required.
#' @param selected_trusts Character vector of the trust ID codes that the user has selected in the
#'   filter.
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

    value_box_row_server(id = "value_boxes",
                         selected_trusts = selected_trusts,
                         filtered_data = filtered_data)

  })
}
