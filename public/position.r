
mpg2 <- subset(mpg, cyl != 5 & drv %in% c("4", "f"))

qplot(cty, hwy, data = mpg2) + facet_grid(. ~ .)

qplot(cty, hwy, data = mpg2) + facet_grid(. ~ cyl)

qplot(cty, data = mpg2, geom="histogram", binwidth = 2) +
  facet_grid(cyl ~ .)

qplot(cty, hwy, data = mpg2) + facet_grid(drv ~ cyl)

# Graphical margins work like margins of a contingency table to give
# unconditioned views of the data.  A plot faceted by number of
# cylinders and drive train (left) is supplemented with margins
# (right).
p <- qplot(displ, hwy, data = mpg2) +
  geom_smooth(method = "lm", se = F)
p + facet_grid(cyl ~ drv) 
p + facet_grid(cyl ~ drv, margins = T)

qplot(displ, hwy, data = mpg2) + 
  geom_smooth(aes(colour = drv), method = "lm", se = F) + 
  facet_grid(cyl ~ drv, margins = T) 

# Movie rating distribution by decade.
movies$decade <- round_any(movies$year, 10, floor)
qplot(rating, ..density.., data=subset(movies, decade > 1890),
  geom="histogram", binwidth = 0.5) + 
  facet_wrap(~ decade, ncol = 6)

# Fixed scales (left) have the same scale for each facet, while free
# scales (right) have a different scale for each facet.
p <- qplot(cty, hwy, data = mpg)
p + facet_wrap(~ cyl)
p + facet_wrap(~ cyl, scales = "free")

# Free scales are particularly useful when displaying multiple time
# series measured on different scales.
em <- melt(economics, id = "date")
qplot(date, value, data = em, geom = "line", group = variable) + 
  facet_grid(variable ~ ., scale = "free_y")

# A dotplot showing the range of city gas mileage for each model of
# car. (Left) Models ordered by average mpg, and (right) faceted by
# manufacturer with \code{scales="free_y"} and \code{space = "free"}.
# The {\tt strip.text.y} theme setting has been used to rotate the
# facet labels.
mpg3 <- within(mpg2, {
  model <- reorder(model, cty)
  manufacturer <- reorder(manufacturer, -cty)
})
models <- qplot(cty, model, data = mpg3)

models
models + facet_grid(manufacturer ~ ., scales = "free", 
  space = "free") +  opts(strip.text.y = theme_text())

# The differences between faceting vs. grouping, illustrated with a
# log-log plot of carat vs. price with four selected colours.
xmaj <- c(0.3, 0.5, 1,3, 5)
xmin <- as.vector(outer(1:10, 10^c(-1, 0)))
ymaj <- c(500, 1000, 5000, 10000)
ymin <- as.vector(outer(1:10, 10^c(2,3,4)))
dplot <- ggplot(subset(diamonds, color %in% c("D","E","G","J")), 
  aes(carat, price, colour = color)) + 
  scale_x_log10(breaks = xmaj, labels = xmaj, minor = xmin) + 
  scale_y_log10(breaks = ymaj, labels = ymaj, minor = ymin) + 
  scale_colour_hue(limits = levels(diamonds$color)) + 
  opts(legend.position = "none")

dplot + geom_point()
dplot + geom_point() + facet_grid(. ~ color)

dplot + geom_smooth(method = lm, se = F, fullrange = T)
dplot + geom_smooth(method = lm, se = F, fullrange = T) + 
  facet_grid(. ~ color)

# Dodging (top) vs. faceting (bottom) for a completely crossed pair of
# variables.
qplot(color, data=diamonds, geom = "bar", fill = cut, 
  position="dodge")
qplot(cut, data = diamonds, geom = "bar", fill = cut) + 
  facet_grid(. ~ color) + 
  opts(axis.text.x = theme_text(angle = 90, hjust = 1, size = 8, 
   colour = "grey50"))

# For nested data, there is a clear advantage to faceting (top and
# middle) compared to dodging (bottom), because it is possible to
# carefully control and label the facets.  For this example, the top
# plot is not useful, but it will be useful in situations where the
# data is almost crossed, i.e.\ where a single combination is missing.
mpg4 <- subset(mpg, manufacturer %in% 
  c("audi", "volkswagen", "jeep"))
mpg4$manufacturer <- as.character(mpg4$manufacturer)
mpg4$model <- as.character(mpg4$model)

base <- ggplot(mpg4, aes(fill = model)) + 
  geom_bar(position = "dodge") + 
  opts(legend.position = "none")

base + aes(x = model) + 
  facet_grid(. ~ manufacturer)
  
last_plot() +  
  facet_grid(. ~ manufacturer, scales = "free_x", space = "free")
base + aes(x = manufacturer)

# Three ways of breaking a continuous variable into discrete bins.
# From top to bottom: bins of length one, six bins of equal length, six
# bins containing equal numbers of points.
mpg2$disp_ww <- cut_interval(mpg2$displ, length = 1)
mpg2$disp_wn <- cut_interval(mpg2$displ, n = 6)
mpg2$disp_nn <- cut_number(mpg2$displ, n = 6)

