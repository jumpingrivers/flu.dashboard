test_that("get_year_end() blocks non-date objects", {
  exp_msg <- "`date` must be a Date object"
  expect_error(get_year_end("01/01/2025"), exp_msg)
  expect_error(get_year_end(0L), exp_msg)
})

test_that("get_year_end() returns the correct year end", {
  dates <- data.frame(
    date = lubridate::dmy("02-01-2022") + months(0:14),
    target = rep(c(2022, 2023), times = c(11, 4))
  )

  # individual dates
  for (i in seq_len(nrow(dates))) {
    expect_identical(!!get_year_end(dates$date[i]), !!dates$target[i])
  }

  # vectorwise operation
  expect_identical(get_year_end(dates$date), dates$target)
})
