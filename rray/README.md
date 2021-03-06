
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rray

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/DavisVaughan/rray.svg?branch=master)](https://travis-ci.org/DavisVaughan/rray)
[![Codecov test
coverage](https://codecov.io/gh/DavisVaughan/rray/branch/master/graph/badge.svg)](https://codecov.io/gh/DavisVaughan/rray?branch=master)
<!-- badges: end -->

## Introduction

rray has three goals:

1)  To provide an rray class that implements stricter matrices and
    arrays than base R, similar in spirit to the tibble package.
    `vignette("the-rray", package = "rray")`.

2)  To support *broadcasting* semantics throughout the package, allowing
    for more flexible and intuitive array operations than are possible
    with base R. `vignette("broadcasting", package = "rray")`.

3)  To provide a consistent, powerful toolkit for array based
    manipulation. (WIP, but see the [function
    reference](https://davisvaughan.github.io/rray/reference/index.html)
    for current functionality)

View the vignette for each goal to learn more about how to use rray.

## Installation

You can install from Github with:

``` r
devtools::install_github("DavisVaughan/rray")
```

## Acknowledgements

rray would not be possible without the underlying C++ library,
[`xtensor`](https://github.com/QuantStack/xtensor). Additionally, rray
uses a large amount of the new infrastructure in
[`vctrs`](https://github.com/r-lib/vctrs) to be as consistent and type
stable as possible.

## Alternatives

The Matrix package implements a small subset of column-wise broadcasting
operations. rray fully supports broadcasting in all operations.

The original motivation for this package, and even for `xtensor`, is the
excellent Python library, `numpy`. As far as I know, it has the original
implementation of broadcasting, and is a core library that a huge number
of others are built on top of.
