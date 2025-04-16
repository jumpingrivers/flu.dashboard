#' Summarise and plot time series data over multiple years
#'
#' @param .data A data frame containing the summarised data from `summarise_annual_time_series`.
#' @inheritParams bed_usage_plot_server
#' @return For `plot_annual_time_series`, a [ggplot2::ggplot()] of the time series of each year.
#' @rdname plot_annual_time_series
plot_annual_time_series <- function(.data, cause) {
  .data |>
    ggplot2::ggplot(ggplot2::aes(x = .data$date_of_year,
                                 y = .data$total,
                                 colour = .data$season)) +
    ggplot2::geom_line() +
    ggplot2::geom_point(
      ggplot2::aes(text = paste0(
        format(.data$date, "%d %b %Y"),
        ": ",
        formatC(
          .data$total,
          format = "f",
          big.mark = ",",
          digits = 0L
        ),
        " beds occupied"
      )),
      size = 0.1
    ) +
    ggplot2::labs(x = "Date",
                  y = "Beds occupied",
                  title = paste("Beds occupied due to laboratory-confirmed cases of", cause)) +
    ggplot2::guides(colour = ggplot2::guide_legend(title = "Season")) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom")
}

#' @rdname plot_annual_time_series
#' @param .data A data frame containing the time series data.
#' @return From `summarise_annual_time_series`, a data frame summarising the overall usage on each
#'   day of month. Note that the `date_of_year` column is faked in order to put all data entries in
#'   a leap year for comparisons.
summarise_annual_time_series <- function(.data) {
  .data |>
    dplyr::group_by(.data$season, .data$date) |>
    dplyr::summarise(total = sum(.data$total, na.rm = TRUE),
                     .groups = "drop") |>
    # Fudge the year to be a leap year so different years of data line up by calendar day.
    dplyr::mutate(
      fake_year = ifelse(lubridate::month(.data$date, label = FALSE) >= 6L, 2023, 2024),
      date_of_year = lubridate::`year<-`(.data$date, .data$fake_year)
    )
}
