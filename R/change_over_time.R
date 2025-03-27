#' Get change in bed usage since the start of a time period
#'
#' @description
#' This creates a summary table of how bed usage has changed over the course of a time period.
#' The value reported is the total difference between the start of the time period and the latest
#' counts.
#'
#' Where a negative value is returned as the `change` value, this denotes there was a _decrease_ in
#' the bed occupancy from the start of the time period to the latest date in the data.
#'
#' @param .data A tibble or data frame showing the bed usage at all trusts at all available points
#'   in time.
#' @param time_period A time period to denote how far back in time from the latest reading we want
#'   to go in order to see the change over time. This should be a period object, which can be
#'   created using lubridate methods such as [`lubridate::years`]`(1)` to create a comparison with 1
#'   year ago, or [`lubridate::weeks`]`(2)` to create a comparison with 2 weeks ago.
#' @return A summary data frame containing the Trust `code`, the `bed_type`, and the `change`
#'   column containing the difference between the starting value and the final value.
change_over_time <- function(.data, time_period) {
  stopifnot(lubridate::is.period(time_period))
  latest_date <- max(.data$date, na.rm = TRUE)
  earlier_date <- latest_date - time_period
  .data |>
    dplyr::filter(.data$date %in% c(latest_date, earlier_date)) |>
    dplyr::arrange(.data$date) |>
    dplyr::group_by(.data$code, .data$bed_type) |>
    dplyr::reframe(change = diff(.data$occupancy))
}
