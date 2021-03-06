% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transpose.R
\name{rray_transpose}
\alias{rray_transpose}
\alias{t.vctrs_rray}
\title{Transpose an array}
\usage{
rray_transpose(x, permutation = NULL)

\method{t}{vctrs_rray}(x)
}
\arguments{
\item{x}{A vector, matrix, array, or rray.}

\item{permutation}{This should be some permutation of \code{1:n} with \code{n}
being the number of dimensions of \code{x}. If \code{NULL}, the reverse of \code{1:n} is
used, which is the normal transpose.}
}
\description{
\code{rray_transpose()} transposes \code{x} along axes defined by \code{permutation}. By
default, a standard tranpose is performed, which is equivalent to
permuting along the reversed dimensions of \code{x}.
}
\details{
Unlike \code{t()}, using \code{rray_transpose()} on a vector does not transpose it,
as it is a 1D object, and the consistent result of transposing a
1D object is itself.

\code{t.vctrs_rray()} is powered by \code{rray_transpose()}, which means that it also
has this property if you use \code{t(<rray>)} with a 1D rray.

There is an \code{aperm()} method for \code{rray} objects as well. Unlike base R,
it currently does not accept character strings for \code{perm}.
}
\examples{

x <- rray(
 1:6,
 c(3, 2),
 dim_names = list(rows = c("r1", "r2", "r3"), cols = c("c1", "c2"))
)

# A standard transpose
rray_transpose(x)

# Identical to
rray_transpose(x, rev(1:2))

x_3d <- rray_broadcast(x, c(3, 2, 2))

# transpose here is like setting
# `permutation = c(3, 2, 1)`
# so the result should change _shape_ like:
# (3, 2, 2) -> (2, 2, 3)
rray_transpose(x_3d)

# This transposes the "inner" matrices
# (flips the first and second dimension)
# and leaves the 3rd dimension alone
rray_transpose(x_3d, c(2, 1, 3))

# ---------------------------------------------------------------------------
# Difference from base R

# Coerces 1:5 into a 2D matrix, then transposes
t(1:5)

# Leaves it as a 1D array and does nothing
rray_transpose(1:5)

# rray_transpose() powers t.vctrs_rray()
# so you get the same behavior when you
# pass t() an rray
t(rray(1:5))

}
