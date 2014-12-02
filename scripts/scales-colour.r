cols <- expand.grid(
  x = seq(-1, 1, length = 100), 
  y = seq(-1, 1, length = 100),
  l = seq(5, 95, by= 5)
)
cols <- within(cols, {
  r <- sqrt(x^2 + y^2)
  
  c <- 100 * r
  h <- 180 / pi * atan2(x, y)
})

cols <- subset(cols, r <= 1)

cols$colour <- with(cols, hcl(h, c, l, fixup = FALSE))
valid <- subset(cols, !is.na(colour))

qplot(x, y, data=valid, facets = ~ l, colour = colour) + scale_colour_identity() + scale_x_continuous("", breaks=NA) + scale_y_continuous("", breaks=NA) + opts(aspect.ratio = 1)
