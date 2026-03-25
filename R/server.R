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
  cfg <- config::get(file = system.file("config.yml", package = "flu.dashboard"))

  bed_usage_server(
    id = "flu",
    board_ref = board_ref, # nolint: object_usage_linter
    starting_year_end = 2022,
    pin_name_template = file.path(
      cfg$pins_username,
      cfg$fulldata_name_template,
      fsep = "/"
    ),
    selected_trusts = selected_trusts
  )
}
