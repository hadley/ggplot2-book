library(ggplot2)
library(dplyr)
conflicted::conflict_prefer("filter", "dplyr")
conflicted::conflict_prefer("pull", "dplyr") # in case git2r is loaded
library(tidyr)
conflicted::conflict_prefer("extract", "tidyr")

options(digits = 3, dplyr.print_min = 6, dplyr.print_max = 6)

# suppress startup message
library(maps)

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  fig.show = "hold",
  dpi = 300,
  cache = TRUE
)

is_latex <- function() {
  identical(knitr::opts_knit$get("rmarkdown.pandoc.to"), "latex")
}

columns <- function(n, aspect_ratio = 1, max_width = if (n == 1) 0.65 else 1) {
  if (is_latex()) {
    out_width <- paste0(round(max_width / n, 3), "\\linewidth")
    knitr::knit_hooks$set(plot = plot_hook_bookdown)
  } else {
    out_width <- paste0(round(max_width * 100 / n, 1), "%")
  }

  width <- 6 / n * max_width

  knitr::opts_chunk$set(
    fig.width = width,
    fig.height = width * aspect_ratio,
    fig.align = if (max_width < 1) "center" else "default",
    fig.show = if (n == 1) "asis" else "hold",
    fig.retina = NULL,
    out.width = out_width,
    out.extra = if (!is_latex())
      paste0("style='max-width: ", round(width, 2), "in'")
  )
}

# Draw parts of plots -----------------------------------------------------

draw_legends <- function(...) {
  plots <- list(...)
  gtables <- lapply(plots, function(x) ggplot_gtable(ggplot_build(x)))
  guides <- lapply(gtables, gtable::gtable_filter, "guide-box")

  one <- Reduce(function(x, y) cbind(x, y, size = "first"), guides)

  grid::grid.newpage()
  grid::grid.draw(one)
}


# Customised plot layout --------------------------------------------------

plot_hook_bookdown <- function(x, options) {
  paste0(
    begin_figure(x, options),
    include_graphics(x, options),
    end_figure(x, options)
  )
}

begin_figure <- function(x, options) {
  if (!knitr_first_plot(options))
    return("")

  paste0(
    "\\begin{figure}[H]\n",
    if (options$fig.align == "center") "  \\centering\n"
  )
}
end_figure <- function(x, options) {
  if (!knitr_last_plot(options))
    return("")

  paste0(
    if (!is.null(options$fig.cap)) {
      paste0(
        '  \\caption{', options$fig.cap, '}\n',
        '  \\label{fig:', options$label, '}\n'
      )
    },
    "\\end{figure}\n"
  )
}
include_graphics <- function(x, options) {
  opts <- c(
    sprintf('width=%s', options$out.width),
    sprintf('height=%s', options$out.height),
    options$out.extra
  )
  if (length(opts) > 0) {
    opts_str <- paste0("[", paste(opts, collapse = ", "), "]")
  } else {
    opts_str <- ""
  }

  paste0("  \\includegraphics",
         opts_str,
         "{", tools::file_path_sans_ext(x), "}",
         if (options$fig.cur != options$fig.num) "%",
         "\n"
  )
}

knitr_first_plot <- function(x) {
  x$fig.show != "hold" || x$fig.cur == 1L
}
knitr_last_plot <- function(x) {
  x$fig.show != "hold" || x$fig.cur == x$fig.num
}


# control output lines ----------------------------------------------------

hook_output <- knitr::knit_hooks$get("output")
knitr::knit_hooks$set(output = function(x, options) {
  lines <- options$output.lines
  if (is.null(lines)) {
    return(hook_output(x, options))  # pass to default hook
  }

  x <- unlist(strsplit(x, "\n"))

  if (length(lines)==1) {        # first n lines
    if (length(x) > lines) {
      # truncate the output, but add ....
      x <- c(head(x, lines), more)
    }
  } else {
    x <- x[lines] # don't add ... when we get vector input
  }
  # paste these lines together
  x <- paste(c(x, ""), collapse = "\n")
  hook_output(x, options)
})

