#' Load data for all years from pins.
#'
#' Connect to a Posit Connect board and then pull data for all the years from the respective pins.
#'
#' @param board_ref A pointer to a Posit Connect board created by [pins::board_connect()] or an
#'   alternative location.
#' @param starting_year_end The (numeric) year end of the first year of data that should be
#'   imported. e.g., if the first year of data covers the 2021-2022 season, then the year end is
#'   2022.
#' @param pin_name_template Character template for the name of the pin containing the data. This
#'   uses [sprintf()] notation, so use `%d` as a placeholder for where the year should be entered.
#'   If the data is in parquet format, then the nanoparquet package is required.
#' @return A data frame containing the imported data and an additional column of year_end values.
load_all_data <- function(board_ref, starting_year_end, pin_name_template) {
  requireNamespace("nanoparquet", quietly = TRUE)
  seq(from = starting_year_end, to = get_year_end(Sys.Date())) |>
    rlang::set_names() |>
    purrr::map(
      function(year) {
        pins::pin_read(board = board_ref, name = sprintf(pin_name_template, year))
      }
    ) |>
    purrr::list_rbind(names_to = "year_end")
}
