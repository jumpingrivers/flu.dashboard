global <- function() {
  board_ref <<- pins::board_connect(auth = "envvar") # nolint: object_usage_linter

  cfg <- config::get(file = system.file("config.yml", package = "flu.dashboard"))

  trust_list <<- get_trust_list(
    board_ref = board_ref,
    pin_name = file.path(
      cfg$pins_username,
      sprintf(cfg$fulldata_name_template, get_year_end(Sys.Date())),
      fsep = "/"
    )
  ) # nolint: object_usage_linter
}
