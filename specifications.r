# Shapes ---------------------------------------------------------

shapes <- data.frame(
  shape = c(0:19, 22, 21, 24, 23, 20),
  x = 0:24 %/% 5,
  y = -(0:24 %% 5)
)
qplot(x, y, data=shapes, shape=shape, size=I(5), fill=I("blue")) + scale_shape_identity() + scale_x_continuous("", breaks = NA, limits=c(0, 4.4)) + scale_y_continuous("", breaks = NA) + geom_text(aes(x = x + 0.2, label=shape), hjust=0)

ggsave(file = "_include/shape-specification.pdf", width=6, height=6)