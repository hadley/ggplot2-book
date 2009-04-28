
# The effect of changing themes.  (Left) The default grey theme with
# grey background and white gridlines.  (Right) the alternative black
# and white theme with white background and grey gridlines.  Notice how
# the bars, data elements, are identical in both plots.
qplot(rating, data = movies, binwidth = 1)
last_plot() + theme_bw()

hgram <- qplot(rating, data = movies, binwidth = 1)

# Themes affect the plot when they are drawn, 
# not when they are created
hgram
previous_theme <- theme_set(theme_bw())
hgram

# You can override the theme for a single plot by adding 
# the theme to the plot. Here we apply the original theme
hgram + previous_theme

# Permanently restore the original theme
theme_set(previous_theme)

# Changing the appearance of the plot title.
hgramt <- hgram + 
  opts(title = "This is a histogram")
hgramt
hgramt + opts(plot.title = theme_text(size = 20))
hgramt + opts(plot.title = theme_text(size = 20, 
  colour = "red"))
hgramt + opts(plot.title = theme_text(size = 20, 
  hjust = 0))
hgramt + opts(plot.title = theme_text(size = 20, 
  face = "bold"))
hgramt + opts(plot.title = theme_text(size = 20, 
  angle = 180))

# Changing the appearance of lines and segments in the plot.
hgram + opts(panel.grid.major = theme_line(colour = "red"))
hgram + opts(panel.grid.major = theme_line(size = 2))
hgram + opts(panel.grid.major = theme_line(linetype = "dotted"))
hgram + opts(axis.line = theme_segment())
hgram + opts(axis.line = theme_segment(colour = "red"))
hgram + opts(axis.line = theme_segment(size = 0.5, 
  linetype = "dashed"))

# Changing the appearance of the plot and panel background
hgram + opts(plot.background = theme_rect(fill = "grey80", 
  colour = NA))
hgram + opts(plot.background = theme_rect(size = 2))
hgram + opts(plot.background = theme_rect(colour = "red"))
hgram + opts(panel.background = theme_rect())
hgram + opts(panel.background = theme_rect(colour = NA))
hgram + opts(panel.background = 
  theme_rect(linetype = "dotted"))

# Progressively removing non-data elements from a plot with
# \f{theme_blank}.
hgramt
last_plot() + opts(panel.grid.minor = theme_blank())
last_plot() + opts(panel.grid.major = theme_blank())
last_plot() + opts(panel.background = theme_blank())
last_plot() + 
  opts(axis.title.x = theme_blank(), 
       axis.title.y = theme_blank())
last_plot() + opts(axis.line = theme_segment())

# A bar chart and scatterplot created after a new visually consistent
# (if ugly!) theme has been applied.
old_theme <- theme_update(
  plot.background = theme_rect(fill = "#3366FF"),
  panel.background = theme_rect(fill = "#003DF5"),
  axis.text.x = theme_text(colour = "#CCFF33"),
  axis.text.y = theme_text(colour = "#CCFF33", hjust = 1),
  axis.title.x = theme_text(colour = "#CCFF33", face = "bold"),
  axis.title.y = theme_text(colour = "#CCFF33", face = "bold", 
   angle = 90)
)
qplot(cut, data = diamonds, geom="bar")
qplot(cty, hwy, data = mpg)
theme_set(old_theme)

set_default_scale("colour", "discrete", "grey")
set_default_scale("fill", "discrete", "grey")
set_default_scale("colour", "continuous", "gradient", 
  low = "white", high = "black")
set_default_scale("fill", "continuous", "gradient", 
  low = "white", high = "black")

update_geom_defaults("point", aes(colour = "darkblue"))
qplot(mpg, wt, data=mtcars)
update_stat_defaults("bin", aes(y = ..density..))
qplot(rating, data = movies, geom = "histogram", binwidth = 1)

qplot(mpg, wt, data = mtcars)
ggsave(file = "output.pdf")

pdf(file = "output.pdf", width = 6, height = 6)
# If inside a script, you will need to explicitly print() plots
qplot(mpg, wt, data = mtcars)
qplot(wt, mpg, data = mtcars)
dev.off()

# Three simple graphics we'll use to experiment with sophisticated plot
# layouts.
(a <- qplot(date, unemploy, data = economics, geom = "line"))
(b <- qplot(uempmed, unemploy, data = economics) + 
  geom_smooth(se = F))
(c <- qplot(uempmed, unemploy, data = economics, geom="path"))

# A viewport that takes up the entire plot device
vp1 <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)
vp1 <- viewport()

# A viewport that takes up half the width and half the height, 
# located in the middle of the plot.
vp2 <- viewport(width = 0.5, height = 0.5, x = 0.5, y = 0.5)
vp2 <- viewport(width = 0.5, height = 0.5)

# A viewport that is 2cm x 3cm located in the center
vp3 <- viewport(width = unit(2, "cm"), height = unit(3, "cm"))

# A viewport in the top right
vp4 <- viewport(x = 1, y = 1, just = c("top", "right"))
# Bottom left
vp5 <- viewport(x = 0, y = 0, just = c("bottom", "right"))

pdf("polishing-subplot-1.pdf", width = 4, height = 4)
subvp <- viewport(width = 0.4, height = 0.4, x = 0.75, y = 0.35)
b
print(c, vp = subvp)
dev.off()

csmall <- c + 
  theme_gray(9) + 
  labs(x = NULL, y = NULL) + 
  opts(plot.margin = unit(rep(0, 4), "lines"))

pdf("polishing-subplot-2.pdf", width = 4, height = 4)
b
print(csmall, vp = subvp)
dev.off()

pdf("polishing-layout.pdf", width = 8, height = 6)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))

vplayout <- function(x, y) 
  viewport(layout.pos.row = x, layout.pos.col = y)
print(a, vp = vplayout(1, 1:2))
print(b, vp = vplayout(2, 1))
print(c, vp = vplayout(2, 2))
dev.off()
