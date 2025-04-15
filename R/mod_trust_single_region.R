trust_single_region_ui <- function(id, region, trusts) {
  ns = shiny::NS(id)
  bslib::accordion_panel(
    title = region,
    shiny::p(
      shiny::actionLink(ns("select_all"), label = "Select all"),
      "|",
      shiny::actionLink(ns("remove_all"), label = "Unselect all")
    ),
    shiny::checkboxGroupInput(
      inputId = ns("trusts"),
      label = paste("Select", region, "trusts"),
      choices = tibble::deframe(trusts),
      selected = trusts$code
    ),
    value = ns("filter_group")
  )
}

## NOTE: The id is not first here because this is intended to be called from `purrr::imap`, which
# places the list key (name) as the second argument.
trust_single_region_server <- function(all_trust_codes, id) {
  shiny::moduleServer(id, function(input, output, session) {
    selected <- shiny::reactiveVal(value = character(0L))

    # select and de-select all actions
    shiny::observe({
      shiny::updateCheckboxGroupInput(
        session = session,
        inputId = "trusts",
        selected = character(0L)
      )
    }) |>
      shiny::bindEvent(input$remove_all)

    shiny::observe({
      shiny::updateCheckboxGroupInput(
        session = session,
        inputId = "trusts",
        selected = all_trust_codes
      )
    }) |>
      shiny::bindEvent(input$select_all)

    shiny::observe({
      selected(input$trusts)
    })

    return(selected)
  })
}
