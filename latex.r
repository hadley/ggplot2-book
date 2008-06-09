
tabulate <- function(x) {
  align <- ifelse(laply(x, is.numeric), "right", "left")
  tbl <- do.call("cbind", mlply(cbind(as.list(x), align), format))
  paste(paste(apply(tbl, 1, paste, collapse = " & "), collapse = "\\\\\n"), "\\\\\n", sep="")
}