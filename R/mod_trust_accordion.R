trust_accordion_filter_ui <- function(id, trust_list) {
  ns <- shiny::NS(id)
  # Generate each accordion panel in a map.
  panels <- trust_list |>
    tibble::as_tibble() |>
    dplyr::distinct() |>
    tidyr::nest(trusts = c("name", "code")) |>
    dplyr::mutate(
      region_code = tolower(gsub(" ", "_", .data$nhs_england_region)),
      accordion_panel = purrr::pmap(
        .l = list(
          id = ns(.data$region_code),
          region = .data$nhs_england_region,
          trusts = .data$trusts
        ),
        .f = trust_single_region_ui
      )
    )
  bslib::accordion(panels$accordion_panel, open = FALSE)
}

trust_accordion_filter_server <- function(id, trust_list) {
  shiny::moduleServer(id, function(input, output, session) {
    # Create a module server for each region (accordion panel)
    region_code_table <- trust_list |>
      tibble::as_tibble() |>
      dplyr::distinct() |>
      dplyr::mutate(region_code = tolower(gsub(" ", "_", .data$nhs_england_region))) |>
      dplyr::reframe(codes = list(.data$code), .by = "region_code") |>
      tibble::deframe()
    all_regions <- shiny::reactiveValues(
      !!!purrr::imap(region_code_table, trust_single_region_server)
    )

    # Collapse all the reactive values from each panel into a single character vector of all
    # Trusts selected.
    shiny::reactive({
      shiny::isolate(all_regions) |>
        shiny::reactiveValuesToList() |>
        purrr::map(~ .x()) |>
        purrr::list_c()
    })
  })
}
