#' Add a time series plot of bed usage
#'
#' Shiny module for including a time series plot of bed usage.
#'
#' @inheritParams bed_usage_ui
#' @rdname bed_usage_plot
bed_usage_plot_ui <- function(id, cause) {
  ns <- shiny::NS(id)
  bslib::layout_columns(
    bslib::navset_card_pill(
      title = paste("Bed-usage due to", cause),
      placement = "above",
      bslib::nav_panel(
        title = "Annual comparison",
        plotly::plotlyOutput(ns("annual_time_series_plot"))
      ),
      bslib::nav_panel(
        title = "Regional comparison",
        plotly::plotlyOutput(ns("region_time_series_plot"))
      )
    )
  )
}

#' @inheritParams value_box_row_server
#' @inheritParams bed_usage_plot_ui
#' @rdname bed_usage_plot
bed_usage_plot_server <- function(id, filtered_data, cause) {
  shiny::moduleServer(id, function(input, output, session) {
    wide_usage <- shiny::reactive({
      filtered_data$full |>
        tidyr::pivot_wider(names_from = "bed_type", values_from = "occupancy") |>
        dplyr::rename(G_and_A = "G&A") |>
        dplyr::mutate(
          total = .data$G_and_A + .data$CC,
          season = lubridate::quarter(.data$date, type = "year_start/end", fiscal_start = 6) |>
            gsub(pattern = " Q[1-4]$", replacement = "") |>
            factor()
        )
    })

    output$annual_time_series_plot <- plotly::renderPlotly({
      usage_plot <- wide_usage() |>
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
      plotly::ggplotly(usage_plot, tooltip = "text")
    })

    output$region_time_series_plot <- plotly::renderPlotly({
      usage_plot <- wide_usage() |>
        dplyr::slice_max(order_by = .data$season, n = 1, with_ties = TRUE) |>
        dplyr::group_by(.data$nhs_england_region, .data$date) |>
        dplyr::summarise(total = sum(.data$total, na.rm = TRUE),
                         .groups = "drop") |>
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
      plotly::ggplotly(usage_plot, tooltip = "text")
    })
  })
}
