
plot <- qplot(cty, hwy, data = mpg)
plot

# This doesn't work because there is a mismatch between the
# variable type and the default scale
plot + aes(x = drv)

# Correcting the default manually resolves the problem.
plot + aes(x = drv) + scale_x_discrete()

# Adjusting the default parameters of a scale. (Top left) The plot with
# default scale.  (Top right) Adding the default scale by hand doesn't
# change the appearance of the plot.  (Bottom left) Adjusting the
# parameters of the scale to tweak the legend.  (Bottom right) Using a
# different colour scale: Set1 from the ColorBrewer colours.
p <- qplot(sleep_total, sleep_cycle, data = msleep, colour = vore)
p 
# Explicitly add the default scale
p + scale_colour_hue()

# Adjust parameters of the default, here changing the appearance 
# of the legend
p + scale_colour_hue("What does\nit eat?", 
   breaks = c("herbi", "carni", "omni", NA), 
   labels = c("plants", "meat", "both", "don't know"))

# Use a different scale
p + scale_colour_brewer(pal = "Set1")

# A demonstration of the different forms legend title can take.
p <- qplot(cty, hwy, data = mpg, colour = displ)
p
p + scale_x_continuous("City mpg")
p + xlab("City mpg")
p + ylab("Highway mpg")
p + labs(x = "City mpg", y = "Highway", colour = "Displacement")
p + xlab(expression(frac(miles, gallon)))

# The difference between breaks and limits.  (Left) default plot with
# {\tt limits = c(4, 8), breaks = 4:8}, (middle) {\tt breaks =
# c(5.5,6.5)} and (right) {\tt limits = c(5.5,6.5)}.  The effect on the
# x axis (top) and colour legend (bottom)
p <- qplot(cyl, wt, data = mtcars)
p
p + scale_x_continuous(breaks = c(5.5, 6.5))
p + scale_x_continuous(limits = c(5.5, 6.5))
p <- qplot(wt, cyl, data = mtcars, colour = cyl)
p
p + scale_colour_gradient(breaks = c(5.5, 6.5))
p + scale_colour_gradient(limits = c(5.5, 6.5))

# A scatterplot of diamond price vs.\ carat illustrating the difference
# between log transforming the scale (left) and log transforming the
# data (right).  The plots are identical, but the axis labels are
# different.
qplot(log10(carat), log10(price), data = diamonds)
qplot(carat, price, data = diamonds) + 
  scale_x_log10() + scale_y_log10()

# A time series of personal savings rate.  (Left) The default
# appearance, (middle) breaks every 10 years, and (right) scale
# restricted to 2004, with YMD date format.  Measurements are recorded
# at the end of each month.
plot <- qplot(date, psavert, data = economics, geom = "line") + 
  ylab("Personal savings rate") +
  geom_hline(xintercept = 0, colour = "grey50")
plot
plot + scale_x_date(major = "10 years")
plot + scale_x_date(
  limits = as.Date(c("2004-01-01", "2005-01-01")),
  format = "%Y-%m-%d"
)

# Density of eruptions with three colour schemes.  (Left) Default
# gradient colour scheme, (middle) customised gradient from white to
# black and (right) 3 point gradient with midpoint set to the mean
# density.
f2d <- with(faithful, MASS::kde2d(eruptions, waiting, 
  h = c(1, 10), n = 50))
df <- with(f2d, cbind(expand.grid(x, y), as.vector(z)))
names(df) <- c("eruptions", "waiting", "density")
erupt <- ggplot(df, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_x_continuous(expand = c(0, 0)) + 
  scale_y_continuous(expand = c(0, 0))
erupt + scale_fill_gradient(limits = c(0, 0.04))
erupt + scale_fill_gradient(limits = c(0, 0.04), 
  low = "white", high = "black") 
erupt + scale_fill_gradient2(limits = c(-0.04, 0.04), 
  midpoint = mean(df$density)) 

# Gradient colour scales using perceptually well-formed palettes
# produced by the \code{vcd} package.  From left to right: sequential,
# diverging and heat hcl palettes.  Each scale is produced with
# \code{scale_fill_gradientn} with \code{colours} set to
# \code{rainbow_hcl(7)}, \code{diverge_hcl(7)} and \code{heat_hcl(7)}.
library(vcd)
fill_gradn <- function(pal) {
  scale_fill_gradientn(colours = pal(7), limits = c(0, 0.04))
}
erupt + fill_gradn(rainbow_hcl)
erupt + fill_gradn(diverge_hcl)
erupt + fill_gradn(heat_hcl)

# Three ColorBrewer palettes, Set1 (left), Set2 (middle) and Pastel1
# (right), applied to points (top) and bars (bottom).  Bright colours
# work well for points, but are overwhelming on bars.  Subtle colours
# work well for bars, but are hard to see on points.
point <- qplot(brainwt, bodywt, data = msleep, log = "xy", 
  colour = vore)
area <- qplot(log10(brainwt), data = msleep, fill = vore, 
  binwidth = 1)

point + scale_colour_brewer(pal = "Set1")
point + scale_colour_brewer(pal = "Set2")
point + scale_colour_brewer(pal = "Pastel1")
area + scale_fill_brewer(pal = "Set1")
area + scale_fill_brewer(pal = "Set2")
area + scale_fill_brewer(pal = "Pastel1")

# Scale manual used to create custom colour (left and middle) and shape
# (right) scales.
plot <- qplot(brainwt, bodywt, data = msleep, log = "xy")
plot + aes(colour = vore) + 
  scale_colour_manual(value = c("red", "orange", "yellow", 
    "green", "blue"))
colours <- c(carni = "red", "NA" = "orange", insecti = "yellow", 
  herbi = "green", omni = "blue")
plot + aes(colour = vore) + scale_colour_manual(value = colours)
plot + aes(shape = vore) + 
  scale_shape_manual(value = c(1, 2, 6, 0, 23))

huron <- data.frame(year = 1875:1972, level = LakeHuron)
ggplot(huron, aes(year)) +
  geom_line(aes(y = level - 5), colour = "blue") + 
  geom_line(aes(y = level + 5), colour = "red")

ggplot(huron, aes(year)) +
  geom_line(aes(y = level - 5, colour = "below")) + 
  geom_line(aes(y = level + 5, colour = "above"))

ggplot(huron, aes(year)) +
  geom_line(aes(y = level - 5, colour = "below")) + 
  geom_line(aes(y = level + 5, colour = "above")) + 
  scale_colour_manual("Direction", 
    c("below" = "blue", "above" = "red"))

# A plot of R colours in Luv space.  A legend is unnecessary, because
# the colour of the points represents itself: the data and aesthetic
# spaces are the same.
x <- colors()
luv <- as.data.frame(convertColor(t(col2rgb(x)), "sRGB", "Luv"))
qplot(u, v, data=luv, colour = x, size = I(3)) + scale_colour_identity() +
   coord_equal()

# Legends produced by geom: point, line, point and line, and bar.
p <- ggplot(diamonds[1:100, ], aes(price, carat, colour = cut)) +  
  opts(keep = "legend_box")
p + geom_point()
p + geom_line()
p + geom_point() + geom_line()
p + geom_bar(binwidth = 100) + aes(fill = cut, y = ..count..)

# Colour legend, shape legend, colour + shape legend.
p <- ggplot(diamonds[1:100, ], aes(price, carat)) +  
  geom_point() + 
  opts(keep = "legend_box")
p + aes(colour = cut)
p + aes(shape = cut)
p + aes(shape = cut, colour = cut)
