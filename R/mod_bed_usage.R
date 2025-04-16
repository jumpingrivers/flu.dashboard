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
bed_usage_ui <- function(id, cause) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::h1(cause, last_update_badge_ui(ns("last_update"))),
    value_box_row_ui(id = ns("value_boxes"), cause = cause),
    bed_usage_plot_ui(ns("plot"), cause = cause)
  )
}

#' @rdname bed_usage
#' @param selected_trusts Character vector of the trust ID codes that the user has selected in the
#'   filter.
#' @inheritParams load_all_data
#' @importFrom rlang .data .env
bed_usage_server <- function(id,
                             board_ref,
                             starting_year_end,
                             pin_name_template,
                             selected_trusts) {
  shiny::moduleServer(id, function(input, output, session) {
    ## Load data ----
    dataset <- load_all_data(board_ref = board_ref,
                             starting_year_end = starting_year_end,
                             pin_name_template = pin_name_template)

    filtered_data <- shiny::reactiveVal(dataset)

    ### Update filtered data when trust filter is used. ----
    shiny::observe({
      shiny::req(selected_trusts())
      filtered_data(dplyr::filter(dataset, .data$code %in% .env$selected_trusts()))
    }) |>
      shiny::bindEvent(selected_trusts(), ignoreNULL = TRUE, ignoreInit = TRUE)

    ### Date of last data update ----
    last_update_badge_server("last_update", .data = filtered_data)

    ## Value boxes ----
    value_box_row_server(id = "value_boxes",
                         selected_trusts = selected_trusts,
                         filtered_data = filtered_data)

    ## Bed usage ----
    bed_usage_plot_server(id = "plot", filtered_data = filtered_data, cause = "flu")
  })
}
