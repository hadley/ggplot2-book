
p <- qplot(sleep_total, sleep_cycle, data=msleep, colour=vore)
p 
p + scale_colour_discrete("What does\nit eat?", 
   breaks = rev(c("herbi", "carni", "omni", NA)), 
   labels = rev(c("plants", "meat", "both", "don't know")))
p + scale_colour_brewer(pal="Set1")

# Differences between default discrete and continuous colour scales
p <- qplot(sleep_total, sleep_cycle, data=msleep, colour=vore)
p 
p + scale_colour_discrete("What does\nit eat?", 
   breaks = rev(c("herbi", "carni", "omni", NA)), 
   labels = rev(c("plants", "meat", "both", "don't know")))
p + scale_colour_brewer(pal="Set1")

set_default_scale("colour", "discrete", "grey")
set_default_scale("colour", "continous", "gradient", 
 low = "white", high = "black"
)

p <- qplot(tip, total_bill, data=tips, colour=tip/total_bill)
p + scale_colour_gradient("Tip rate")
p + scale_colour_gradient("The amount of the tip\ndivided by the total bill")
p + scale_colour_gradient(expression(frac(tip, total_bill)))

# Legends with names given by (from left to right): {\tt "Tip rate"},
# {\tt "The amount of the tip$\backslash$ndivided by the total bill"}
# and {\tt expression(frac(tip, total\_bill)}
p <- qplot(tip, total_bill, data=tips, colour=tip/total_bill)
p + scale_colour_gradient("Tip rate")
p + scale_colour_gradient("The amount of the tip\ndivided by the total bill")
p + scale_colour_gradient(expression(frac(tip, total_bill)))

p <- qplot(cyl, wt, data=mtcars)
p
p + scale_x_continuous(breaks=c(5.5, 6.5))
p + scale_x_continuous(limits=c(5.5, 6.5))

qplot(carat, price, data=diamonds) + scale_x_log10() + scale_y_log10()
qplot(log10(carat), log10(price), data=diamonds)
