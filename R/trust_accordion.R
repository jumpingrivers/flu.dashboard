prepare_trust_accordion <- function(trust_list, ns) {
  trust_list |>
    tibble::as_tibble() |>
    dplyr::distinct() |>
    tidyr::nest(trusts = c("name", "code")) |>
    dplyr::mutate(
      region_code = tolower(gsub(" ", "_", .data$nhs_england_region)),
      accordion_panel = purrr::pmap(
        .l = list(
          region = .data$nhs_england_region,
          region_code = .data$region_code,
          trusts = .data$trusts
        ),
        .f = create_trust_accordion_panel,
        ns = ns
      )
    )
}

create_trust_accordion_panel <- function(region, region_code, trusts, ns) {
  trusts_in_region <- tibble::deframe(trusts)
  bslib::accordion_panel(
    # title = shiny::checkboxInput(
    #   inputId = paste0("trusts_", region_code, "_all"),
    #   label = region,
    #   value = TRUE
    # ),
    title = region,
    shiny::checkboxGroupInput(
      inputId = ns(paste0("trusts_", region_code)),
      label = paste("Select", region, "trusts"),
      choices = tibble::deframe(trusts),
      selected = trusts$code
    ),
    value = ns(paste0("filter_group_", region_code))
  )
}
