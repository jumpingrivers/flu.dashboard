#' Get a table of the trust names
#'
#' @param board_ref Connection to a Pins board.
#' @param pin_name Name of the pin that is on the Posit Connect board. The connection to the board
#'   is created automatically through Environment Variable authentication, meaning that the
#'   environment variables `CONNECT_API_KEY` and `CONNECT_SERVER` should be configured.
#'
#'   The format of the pin is assumed to be "parquet".
#' @return A data frame containing a column of Trust Name (`name`), Region (`nhs_england_region`),
#'   and Trust ID code (`code`).
get_trust_list <- function(board_ref, pin_name) {
  requireNamespace("nanoparquet", quietly = TRUE)
  dataset <- pins::pin_read(board = board_ref, name = pin_name)
  dplyr::select(dataset, "nhs_england_region", "name", "code")
}
