trust_filter_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::h2("Filter ", shiny::tags$abbr("ICBs", title = "Integrated Care Boards")),
    trust_accordion_filter_ui(id = ns("accordion"), trust_list = trust_list) # nolint: object_usage_linter
  )
}

trust_filter_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    trust_accordion_filter_server(id = "accordion", trust_list = trust_list) # nolint: object_usage_linter
  })
}
