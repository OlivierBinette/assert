# :eyes: assert

[![Build Status](https://travis-ci.org/OlivierBinette/assert.svg?branch=master)](https://travis-ci.org/OlivierBinette/assert)

**assert** provides a replacement to `stopifnot` and `assertthat::assert_that` which provides more informative error traces for debugging purposes. 

```r
assert(is.numeric(a))
# Error in assert(is.numeric(a)) : 
# Failed checks: 
#	  is.numeric(a)	(object 'a' not found)
```

The simple `assert` function is most useful when validating function arguments: error messages contain the function call with named arguments. The failed checks expressions are also printed together with the reason for the error.

```r
sum <- function(a, b) {
  assert(is.numeric(a),
         is.numeric(b),
         length(a) == length(b))
  a + b
}

sum(1, "2")
# Error: in sum(a = 1, b = "2")
# Failed checks: 
#	  is.numeric(b)

sum(1, c(1,2))
# Error: in sum(a = 1, b = c(1, 2))
# Failed checks: 
#	  length(a) == length(b)

```

## Installation

Install from github:

```r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("OlivierBinette/assert")
```
