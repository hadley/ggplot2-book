l(eval.with.details)
source("weaves.r")
source("parser.r")

library(digest)

.defaults <- list(
  outdir = "_include",
  inline = FALSE,
  cache = FALSE
)


group_output <- function(group) {
  if (is.block(group)[1]) {
    block_output(parse_block(group))
  } else {
    ps(group, collapse="\n")
  }
}

block_call <- function(block) {
  params <- c(list(code = block$code), block$params)
  params <- reshape::defaults(params, .defaults)
  
  res <- do.call(block$type, params)
  if (params$inline) return(indent(res, block$indent))
  
  outdir <- params$outdir
  if (!file.exists(outdir)) dir.create(outdir, recursive = TRUE)
  path <- file.path(outdir, ps(digest(res), ".tex"))
  cat(res, file = path)
  indent(ps("\\input{", path, "}"), block$indent)
}

block_output <- function(block) {
  input <- ps(block$input, collapse = "\n")
  output <- block_call(block)
  end <- indent("\n% END", block$indent)
  
  ps(input, "\n", output, end)
}

listing <- function(code, ...) {
  highlight_latex(code)
}

raw <- function(code, ...) {
}

set_defaults <- function(code, ...) {
  .defaults <<- list(...)
}

interweave <- function(code, ...) {
  woven <- weave(code, parent.frame())  
  paste(weave_out(woven, weave_all, ...), collapse="\n")
}

graphic <- function(code, ...) {
  woven <- weave(code, parent.frame())  
  paste(weave_out(woven, weave_graphics, ...), collapse="\n")
}
figure <- function(code, ...) {
  woven <- weave(code, parent.frame())  
  paste(weave_out(woven, weave_figure, ...), collapse="\n")
}