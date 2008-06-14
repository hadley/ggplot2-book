weave_graphics <- list(
  start = nul,
  stop  = nul,
  message = nul,
  warning = nul ,
  error = nul,
  out = nul,
  value = function(x, path, width, height) {
    if (!inherits(x, "ggplot")) return()
    
    path <- file.path(path, ps(digest.ggplot(p), ".pdf"))
    ggsave(x, path, width, height)
    
    print(x)
  },
  src = nul
)