plot <- qplot(cty, hwy, data = mpg2) + labs(x = NULL, y = NULL)
plot + facet_wrap(~ disp_ww, nrow = 1)
plot + facet_wrap(~ disp_wn, nrow = 1)
plot + facet_wrap(~ disp_nn, nrow = 1)

# A set of examples illustrating what a line and rectangle look like
# when displayed in a variety of coordinate systems.  From top left to
# bottom right: Cartesian, polar with x position mapped to angle, polar
# with y position mapped to angle, flipped, transformed with log in y
# direction, and equal scales.
rect <- data.frame(x = 50, y = 50)
line <- data.frame(x = c(1, 200), y = c(100, 1))
base <- ggplot(mapping = aes(x, y)) + 
  geom_tile(data = rect, aes(width = 50, height = 50)) + 
  geom_line(data = line)
base
base + coord_polar("x")
base + coord_polar("y")
base + coord_flip()
base + coord_trans(y = "log10")
base + coord_equal()

# How coordinate transformations work: converting a line in Cartesian
# coordinates to a line in polar coordinates.  The original x position
# is converted to radius, and the y position to angle.
r_grid <- seq(0, 1, length = 15)
theta_grid <- seq(0, 3 / 2 * pi, length = 15)
extents <- data.frame(r = range(r_grid), theta = range(theta_grid))
base <- ggplot(extents, aes(r, theta)) + opts(aspect.ratio = 1) +
  scale_y_continuous(expression(theta))

base + geom_point(colour = "red", size = 4) + geom_line()
pts <- data.frame(r = r_grid, theta = theta_grid)
base + geom_line() + geom_point(data = pts)
base + geom_point(data = pts)

xlab <- scale_x_continuous(expression(x == r * sin(theta)))
ylab <- scale_y_continuous(expression(x == r * cos(theta)))
polar <- base %+% pts + aes(x = r * sin(theta), y = r * cos(theta)) + 
  xlab + ylab
polar + geom_point()
polar + geom_point() + geom_path()
polar + geom_point(data=extents, colour = "red", size = 4) + geom_path() 

# Setting limits on the coordinate system, vs setting limits on the
# scales.  (Left) Entire dataset; (middle) x scale limits set to (325,
# 500); (right) coordinate system x limits set to (325, 500).  Scaling
# the coordinate limits performs a visual zoom, while setting the scale
# limits subsets the data and refits the smooth.
(p <- qplot(disp, wt, data=mtcars) + geom_smooth())
p + scale_x_continuous(limits = c(325, 500))
p + coord_cartesian(xlim = c(325, 500))

# Setting limits on the coordinate system, vs. setting limits on the
# scales.  (Left) Entire dataset; (middle) x scale limits set to (0,
# 2); (right) coordinate x limits set to (0, 2).  Compare the size of
# the bins: when you set the scale limits, there are the same number of
# bins but they each cover a smaller region of the data; when you set
# the coordinate limits, there are fewer bins and they cover the same
# amount of data as the original.
(d <- ggplot(diamonds, aes(carat, price)) + 
  stat_bin2d(bins = 25, colour="grey70") + 
  opts(legend.position = "none")) 
d + scale_x_continuous(limits = c(0, 2))
d + coord_cartesian(xlim = c(0, 2))

# (Left) A scatterplot and smoother with engine displacement on x axis
# and city mpg on y axis.  (Middle) Exchanging \var{cty} and
# \var{displ} rotates the plot 90 degrees, but the smooth is fit to the
# rotated data.  (Right) using \code{coord_flip} fits the smooth to the
# original data, and then rotates the output, this is a smooth curve of
# x conditional on y.
qplot(displ, cty, data = mpg) + geom_smooth()
qplot(cty, displ, data = mpg) + geom_smooth()
qplot(cty, displ, data = mpg) + geom_smooth() + coord_flip()

# (Left) A scatterplot of carat vs. price on log base 10 transformed
# scales.  A linear regression summarises the trend: $\log(y) = a + b *
# \log(x)$.  (Right) The previous plot backtransformed (with {\tt
# coord\_trans(x = "pow10", y = "pow10")}) onto the original scales.
# The linear trend line now becomes geometric, $y = k * c^x$, and
# highlights the lack of expensive diamonds for larger carats.
qplot(carat, price, data = diamonds, log = "xy") + 
  geom_smooth(method = "lm")
last_plot() + coord_trans(x = "pow10", y = "pow10")

# (Left) A stacked bar chart.  (Middle) The stacked bar chart in polar
# coordinates, with x position mapped to radius and y position mapped
# to angle, \code{coord_polar(theta = "y")}).  This is more commonly
# known as a pie chart.  (Right) The stacked bar chart in polar
# coordinates with the opposite mapping, \code{coord_polar(theta =
# "x")}.  This is sometimes called a bullseye chart.
# Stacked barchart
(pie <- ggplot(mtcars, aes(x = factor(1), fill = factor(cyl))) +
  geom_bar(width = 1))
# Pie chart
pie + coord_polar(theta = "y")

# The bullseye chart
pie + coord_polar()
