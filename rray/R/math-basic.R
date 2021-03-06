#' Absolute value
#'
#' Compute the absolute value.
#'
#' @param x A vector, matrix, array or rray.
#'
#' @details
#'
#' If `x` is logical, an integer is returned.
#'
#' @examples
#'
#' rray_abs(-1)
#'
#' x <- rray(1:5 * -1L, c(5, 1))
#'
#' rray_abs(x)
#'
#' rray_abs(TRUE)
#'
#' @family math functions
#' @export
rray_abs <- function(x) {

  if (is.logical(x)) {
    x <- x + 0L
  }

  rray_math_unary_base("abs", x)
}

# ------------------------------------------------------------------------------

#' Remainders
#'
#' @description
#'
#' * `rray_fmod()` computes the element-wise remainder of the floating point
#' division of `x / y`.
#'
#' * `rray_remainder()` computes the IEEE element-wise remainder of the
#' floating point division of `x / y`.
#'
#' @param x,y A vector, matrix, array or rray.
#'
#' @details
#'
#' * `rray_fmod()` - The floating-point remainder of the division operation
#' `x / y` calculated by this function is exactly the value `x - n * y`, where
#' `n` is `x / y` with its fractional part truncated.
#'
#' * `rray_remainder()` - The IEEE floating-point remainder of the division
#' operation `x / y` calculated by this function is exactly the
#' value `x - n * y`, where the value `n` is the integral value nearest the
#' exact value `x / y`. When `|n - x / y| = 1/2`, the value `n` is chosen
#' to be even. In contrast to `rray_fmod()`, the returned value is not
#' guaranteed to have the same sign as `x`.
#'
#' @examples
#' rray_fmod(1, 2)
#' rray_remainder(1, 2)
#'
#' # Always same sign as `x`
#' # 2 / 3 = 0.667 -> n = 0
#' # (2 - 0 * 3) = 2
#' rray_fmod(2, 3)
#'
#' # No guarantee of same sign as `x`
#' # 2 / 3 = 0.667 -> n = 1
#' # (2 - 1 * 3) = -1
#' rray_remainder(2, 3)
#'
#' # 12 / 8 = 1.5 -> n = 2 or 1?
#' # This is the `|n - x / y| = 1/2` case
#' # Chosen to be n = 2, i.e. even, by convention.
#' # (12 - 2 * 8) = -4
#' rray_remainder(12, 8)
#'
#' # Broadcasts appropriately
#' x <- matrix(1:5)
#' rray_remainder(x, t(x))
#'
#' # Be aware of the limits of floating
#' # point arithmetic!
#' # 1 / .2 = 5 -> n = 5
#' # (1 - 5 * .2) = 0
#' # I get -5.551115e-17
#' rray_remainder(1, .2)
#'
#' # More serious limitations with rray_fmod()
#' # 1 / .1 = 10 -> n = 10
#' # (1 - 10 * .1) = 0
#' # I get 0.1
#' rray_fmod(1, .1)
#'
#' # ^ is due to the implementation of `std::fmod()`
#' # in C++. It is basically the following, which
#' # gives the incorrect 0.1:
#' x <- 1
#' y <- 0.1
#' x_abs <- abs(x)
#' y_abs <- abs(y)
#' # I get -5.551115e-17
#' result <- rray_remainder(x_abs, y_abs)
#' if (sign(result)) result <- result + y_abs
#' rray_abs(result) * sign(x)
#'
#' @name remainder
#' @family math functions
#' @export
rray_fmod <- function(x, y) {
  rray_math_binary_base("fmod", x, y)
}

#' @rdname remainder
#' @export
rray_remainder <- function(x, y) {
  rray_math_binary_base("remainder", x, y)
}

# ------------------------------------------------------------------------------

#' Fused multiply-add
#'
#' `rray_multiply_add()` computes `x * y + z`, with broadcasting.
#' It is more efficient than simply doing those operations in sequence.
#'
#' @param x,y,z A vector, matrix, array or rray.
#'
#' @examples
#' # 2 * 3 + 5
#' rray_multiply_add(2, 3, 5)
#'
#' # Using broadcasting
#' rray_multiply_add(matrix(1:5), matrix(1:2, nrow = 1L), 3L)
#'
#' # ^ Equivalent to:
#' x <- matrix(rep(1:5, 2), ncol = 2)
#' y <- matrix(rep(1:2, 5), byrow = TRUE, ncol = 2)
#' z <- matrix(3L, nrow = 5, ncol = 2)
#' x * y + z
#'
#' @family math functions
#' @export
rray_multiply_add <- function(x, y, z) {
  rray_math_trinary_base("fma", x, y, z)
}

# ------------------------------------------------------------------------------

rray_math_unary_base <- function(op, x) {
  res <- rray_op_unary_cpp(op, x)
  res <- set_full_dim_names(res, dim_names(x))
  vec_restore(res, x)
}

rray_math_binary_base <- function(op, x, y) {
  rray_arith_base(op, x, y)
}

rray_math_trinary_base <- function(op, x, y, z) {

  # precompute dimensionality and extend existing dims
  # xtensor-r issue #57 until we have a fix (if ever)
  dims <- rray_dims_common(x, y, z)
  x <- rray_dims_match(x, dims)
  y <- rray_dims_match(y, dims)
  z <- rray_dims_match(z, dims)

  # Get common dim_names and type
  dim_nms <- rray_dim_names_common(x, y, z)
  restore_type <- vec_type_common(x, y, z)

  # Apply function
  res <- rray_op_trinary_cpp(op, x, y, z)

  # Add dim names
  dim_names(res) <- dim_nms

  # Restore type
  vec_restore(res, restore_type)
}
