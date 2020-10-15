#' Assertions and Argument Validation
#'
#' Assert that each of the provided expression is true. Otherwise stop execution and
#' return a description of each failed assertion.
#'
#' @param ... List of logical assertions.
#' @param msg Message to print alongside the list of failed assertions (if any).
#' @param stop Whether execution should be stopped on failed assertions. If set to FALSE, then only a warning is issued. Default is TRUE.
#'
#' @return Nothing if all assertions pass. Otherwise throws an error describing which
#   assertions failed.
#'
#' @examples
#'
#' attach(ChickWeight)
#'
#' # Passing assertions
#' assert(is.numeric(weight),
#'        all(weight > 0))
#'
#' # Failing assertions
#' if (interactive()) {
#'   assert(all(Diet > 0),
#'          is.numeric(Times))
#' }
#'
#' # Validating function arguments
#' sum <- function(a, b) {
#'   assert(is.numeric(a),
#'          is.numeric(b),
#'          length(a) == length(b))
#'
#'   return(a+b)
#' }
#'
#' sum(2, 2)
#'
#' if (interactive()) {
#'   sum("1", 2)
#'   sum(1, c(1,2))
#'   sum(1, x)
#' }
#'
#' @export
assert <- function(...,
                   msg="",
                   stop=TRUE) {
  if (stop) {
    on_fail = base::stop
  } else {
    on_fail = base::warning
  }

  q <- rlang::quos(...)
  errs <- as.character(lapply(q, function(expr) {
    res <- tryCatch(suppressWarnings(rlang::eval_tidy(expr)==TRUE),
             error=function(e) e$message)
  }))
  r <- sapply(errs, function(x) x != TRUE)

  if (any(r)) {
    fails <- paste0(substitute(c(...)))[-1][r]
    msg <- c("Failed checks: \n\t",
              paste0(fails, ifelse(errs[r] == "FALSE",
                                   "",
                                   paste0("\t(",errs[r],")")),
                     "\n\t"),
              "\n", msg)
    if(identical(parent.frame(), globalenv())) {
      on_fail(c("\n",msg))
    } else {
      msg <- c("in ",
              eval(quote(match.call()), parent.frame()),
              "\n",
              msg)
      on_fail(msg, call. = FALSE)
    }
  }
}
