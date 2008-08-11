hcl <- expand.grid(x = seq(-1, 1, length = 100), y = seq(-1, 1, length=100))
hcl <- subset(hcl, x^2 + y^2 < 1)

hcl <- within(hcl, {
  r <- sqrt(x^2 + y^2)
  
  c <- 100 * r
  h <- 180 / pi * atan2(x, y)
  l <- 65
})

hcl$colour <- hcl(hcl$h, hcl$c, hcl$l)

angles <- seq(0, 2*pi, length = 6)[-6]
selected <- data.frame(x = sin(angles), y = cos(angles))

# with(hcl, plot(x, y, col=colour, pch=20, cex=3))
# with(selected, points(x, y, cex = 3))

qplot(x, y, data=hcl, colour=colour) + scale_colour_identity() + coord_equal() + scale_x_continuous("", breaks=NA) + scale_y_continuous("", breaks=NA) + geom_point(aes(colour = NULL), selected, size = 5, shape = 1)
ggsave(file = "colour-wheel.pdf", width = 6, height = 6)