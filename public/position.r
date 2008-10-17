
mpg2 <- subset(mpg, cyl != 5 & drv %in% c("4", "f"))
qplot(cty, hwy, data = mpg2) + facet_grid(. ~ cyl)

qplot(cty, hwy, data = mpg2) + facet_grid(. ~ cyl)

mpg2 <- subset(mpg, cyl != 5 & drv %in% c("4", "f"))
qplot(cty, data = mpg2, geom="histogram", binwidth = 2) +
  facet_grid(cyl ~ .)

qplot(cty, hwy, data = mpg2) + facet_grid(drv ~ cyl)

qplot(cty, hwy, data = mpg2) + facet_grid( ~ cyl + drv)

p <- qplot(displ, hwy, data=mpg2) + geom_smooth(method="lm")
p + facet_grid(cyl ~ drv) 
p + facet_grid(cyl ~ drv, margins = T)

qplot(displ, hwy, data=mpg2) + geom_smooth(aes(colour = drv), method="lm") + 
  facet_grid(cyl ~ drv, margins = T) 

movies$decade <- round_any(movies$year, 10, floor)
qplot(rating, ..density.., data=subset(movies, decade > 1890),
  geom="histogram", binwidth = 0.5) + facet_wrap(~ decade, ncol = 6)

p <- qplot(cty, hwy, data=mpg) # + geom_abline(slope = 0.72)
p + facet_wrap(~ cyl)
p + facet_wrap(~ cyl, scales = "free")

em <- melt(economics, id = "date")
qplot(date, value, data = em, geom = "line", group = variable) + 
  facet_grid(variable ~ ., scale = "free_y")

mpg2 <- within(mpg2, {
  model <- reorder(model, cty)
  manufacturer <- reorder(manufacturer, -cty)
})


(models <- qplot(cty, model, data = mpg2))
models + facet_grid(manufacturer ~ ., scales="free", space="free") +  
  opts(strip.text.y = theme_text())

(ctyhwy <- qplot(cty, hwy, data=mpg) + facet_grid(. ~ cyl))

# Extract best & worst
extreme <- subset(mpg, cty < 12 | cty > 30)[c("cty", "hwy", "cyl")]

# Show extremes on all facets (remove cyl column)
ctyhwy + geom_point(data=extreme[, 1:2], colour = "red")
# Show extremes for each facet (keep cyl column)
ctyhwy + geom_point(data=extreme, colour = "red")

# Facetting vs grouping.
xmajor <- c(0.1, 0.3, 0.5, 1,3, 5)
xminor <- as.vector(outer(1:10, 10^c(-1, 0)))
ymajor <- c(500, 1000, 5000, 10000)
yminor <- as.vector(outer(1:10, 10^c(2,3,4)))
dplot <- ggplot(subset(diamonds, color %in% c("D","E","G","J")), 
  aes(carat, price, colour = color)) + 
  scale_x_log10(breaks = xmajor, labels = xmajor, minor = xminor) + 
  scale_y_log10(breaks = ymajor, labels = ymajor, minor = yminor) + 
  scale_colour_hue(limits = levels(diamonds$color)) + 
  opts(legend.position = "none")

dplot + geom_point()
dplot + geom_point() + facet_grid(. ~ color)

dplot + geom_smooth(method = lm, se=FALSE)
dplot + geom_smooth(method = lm, se=FALSE) + facet_grid(. ~ color)

# Dodging (top) vs faceting (bottom) for a completely crossed pair of
# variables.
qplot(color, data=diamonds, geom="bar", fill=cut, position="dodge")
qplot(cut,   data=diamonds, geom="bar", fill=cut, position="dodge", 
  facets = . ~ color)

# For nested data, there is a clear advantage to facetting (top and
# middle) compared to dodging (bottom), because it is possible to
# carefully control and label the facets.  For this example, the middle
# plot is not useful, but it will be useful in situations where the
# data is almost crossed, i.e.\ where a single combination is missing.
mpg2 <- subset(mpg, manufacturer %in% c("audi", "volkswagen", "jeep"))
qplot(model, data=mpg2, fill=model, geom="bar") + 
  facet_grid(. ~ manufacturer) + opts(legend.position = "none")
last_plot() + 
  facet_grid(. ~ manufacturer, scales = "free_x", space = "free")
qplot(manufacturer, data=mpg2, fill=model, geom="bar", position="dodge")

mpg$disp_r <- round_any(mpg$displ, 1)
qplot(cty, hwy, data = mpg, facets =  ~ disp_r)

mpg$disp_r <- round_any(rank(mpg$displ), 40, floor)
table(mpg$disp_r)
qplot(cty, hwy, data = mpg, facets =  ~ disp_r)

mpg$disp_r <- chop(mpg$displ, 6)
qplot(cty, hwy, data = mpg, facets =  ~ disp_r)

mpg$disp_r <- chop(mpg$displ, 6, method="cut")
qplot(cty, hwy, data = mpg, facets =  ~ disp_r)

# A set of examples illustrating what a line and rectangle look like
# when displayed in a variety of coordinate systems.
rect <- data.frame(x = 0.5, y = 0.5)
line <- data.frame(x = c(0,1), y = c(1, 0))
base <- ggplot(mapping = aes(x=x,y=y)) + 
  geom_tile(data=rect, aes(width = 0.5, height = 0.5)) + 
  geom_line(data=line)
base

# How coordinate transformations work: converting a line in Cartesian
# coordinates to a line in polar coordinates.
r_grid <- seq(0, 1, length = 15)
theta_grid <- seq(0, 3 / 2 * pi, length = 15)
extents <- data.frame(r = range(r_grid), theta = range(theta_grid))
base <- ggplot(extents, aes(r, theta)) + opts(aspect.ratio = 1) +
  scale_y_continuous(expression(theta))

base + geom_point(colour = "red", size = 2) + geom_line()
pts <- data.frame(r = r_grid, theta = theta_grid)
base + geom_line() + geom_point(data = pts)
base + geom_point(data = pts)

xlab <- scale_x_continuous(expression(x == r * sin(theta)))
ylab <- scale_y_continuous(expression(x == r * cos(theta)))
polar <- base %+% pts + aes(x = r * sin(theta), y = r * cos(theta)) + 
  xlab + ylab
polar + geom_point()
polar + geom_point() + geom_path()
polar + geom_point(data=extents, colour = "red", size = 2) + geom_path() 

# Setting limits on the coordinate system, vs setting limits on the
# scales.  Left, entire dataset; middle, x scale limits set; right,
# coordinate system x limits set.  Scaling the coordinate limits
# performs a visual zoom, while setting the scale limits subsets the
# data and refits the smooth.
(p <- qplot(disp, wt, data=mtcars) + geom_smooth())
p + scale_x_continuous(limits = c(325, 500))
p + coord_cartesian(xlim = c(325, 500))

# Setting limits on the coordinate system, vs setting limits on the
# scales.  Left, entire dataset; middle, scale limits set; right,
# coordinate limits set.  Compare the size of the bins: when you set
# the scale limits, there is the same number of bins but they each
# cover a a smaller region of the data; when you set the coordinate
# limits, there are fewer and they cover the same amount of data as the
# original.
(d <- ggplot(diamonds, aes(carat, price)) + 
  stat_bin2d(bins = 25, colour="grey50") + opts(legend.position = "none")) 
d + scale_x_continuous(limits = c(0, 2))
d + coord_cartesian(xlim = c(0, 2))

qplot(carat, price, data = diamonds, log = "xy") + 
  geom_smooth(method = "lm")
last_plot() + coord_trans(x = "pow10", y = "pow10")
