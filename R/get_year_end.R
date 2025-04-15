#' Determine the year end for a date.
#'
#' The year end is defined as the year where the current season ends. The start of a season is
#' defined as 1st December, therefore the end of a season is 30th November.
#'
#' @param date A Date object
#' @return An integer for the year when the current season ends. If the `date` value is in December,
#'   it will return the following calendar year.
#' @export
#' @examples
#' get_year_end(Sys.Date())
get_year_end <- function(date) {
  if (!lubridate::is.Date(date)) {
    cli::cli_abort("{.var date} must be a Date object but was {class(date)}!")
  }
  this_year <- lubridate::year(date)
  this_month <- lubridate::month(date)
  ifelse(this_month <= 11, this_year, this_year + 1L)
}
