library(ggplot2)

source("latex.r")
describe(Coord)
describe(Position)

# Position adjustment --------------------------------------------------------

dplot <- ggplot(diamonds, aes(clarity, fill = cut))
dplot + geom_bar(position = "identity")
ggsave(file = "_include/position-identity.pdf", width = 6, height = 3)
dplot + geom_bar(position = "stack")
ggsave(file = "_include/position-stack.pdf", width = 6, height = 3)
dplot + geom_bar(position = "fill")
ggsave(file = "_include/position-fill.pdf", width = 6, height = 3)
dplot + geom_bar(position = "dodge")
ggsave(file = "_include/position-dodge.pdf", width = 6, height = 3)
qplot(clarity, data = diamonds, geom="line", colour = cut, stat="bin", group=cut)
ggsave(file = "_include/position-identity2.pdf", width = 6, height = 3)


# Grouping vs facetting -------------------------------------------------------

dplot <- ggplot(subset(diamonds, color %in% c("D","E","G","J")), aes(carat, price)) + scale_x_log10() + scale_y_log10() + scale_colour_hue(limits = levels(diamonds$color)) + opts(legend.position = "none")

dplot + geom_point(aes(colour = color))
ggsave(file = "_include/position-fvg-1.pdf", width = 4, height = 4)
dplot + geom_point() + facet_grid(. ~ color)
ggsave(file = "_include/position-fvg-2.pdf", width = 16, height = 4)

dplot + geom_smooth(aes(colour = color), method = lm, se=FALSE)
ggsave(file = "_include/position-fvg-3.pdf", width = 4, height = 4)
dplot + geom_smooth(method = lm, se=FALSE) + facet_grid(. ~ color)
ggsave(file = "_include/position-fvg-4.pdf", width = 16, height = 4)
