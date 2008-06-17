source("weaves.r")
source("parser.r")
l(eval.with.details)

library(digest)

.defaults <- list(
  outdir = "_include",
  include = FALSE,
  cache = FALSE
)


blockcall <- function(block) {
  params <- c(list(code = block$code), block$params)
  params <- reshape::defaults(params, .defaults)
  
  res <- do.call(block$type, params)
  if (!params$include) return(res)
  
  outdir <- params$outdir
  if (!file.exists(outdir)) dir.create(outdir, recursive = TRUE)
  path <- file.path(outdir, ps(digest(res), ".tex"))
  cat(res, file = path)
  ps("\\include{", path, "}")
}

listing <- function(code, ...) {
  highlight_latex(code)
}

raw <- function(code, ...) {
  code
}

output <- function(code, ...) {
  escape_tex(code)
}

set_defaults <- function(code, ...) {
  .defaults <<- list(...)
}

graphic <- function(code, ...) {
  woven <- weave(code, parent.frame())  
  paste(weave_out(woven, weave_graphics, ...), collapse="\n")
}
figure <- function(code, ...) {
  woven <- weave(code, parent.frame())  
  paste(weave_out(woven, weave_figure, ...), collapse="\n")
}