# weave
# graphic
# 

save_plot_tex <- function(
  x, outdir, 
  cache = FALSE,
  gg_width = NULL, gg_height = NULL, 
  tex_width = NULL, tex_height = NULL, ...
) {
  if (!inherits(x, "ggplot")) return()
  
  path <- file.path(outdir, ps(digest.ggplot(x), ".pdf"))
  
  if (!cache || !file.exists(path)) {
    ggsave(x, filename = path, width = gg_width, height = gg_height)      
  }
  
  ps(indent(image_tex(path, width=tex_width, height=tex_height)), "%")
}

weave_nul <- list(
  start = nul, stop  = nul,
  message = nul, warning = nul, error = nul,
  out = nul, value = nul, src = nul
)

weave_graphics <- weave_nul
weave_graphics$value <- save_plot_tex

# \begin{figure}[htbp]
#   \centering
#     \includegraphics[scale=1]{file}
#   \caption{caption}
#   \label{fig:label}
# \end{figure}
weave_figure <- weave_graphics
weave_figure$start <- function(position = "htbp", ...) {
  ps(
    "\\begin{figure}[", position, "]\n",
    "\\centering\n"
  )
}
weave_figure$stop <- function(caption, label, ...) {
  ps("\n", indent(ps(
    "\\label{fig:", label, "}\n",
    "\\caption{", caption, "}"
  )), "\n\\end{figure}\n")
}

weave_all <- weave_graphics
weave_all$out <- function(x, ...) escape_tex(x)
weave_all$src <- function(x, ...) escape_tex(line_prompt(x))

# Include graphics in a latex file
# Given a list of files, this function prints the latex code necessary (ie. includegraphics) to include in the file.
# 
# Note: this function needs to be made generic so that
# it automatically uses the appropriate input text for the
# file type being written to.
# 
# @arguments path to graphics files
# @arguments latex scale option
# @arguments latex height option
# @arguments latex width option
# @keyword documentation 
image_tex <- function(path, width=NULL, height=NULL, ...) {
  options <- compact(list(width = width, height = height))
  options_str <- paste(names(options), options, sep="=", collapse=", ")
	options_str <- paste("[", options_str, "]", sep="")
	
	paste("\\includegraphics", options_str, "{", strip_extension(path), "}", sep="")
}