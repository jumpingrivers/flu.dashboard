trust_filter_ui <- function(id) {
  ns <- shiny::NS(id)

  # choices_tree <- shinyWidgets::create_tree(
  #   data = trust_list
  # )

  trust_accordion <- prepare_trust_accordion(trust_list, ns)

  shiny::tagList(
    shiny::h2("Filter ", shiny::tags$abbr("ICBs", title = "Integrated Care Boards")),
    # shinyWidgets::treeInput(
    #   inputId = ns("selected_trusts"),
    #   label = shiny::tagList("Choose ", shiny::tags$abbr("ICBs", title = "Integrated Care Boards")),
    #   choices = choices_tree,
    #   selected = unique(trust_list$code),
    #   closeDepth = 0L,
    #   returnValue = "id"
    # )
    bslib::accordion(
      trust_accordion$accordion_panel,
      open = FALSE
    )
  )
}

#' @importFrom rlang .data .env
trust_filter_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    region_codes <- tolower(gsub(" ", "_", unique(trust_list$nhs_england_region)))

    selected_trusts <- shiny::reactive({
      purrr::map(
        region_codes,
        function(code) {
          input[[paste0("trusts_", code)]]
        }
      ) |>
        unlist()
    })

    return(selected_trusts)
  })
}
