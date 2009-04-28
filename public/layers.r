
p <- ggplot(diamonds, aes(carat, price, colour = cut))

p <- p + layer(geom = "point")  

layer(geom, geom_params, stat, stat_params, data, mapping, 
  position)

p <- ggplot(diamonds, aes(x = carat))
p <- p + layer(
  geom = "bar", 
  geom_params = list(fill = "steelblue"),
  stat = "bin",
  stat_params = list(binwidth = 2)
)
p

geom_histogram(binwidth = 2, fill = "steelblue")

geom_XXX(mapping, data, ..., geom, position)
stat_XXX(mapping, data, ..., stat, position)

ggplot(msleep, aes(sleep_rem / sleep_total, awake)) + 
  geom_point()
# which is equivalent to
qplot(sleep_rem / sleep_total, awake, data = msleep)

# You can add layers to qplot too:
qplot(sleep_rem / sleep_total, awake, data = msleep) + 
  geom_smooth()
# This is equivalent to 
qplot(sleep_rem / sleep_total, awake, data = msleep, 
  geom = c("point", "smooth"))
# or
ggplot(msleep, aes(sleep_rem / sleep_total, awake)) + 
  geom_point() + geom_smooth()

p <- ggplot(msleep, aes(sleep_rem / sleep_total, awake))
summary(p)

p <- p + geom_point()
summary(p)

bestfit <- geom_smooth(method = "lm", se = F, 
  colour = alpha("steelblue", 0.5), size = 2)
qplot(sleep_rem, sleep_total, data = msleep) + bestfit
qplot(awake, brainwt, data = msleep, log = "y") + bestfit
qplot(bodywt, brainwt, data = msleep, log = "xy") + bestfit

p <- ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point()
p
mtcars <- transform(mtcars, mpg = mpg ^ 2)
p %+% mtcars

aes(x = weight, y = height, colour = age)

aes(weight, height, colour = sqrt(age))

p <- ggplot(mtcars)
summary(p)

p <- p + aes(wt, hp)
summary(p)

p <- ggplot(mtcars, aes(x = mpg, y = wt))
p + geom_point()

# Overriding aesthetics.  (Left) Overriding colour with {\tt
# factor(cyl)} and (right) overriding y-position with {\tt disp}
p + geom_point(aes(colour = factor(cyl)))
p + geom_point(aes(y = disp))

p <- ggplot(mtcars, aes(mpg, wt))
p + geom_point(colour = "darkblue")  

p + geom_point(aes(colour = "darkblue"))

# The difference between (left) setting colour to \code{"darkblue"} and
# (right) mapping colour to \code{"darkblue"}.  When \code{"darkblue"}
# is mapped to colour, it is treated as a regular value and scaled with
# the default colour scale.  This results in pinkish points and a
# legend.
qplot(mpg, wt, data=mtcars, colour = I("darkblue"))
qplot(mpg, wt, data=mtcars, colour = "darkblue")

p <- ggplot(Oxboys, aes(age, height, group = Subject)) + 
  geom_line()

# (Left) Correctly specifying {\tt group = Subject} produces one line
# per subject.  (Right) A single line connects all observations.  This
# pattern is characteristic of an incorrect grouping aesthetic, and is
# what we see if the group aesthetic is omitted, which in this case is
# equivalent to {\tt group = 1}.
data(Oxboys, package="nlme")
qplot(age, height, data=Oxboys, group = Subject, geom="line")
qplot(age, height, data=Oxboys, geom="line")

p + geom_smooth(aes(group = Subject), method="lm", se = F)

p + geom_smooth(aes(group = 1), method="lm", size = 2, se = F)

# Adding smooths to the Oxboys data.  (Left) Using the same grouping as
# the lines results in a line of best fit for each boy.  (Right) Using
# {\tt aes(group = 1)} in the smooth layer fits a single line of best
# fit across all boys.
qplot(age, height, data=Oxboys, group = Subject, geom="line") +
  geom_smooth(method="lm", se = F)
qplot(age, height, data=Oxboys, group = Subject, geom="line") +
  geom_smooth(aes(group = 1), method="lm", size = 2, se = F)

boysbox <- ggplot(Oxboys, aes(Occasion, height)) + geom_boxplot()

boysbox + geom_line(aes(group = Subject), colour = "#3366FF")

