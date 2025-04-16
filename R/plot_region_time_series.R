#' Summarise and plot time series data across all regions for this year
#'
#' @param .data A data frame containing the summarised data from `summarise_region_time_series`.
#' @inheritParams bed_usage_plot_server
#' @return For `plot_region_time_series`, a [ggplot2::ggplot()] of the total usage in each region.
#' @rdname plot_region_time_series
plot_region_time_series <- function(.data, cause) {
  .data |>
    ggplot2::ggplot(ggplot2::aes(x = .data$date,
                                 y = .data$total,
                                 colour = .data$nhs_england_region)) +
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
        " beds occupied in ",
        .data$nhs_england_region
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

#' @rdname plot_region_time_series
#' @param .data A data frame containing the time series data.
#' @return From `summarise_region_time_series`, a data frame summarising the overall usage on each
#'   day of eeach region in the latest year.
summarise_region_time_series <- function(.data) {
  .data |>
    dplyr::slice_max(order_by = .data$season, n = 1, with_ties = TRUE) |>
    dplyr::group_by(.data$nhs_england_region, .data$date) |>
    dplyr::summarise(total = sum(.data$total, na.rm = TRUE),
                     .groups = "drop")
}
