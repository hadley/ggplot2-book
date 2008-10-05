
# The effect of changing themes.  \Leftc the default grey theme with
# grey background and white gridlines.  \Rightc the alternative black
# and white theme with white background and grey gridlines.  Notice how
# the bars, data elements, are identical in both plots.
qplot(rating, data=movies, geom="histogram", binwidth=1)
last_plot() + theme_bw()

histogram <- qplot(rating, data=movies, geom="histogram", binwidth=1)
previous_theme <- theme_set(theme_bw())

# Themes affect the plot when they are drawn, not when they are created
histogram

# Override the theme for a single plot by adding it on
histogram + theme_bw(30)

# Apply the original theme to a single plot
histogram + previous_theme

# Permanently restore the original theme
theme_set(previous_theme)

(p <- qplot(cut, data=diamonds, geom="bar"))
p + opts(axis.text.x = theme_text(angle = 45, hjust=1))
old_theme <- theme_update(
  plot.background = theme_rect(fill = "#3366FF"),
  panel.background = theme_rect(fill = "#003DF5"),
  axis.text.x = theme_text(colour = "#CCFF33"),
  axis.text.y = theme_text(colour = "#CCFF33", hjust = 1),
  axis.title.x = theme_text(colour = "#CCFF33", face = "bold"),
  axis.title.y = theme_text(colour = "#CCFF33", face = "bold", angle = 90)
)
p
theme_set(old_theme)

p
last_plot() + opts(panel.grid.minor = theme_blank())
last_plot() + opts(panel.grid.major = theme_blank())
last_plot() + opts(panel.background = theme_blank())
last_plot() + opts(axis.title.x = theme_blank())
last_plot() + opts(axis.title.y = theme_blank())
last_plot() + opts(axis.line = theme_segment())

set_default_scale("colour", "discrete", "grey")
set_default_scale("fill", "discrete", "grey")
set_default_scale("colour", "continuous", "gradient", 
  low = "white", high = "black")
set_default_scale("fill", "continuous", "gradient", 
  low = "white", high = "black")

update_geom_defaults("point", aes(colour = "darkblue"))
qplot(mpg, wt, data=mtcars)
# update_stat_defaults("bin", aes(y = ..density..), binwidth = 1)
qplot(rating, data=movies, geom="histogram", binwidth=1)
