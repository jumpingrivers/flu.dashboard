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
      usage_plot <- plot_annual_time_series(wide_usage())
      plotly::ggplotly(usage_plot, tooltip = "text")
    })

    output$region_time_series_plot <- plotly::renderPlotly({
      usage_plot <- plot_region_time_series(wide_usage())
      plotly::ggplotly(usage_plot, tooltip = "text")
    })
  })
}
