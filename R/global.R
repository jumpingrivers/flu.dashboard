global <- function() {
  board_ref <<- pins::board_connect(auth = "envvar") # nolint: object_usage_linter
  trust_list <<- get_trust_list(board_ref = board_ref, pin_name = "keith/nhs_flu_2025_full") # nolint: object_usage_linter
}