# (Left) If boxplots are used to look at the distribution of heights at
# each occasion (a discrete variable), the default grouping works
# correctly.  (Right) If trajectories of individual boys are overlaid
# with {\tt geom\_line()}, then {\tt aes(group = Subject)} is needed
# for the new layer.
qplot(Occasion, height, data=Oxboys, geom="boxplot")
qplot(Occasion, height, data=Oxboys, geom="boxplot") +
 geom_line(aes(group = Subject), colour="#3366FF")

# For lines and paths, the aesthetics of the line segment are
# determined by the aesthetic of the beginning observation.  If colour
# is categorical (left) there is no meaningful way to interpolate
# between adjacent colours.  If colour is continuous (right), there is,
# but this is not done by default.
df <- data.frame(x = 1:3, y = 1:3, colour = c(1,3,5))
qplot(x, y, data=df, colour=factor(colour), size = I(5)) + 
  geom_line(aes(group = 1), size = 2)
qplot(x, y, data=df, colour=colour, size = I(5)) + geom_line(size = 2)

xgrid <- with(df, seq(min(x), max(x), length = 50))
interp <- data.frame(
  x = xgrid,
  y = approx(df$x, df$y, xout = xgrid)$y,
  colour = approx(df$x, df$colour, xout = xgrid)$y  
)
qplot(x, y, data = df, colour = colour, size = I(5)) + 
  geom_line(data = interp, size = 2)

# Splitting apart a bar chart (left) produces a plot (right) that has
# the same outline as the original.
qplot(color, data = diamonds)
qplot(color, data = diamonds, fill = cut)

ggplot(diamonds, aes(carat)) + 
  geom_histogram(aes(y = ..density..), binwidth = 0.1)

qplot(carat, ..density.., data = diamonds, geom="histogram", 
  binwidth = 0.1)

# Three position adjustments applied to a bar chart.  From left to
# right, stacking, filling and dodging.
dplot <- ggplot(diamonds, aes(clarity, fill = cut))
dplot + geom_bar(position = "stack")
dplot + geom_bar(position = "fill")
dplot + geom_bar(position = "dodge")

# The identity positon adjustment is not useful for bars, (left)
# because each bar obscures the bars behind.  (Right) It is useful for
# lines, however, because lines do not have the same problem.
dplot + geom_bar(position = "identity")
qplot(clarity, data = diamonds, geom="line", colour = cut, 
  stat="bin", group=cut)

d <- ggplot(diamonds, aes(carat)) + xlim(0, 3)
d + stat_bin(aes(ymax = ..count..), binwidth = 0.1, geom = "area")
d + stat_bin(
  aes(size = ..density..), binwidth = 0.1, 
  geom = "point", position="identity"
)
d + stat_bin(
  aes(y = 1, fill = ..count..), binwidth = 0.1, 
  geom = "tile", position="identity"
)

# Three variations on the histogram. (Left) A frequency polygon;
# (middle) a scatterplot with both size and height mapped to frequency;
# (right) a heatmap representing frequency with colour.
d <- ggplot(diamonds, aes(carat)) + xlim(0, 3)
d + stat_bin(aes(ymax = ..count..), binwidth = 0.1, geom = "area")
d + stat_bin(aes(size = ..density..), binwidth = 0.1, geom = "point", position="identity")
d + stat_bin(aes(y=1, fill = ..count..), binwidth = 0.1, geom = "tile", position="identity") + scale_y_continuous("")

require(nlme, quiet = TRUE, warn.conflicts = FALSE)
model <- lme(height ~ age, data = Oxboys, 
 random = ~ 1 + age | Subject)
oplot <- ggplot(Oxboys, aes(age, height, group = Subject)) + 
  geom_line()

age_grid <- seq(-1, 1, length = 10)
subjects <- unique(Oxboys$Subject)

preds <- expand.grid(age = age_grid, Subject = subjects)
preds$height <- predict(model, preds)

oplot + geom_line(data = preds, colour = "#3366FF", size= 0.4)

Oxboys$fitted <- predict(model)
Oxboys$resid <- with(Oxboys, fitted - height)

oplot %+% Oxboys + aes(y = resid) + geom_smooth(aes(group=1))

model2 <- update(model, height ~ age + I(age ^ 2))
Oxboys$fitted2 <- predict(model2)
Oxboys$resid2 <- with(Oxboys, fitted2 - height)

oplot %+% Oxboys + aes(y = resid2) + geom_smooth(aes(group=1))
