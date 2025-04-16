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
      time_series_panel_ui(id = ns("annual"), panel_title = "Annual comparison"),
      time_series_panel_ui(id = ns("region"), panel_title = "Regional comparison")
    )
  )
}

#' @inheritParams value_box_row_server
#' @inheritParams bed_usage_plot_ui
#' @rdname bed_usage_plot
bed_usage_plot_server <- function(id, filtered_data, cause) {
  shiny::moduleServer(id, function(input, output, session) {
    wide_usage <- shiny::reactive({
      filtered_data() |>
        tidyr::pivot_wider(names_from = "bed_type", values_from = "occupancy") |>
        dplyr::rename(G_and_A = "G&A") |>
        dplyr::mutate(
          total = .data$G_and_A + .data$CC,
          season = lubridate::quarter(.data$date, type = "year_start/end", fiscal_start = 6) |>
            gsub(pattern = " Q[1-4]$", replacement = "") |>
            factor()
        )
    })

    # Annual time series plot ----
    time_series_panel_server(id = "annual",
                             .data = wide_usage,
                             summary_fn = summarise_annual_time_series,
                             plot_fn = plot_annual_time_series,
                             cause = cause)

    # Regional time series plot for latest year ----
    time_series_panel_server(id = "region",
                             .data = wide_usage,
                             summary_fn = summarise_region_time_series,
                             plot_fn = plot_region_time_series,
                             cause = cause)
  })
}
