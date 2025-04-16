time_series_panel_ui <- function(id, panel_title) {
  ns <- shiny::NS(id)
  bslib::nav_panel(
    title = panel_title,
    plotly::plotlyOutput(ns("time_series_plot"))
  )
}

time_series_panel_server <- function(id, .data, summary_fn, plot_fn, cause) {
  shiny::moduleServer(id, function(input, output, session) {
    ts_data <- shiny::reactive(summary_fn(.data()))
    ts_plot <- shiny::reactive(plot_fn(ts_data(), cause = cause))

    output$time_series_plot <- plotly::renderPlotly({
      plotly::ggplotly(ts_plot(), tooltip = "text")
    })
  })
}
