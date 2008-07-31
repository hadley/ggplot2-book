hcl <- expand.grid(h = seq(0, 360, by = 2), l = 50, c = seq(0, 100, by = 2))
hcl <- transform(hcl, 
  angle = h * pi / 180,
  radius = c / diff(range(c))
)
hcl <- transform(hcl,
  x = radius * sin(angle),
  y = radius * cos(angle)
)
hcl$colour <- hcl(hcl$h, hcl$c, hcl$l)

with(hcl, plot(x, y, col=colour, pch=20, cex=3))
# print(qplot(x, y, data=hcl, colour=colour) + scale_colour_identity())