source("latex.r")
library(ggplot2)

l(plyr)
tabulate(ldply(Coord$find_all(), function(c) c(c$objname, c$desc)))



# Grouping vs faceting -------------------------------------------------------

dplot <- ggplot(subset(diamonds, color %in% c("D","E","G","J")), aes(carat, price)) + scale_x_log10() + scale_y_log10() + scale_colour_hue(limits = levels(diamonds$color)) + opts(legend.position = "none")

dplot + geom_point(aes(colour = color))
ggsave(file = "_include/position-fvg-1.pdf", width = 4, height = 4)
dplot + geom_point() + facet_grid(. ~ color)
ggsave(file = "_include/position-fvg-2.pdf", width = 16, height = 4)

dplot + geom_smooth(aes(colour = color), method = lm, se=FALSE)
ggsave(file = "_include/position-fvg-3.pdf", width = 4, height = 4)
dplot + geom_smooth(method = lm, se=FALSE) + facet_grid(. ~ color)
ggsave(file = "_include/position-fvg-4.pdf", width = 16, height = 4)
