hcl <- expand.grid(x = seq(-1, 1, length = 100), y = seq(-1, 1, length=100))
hcl <- subset(hcl, x^2 + y^2 < 1)
hcl <- within(hcl, {
  r <- sqrt(x^2 + y^2)
  c <- 100 * r
  h <- 180 / pi * atan2(x, y)
  l <- 65
})
hcl$colour <- hcl(hcl$h, hcl$c, hcl$l)
rgb_vals <- expand.grid(r = seq(0, 1, length = 10), g = seq(0, 1, length=10), b = 0.5)
rgb_vals$colour <- do.call(rgb, rgb_vals)

# how to get the 'selected' data for this plot?
# qplot(x, y, data=hcl, colour=colour) + scale_colour_identity() + coord_equal() + scale_x_continuous("", breaks=NA) + scale_y_continuous("", breaks=NA) + geom_point(aes(colour = NULL), selected, size = 5, shape = 1)

# doesn't quite give me what I want...
# selected <- subset(hcl, colour %in% hue_pal()(5))