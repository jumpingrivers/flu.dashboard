time_series_panel_ui <- function(id, panel_title) {
  ns <- shiny::NS(id)
  bslib::nav_panel(
    title = panel_title,
    bslib::card_body(
      plotly::plotlyOutput(ns("time_series_plot"))
    ),
    bslib::card_footer(
      shiny::downloadButton(
        ns("download_png"),
        shiny::tagList(bsicons::bs_icon("graph-down-arrow", a11y = "deco"),
                       " Download plot as PNG"),
        class = "btn-outline-primary",
        icon = NULL
      ),
      shiny::downloadButton(
        ns("download_pdf"),
        shiny::tagList(bsicons::bs_icon("file-earmark-pdf", a11y = "deco"),
                       " Download plot as PDF"),
        class = "btn-outline-primary",
        icon = NULL
      ),
      shiny::downloadButton(
        ns("download_csv"),
        shiny::tagList(bsicons::bs_icon("file-earmark-spreadsheet", a11y = "deco"),
                       " Download data as CSV"),
        class = "btn-outline-primary",
        icon = NULL
      ),
      class = "d-flex justify-content-end"
    )
  )
}

time_series_panel_server <- function(id, .data, summary_fn, plot_fn, cause) {
  shiny::moduleServer(id, function(input, output, session) {
    ts_data <- shiny::reactive(summary_fn(.data()))
    ts_plot <- shiny::reactive(plot_fn(ts_data(), cause = cause))

    output$time_series_plot <- plotly::renderPlotly({
      plotly::ggplotly(ts_plot(), tooltip = "text")
    })

    # Download handlers ----
    output$download_png <- shiny::downloadHandler(
      filename = paste(cause, id, "time-series-plot.png", sep = "-"),
      content = function(file) {
        ggplot2::ggsave(filename = file, plot = ts_plot(), width = 7)
      }
    )

    output$download_pdf <- shiny::downloadHandler(
      filename = paste(cause, id, "time-series-plot.pdf", sep = "-"),
      content = function(file) {
        ggplot2::ggsave(filename = file, plot = ts_plot(), width = 7)
      }
    )

    output$download_csv <- shiny::downloadHandler(
      filename = paste(cause, id, "time-series-data.csv", sep = "-"),
      content = function(file) {
        utils::write.csv(ts_data(), file = file, row.names = FALSE)
      }
    )
  })
}
