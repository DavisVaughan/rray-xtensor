context("test-abs")

test_that("rray_abs() basics", {

  expect_equal(rray_abs(-1), new_array(1))
  expect_equal(rray_abs(-1L), new_array(1L))

  # with names
  x <- rray(c(-1, -2), c(2, 1), list(c("r1", "r2"), "c1"))

  expect_equal(
    rray_abs(x),
    rray(c(1, 2), c(2, 1), list(c("r1", "r2"), "c1"))
  )

})

test_that("rray_abs() corner cases", {

  # Logicals
  expect_equal(rray_abs(TRUE), new_array(1L))
  expect_equal(rray_abs(FALSE), new_array(0L))

  # NaN
  expect_equal(rray_abs(NaN), as_array(NaN))

  # 0
  expect_equal(rray_abs(0), as_array(0))
  expect_equal(rray_abs(0L), as_array(0L))

  # Inf
  expect_equal(rray_abs(-Inf), as_array(Inf))
})

# ------------------------------------------------------------------------------

context("test-remainder")

test_that("rray_fmod() + rray_remainder() basics", {

  expect_equal(rray_fmod(1, 2), new_array(1))
  expect_equal(rray_remainder(1, 2), new_array(1))

  expect_equal(rray_fmod(1L, 2L), new_array(1L))
  expect_equal(rray_remainder(1L, 2L), new_array(1L))

  # 12 / 8 = 1.5 -> n = 2 or 1?
  # This is the `|n - x / y| = 1/2` case
  # Chosen to be n = 2, i.e. even, by convention.
  expect_equal(rray_remainder(12, 8), as_array(-4))

  # broadcasting
  x <- matrix(1:5)
  expect_equal(vec_dim(rray_fmod(x, t(x))), c(5, 5))
  expect_equal(vec_dim(rray_remainder(x, t(x))), c(5, 5))

  # with names
  x <- rray(c(0, 0), c(2, 1), list(c("r1", "r2"), "c1"))
  expect_equal(
    rray_fmod(x, 1),
    rray(c(0, 0), c(2, 1), list(c("r1", "r2"), "c1"))
  )

})

test_that("rray_fmod() + rray_remainder() corner cases", {

  # Logicals
  expect_equal(rray_fmod(TRUE, TRUE), new_array(0L))
  expect_equal(rray_remainder(TRUE, TRUE), new_array(0L))
  expect_equal(rray_fmod(TRUE, FALSE), new_array(NA_integer_))
  expect_equal(rray_remainder(TRUE, FALSE), new_array(NA_integer_))

  # NaN
  expect_equal(rray_fmod(Inf, NaN), as_array(NaN))
  expect_equal(rray_remainder(Inf, NaN), new_array(NaN))
  expect_equal(rray_fmod(Inf, 1), as_array(NaN))
  expect_equal(rray_remainder(Inf, 1), new_array(NaN))

  # 0
  expect_equal(rray_fmod(1, 0), as_array(NaN))
  expect_equal(rray_remainder(1, 0), new_array(NaN))

  # Inf
  expect_equal(rray_fmod(Inf, Inf), as_array(NaN))
  expect_equal(rray_remainder(Inf, Inf), new_array(NaN))
})

# ------------------------------------------------------------------------------

context("test-multiple-add")

test_that("rray_multiply_add() basics", {

  expect_equal(rray_multiply_add(1, 2, 1), new_array(3))
  expect_equal(rray_multiply_add(1L, 2L, 1L), new_array(3L))

  # broadcasting
  x <- matrix(1:5)
  expect_equal(vec_dim(rray_multiply_add(x, t(x), x)), c(5, 5))

  # with names
  x <- rray(c(0, 0), c(2, 1), list(c("r1", "r2"), "c1"))
  expect_equal(
    rray_multiply_add(x, 1, 1),
    rray(c(1, 1), c(2, 1), list(c("r1", "r2"), "c1"))
  )

})

test_that("rray_multiply_add() corner cases", {

  # Logicals
  expect_equal(rray_multiply_add(TRUE, TRUE, TRUE), new_array(2L))
  expect_equal(rray_multiply_add(FALSE, FALSE, FALSE), new_array(0L))

  # NaN
  expect_equal(rray_multiply_add(NaN, NaN, NaN), as_array(NaN))

  # Inf
  expect_equal(rray_multiply_add(-Inf, -1, 1), as_array(Inf))
})
