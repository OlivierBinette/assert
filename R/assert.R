#' Validate function arguments
#'
#' Assert that each of the provided expression is true. Otherwise stop execution and
#' return a description of each failed assertion.
#'
#' @param ... List of logical assertions
#' @param msg Nothing if all assertions pass. Otherwise throws an error describing which
#'   assertions failed.
#' @param on_fail Function to use to stop excution. Should be set to base::stop or
#'   base::warning
#'
#' @return Nothing if all assertions pass. Otherwise throws an error describing which
#   assertions failed.
#'
#' @examples
#' \dontrun{
#' assert(2 < 1, 1 == 1, "1" == 2)
#'
#' sum <- function(a, b) {
#'   assert(is.numeric(a),
#'          is.numeric(b),
#'          length(a) == length(b))
#'   return(a+b)
#' }
#' sum("1", 2)
#' }
#'
#' @export
assert <- function(...,
                   msg="",
                   on_fail=base::stop) {
  q = rlang::quos(...)
  errs = as.character(lapply(q, function(expr) {
    res = tryCatch(suppressWarnings(rlang::eval_tidy(expr)),
             error=function(e) e$message)
  }))
  r = sapply(errs, function(x) x != TRUE)

  if (any(r)) {
    fails = paste0(substitute(c(...)))[-1][r]
    msg = c("Failed checks: \n\t",
            paste0(fails, ifelse(errs[r] =="FALSE",
                                 "",
                                 paste0("\t(",errs[r],")")),
                   "\n\t"),
            "\n", msg)
    if(identical(parent.frame(), globalenv())) {
      on_fail(c("\n",msg))
    } else {
      msg = c("in ",
              eval(quote(match.call()), parent.frame()),
              "\n",
              msg)
      on_fail(msg, call. = FALSE)
    }
  }
}

assert(1 > 2)
