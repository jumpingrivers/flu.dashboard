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
    board_ref = board_ref,
    pin_name = "keith/nhs_flu_2025_full",
    selected_trusts = selected_trusts
  )
}
