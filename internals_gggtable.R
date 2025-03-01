# The gggtable() function mimics the behaviour of the ggplot_gtable()
# function (from version 3.3.0.9000). It is a direct copy of the source
# code from the original, with calls to internal ggplot2 functions
# namespaced via :::, and calls to grid and gtable functions namespaced with ::
#
# The only substantive modification from the original is that it maintains
# a list "all_states" that records the state of the gtable at various points in
# the rendering process in addition to the final gtable
#
# Lines that marked with # ****** are those that have been modified or inserted

gggtable <- function(data) {

  `%||%` <- ggplot2:::`%||%` # ******

  plot <- data$plot
  layout <- data$layout
  data <- data$data
  theme <- ggplot2:::plot_theme(plot) # ******

  geom_grobs <- Map(function(l, d) l$draw_geom(d, layout), plot$layers, data)
  plot_table <- layout$render(geom_grobs, data, theme, plot$labels)

  # Record the state after the panel layouts have done their job (I think!)
  all_states <- list()             # ******
  all_states$panels <- plot_table  # ******

  # Legends
  position <- theme$legend.position %||% "right"
  if (length(position) == 2) {
    position <- "manual"
  }

  legend_box <- plot$guides$assemble(theme)
  plot_table <- ggplot2:::table_add_legends(plot_table, legend_box, theme)

  # Record the state of the gtable after the legends have been added
  all_states$legend <- plot_table  # ******


  # Title
  title <- element_render(theme, "plot.title", plot$labels$title, margin_y = TRUE)
  title_height <- grid::grobHeight(title) # ******

  # Subtitle
  subtitle <- element_render(theme, "plot.subtitle", plot$labels$subtitle, margin_y = TRUE)
  subtitle_height <- grid::grobHeight(subtitle) # ******

  # Tag
  tag <- element_render(theme, "plot.tag", plot$labels$tag, margin_y = TRUE, margin_x = TRUE)
  tag_height <- grid::grobHeight(tag) # ******
  tag_width <- grid::grobWidth(tag) # ******

  # whole plot annotation
  caption <- element_render(theme, "plot.caption", plot$labels$caption, margin_y = TRUE)
  caption_height <- grid::grobHeight(caption) # ******

  # positioning of title and subtitle is governed by plot.title.position
  # positioning of caption is governed by plot.caption.position
  #   "panel" means align to the panel(s)
  #   "plot" means align to the entire plot (except margins and tag)
  title_pos <- theme$plot.title.position %||% "panel"
  if (!(title_pos %in% c("panel", "plot"))) {
    abort('plot.title.position should be either "panel" or "plot".')
  }
  caption_pos <- theme$plot.caption.position %||% "panel"
  if (!(caption_pos %in% c("panel", "plot"))) {
    abort('plot.caption.position should be either "panel" or "plot".')
  }

  pans <- plot_table$layout[grepl("^panel", plot_table$layout$name), , drop = FALSE]
  if (title_pos == "panel") {
    title_l = min(pans$l)
    title_r = max(pans$r)
  } else {
    title_l = 1
    title_r = ncol(plot_table)
  }
  if (caption_pos == "panel") {
    caption_l = min(pans$l)
    caption_r = max(pans$r)
  } else {
    caption_l = 1
    caption_r = ncol(plot_table)
  }

  plot_table <- gtable::gtable_add_rows(plot_table, subtitle_height, pos = 0)    # ******
  plot_table <- gtable::gtable_add_grob(plot_table, subtitle, name = "subtitle", # ******
                                        t = 1, b = 1, l = title_l, r = title_r, clip = "off")

  plot_table <- gtable::gtable_add_rows(plot_table, title_height, pos = 0)  # ******
  plot_table <- gtable::gtable_add_grob(plot_table, title, name = "title",  # ******
                                        t = 1, b = 1, l = title_l, r = title_r, clip = "off")

  plot_table <- gtable::gtable_add_rows(plot_table, caption_height, pos = -1)  # ******
  plot_table <- gtable::gtable_add_grob(plot_table, caption, name = "caption", # ******
                                        t = -1, b = -1, l = caption_l, r = caption_r, clip = "off")

  plot_table <- gtable::gtable_add_rows(plot_table, unit(0, 'pt'), pos = 0)  # ******
  plot_table <- gtable::gtable_add_cols(plot_table, unit(0, 'pt'), pos = 0)  # ******
  plot_table <- gtable::gtable_add_rows(plot_table, unit(0, 'pt'), pos = -1) # ******
  plot_table <- gtable::gtable_add_cols(plot_table, unit(0, 'pt'), pos = -1) # ******

  tag_pos <- theme$plot.tag.position %||% "topleft"
  if (length(tag_pos) == 2) tag_pos <- "manual"
  valid_pos <- c("topleft", "top", "topright", "left", "right", "bottomleft",
                 "bottom", "bottomright")

  if (!(tag_pos == "manual" || tag_pos %in% valid_pos)) {
    abort(glue("plot.tag.position should be a coordinate or one of ",
               glue_collapse(valid_pos, ', ', last = " or ")))
  }

  if (tag_pos == "manual") {
    xpos <- theme$plot.tag.position[1]
    ypos <- theme$plot.tag.position[2]
    tag_parent <- justify_grobs(tag, x = xpos, y = ypos,
                                hjust = theme$plot.tag$hjust,
                                vjust = theme$plot.tag$vjust,
                                int_angle = theme$plot.tag$angle,
                                debug = theme$plot.tag$debug)
    plot_table <- gtable_add_grob(plot_table, tag_parent, name = "tag", t = 1,
                                  b = nrow(plot_table), l = 1,
                                  r = ncol(plot_table), clip = "off")
  } else {
    # Widths and heights are reassembled below instead of assigning into them
    # in order to avoid bug in grid 3.2 and below.
    if (tag_pos == "topleft") {
      plot_table$widths <- grid::unit.c(tag_width, plot_table$widths[-1]) # ******
      plot_table$heights <- grid::unit.c(tag_height, plot_table$heights[-1]) # ******
      plot_table <- gtable::gtable_add_grob(plot_table, tag, name = "tag", # ******
                                            t = 1, l = 1, clip = "off")
    } else if (tag_pos == "top") {
      plot_table$heights <- grid::unit.c(tag_height, plot_table$heights[-1]) # ******
      plot_table <- gtable::gtable_add_grob(plot_table, tag, name = "tag", # ******
                                            t = 1, l = 1, r = ncol(plot_table),
                                            clip = "off")
    } else if (tag_pos == "topright") {
      plot_table$widths <- grid::unit.c(plot_table$widths[-ncol(plot_table)], tag_width) # ******
      plot_table$heights <- grid::unit.c(tag_height, plot_table$heights[-1]) # ******
      plot_table <- gtable::gtable_add_grob(plot_table, tag, name = "tag", # ******
                                            t = 1, l = ncol(plot_table), clip = "off")
    } else if (tag_pos == "left") {
      plot_table$widths <- grid::unit.c(tag_width, plot_table$widths[-1]) # ******
      plot_table <- gtable::gtable_add_grob(plot_table, tag, name = "tag", # ******
                                            t = 1, b = nrow(plot_table), l = 1,
                                            clip = "off")
    } else if (tag_pos == "right") {
      plot_table$widths <- grid::unit.c(plot_table$widths[-ncol(plot_table)], tag_width) # ******
      plot_table <- gtable::gtable_add_grob(plot_table, tag, name = "tag", # ******
                                            t = 1, b = nrow(plot_table), l = ncol(plot_table),
                                            clip = "off")
    } else if (tag_pos == "bottomleft") {
      plot_table$widths <- grid::unit.c(tag_width, plot_table$widths[-1]) # ******
      plot_table$heights <- grid::unit.c(plot_table$heights[-nrow(plot_table)], tag_height) # ******
      plot_table <- gtable::gtable_add_grob(plot_table, tag, name = "tag", # ******
                                            t = nrow(plot_table), l = 1, clip = "off")
    } else if (tag_pos == "bottom") {
      plot_table$heights <- grid::unit.c(plot_table$heights[-nrow(plot_table)], tag_height) # ******
      plot_table <- gtable::gtable_add_grob(plot_table, tag, name = "tag", # ******
                                            t = nrow(plot_table), l = 1, r = ncol(plot_table), clip = "off")
    } else if (tag_pos == "bottomright") {
      plot_table$widths <- grid::unit.c(plot_table$widths[-ncol(plot_table)], tag_width) # ******
      plot_table$heights <- grid::unit.c(plot_table$heights[-nrow(plot_table)], tag_height) # ******
      plot_table <- gtable::gtable_add_grob(plot_table, tag, name = "tag", # ******
                                            t = nrow(plot_table), l = ncol(plot_table), clip = "off")
    }
  }

  # Margins
  plot_table <- gtable::gtable_add_rows(plot_table, theme$plot.margin[1], pos = 0) # ******
  plot_table <- gtable::gtable_add_cols(plot_table, theme$plot.margin[2]) # ******
  plot_table <- gtable::gtable_add_rows(plot_table, theme$plot.margin[3]) # ******
  plot_table <- gtable::gtable_add_cols(plot_table, theme$plot.margin[4], pos = 0) # ******

  if (inherits(theme$plot.background, "element")) {
    plot_table <- gtable::gtable_add_grob(plot_table, # ******
                                          element_render(theme, "plot.background"),
                                          t = 1, l = 1, b = -1, r = -1, name = "background", z = -Inf)
    plot_table$layout <- plot_table$layout[c(nrow(plot_table$layout), 1:(nrow(plot_table$layout) - 1)),]
    plot_table$grobs <- plot_table$grobs[c(nrow(plot_table$layout), 1:(nrow(plot_table$layout) - 1))]
  }


  # Record the final state of the gtable
  all_states$final <- plot_table  # ******
  return(all_states)              # ******
}
