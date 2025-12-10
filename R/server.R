#' Server
#'
#' Core server function.
#'
#' @param input,output Input and output list objects
#' containing said registered inputs and outputs.
#' @param session Shiny session.
#'
#' @noRd
#' @keywords internal
server <- function(input, output, session) {
  selected_trusts <- trust_filter_server(id = "trust_filter")

  bed_usage_server(
    id = "flu",
    board_ref = board_ref, # nolint: object_usage_linter
    starting_year_end = 2022,
    pin_name_template = "keith/nhs_flu_%d_full",
    selected_trusts = selected_trusts
  )
}
