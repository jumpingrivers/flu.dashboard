#' Create time series plot of data over multiple years
#'
#' @param .data A data frame containing the time series data.
#' @inheritParams bed_usage_plot_server
#' @return A [ggplot2::ggplot()] of the time series of each year.
plot_annual_time_series <- function(.data, cause) {
  .data |>
    dplyr::group_by(.data$season, .data$date) |>
    dplyr::summarise(total = sum(.data$total, na.rm = TRUE),
                     .groups = "drop") |>
    # Fudge the year to be a leap year so different years of data line up by calendar day.
    dplyr::mutate(
      fake_year = ifelse(lubridate::month(.data$date, label = FALSE) >= 6L, 2023, 2024),
      date_of_year = lubridate::`year<-`(.data$date, .data$fake_year)
    ) |>
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
    ggplot2::guides(colour = ggplot2::guide_legend(title = "NHS England Region")) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom")
}
