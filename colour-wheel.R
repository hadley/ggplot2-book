library(scales)
library(dplyr)
library(colorspace)

hcl <- expand.grid(x = seq(-1, 1, length = 100), y = seq(-1, 1, length=100)) %>% 
  tbl_df() %>% 
  filter(x^2 + y^2 < 1) %>%
  mutate(
    r = sqrt(x^2 + y^2),
    c = 100 * r,
    h = 180 / pi * atan2(y, x),
    l = 65,
    colour = hcl(h, c, l)
  )

# sin(h) = y / (c / 100)
# y = sin(h) * c / 100

cols <- hue_pal()(5)
selected <- RGB(t(col2rgb(cols)) / 255) %>%
  as("polarLUV") %>%
  coords() %>%
  as.data.frame() %>%
  mutate(
    x = cos(H / 180 * pi) * C / 100,
    y = sin(H / 180 * pi) * C / 100,
    colour = cols
  )

ggplot(hcl, aes(x, y)) + 
  geom_raster(aes(fill = colour)) + 
  scale_fill_identity() + 
  scale_colour_identity() + 
  coord_equal() + 
  scale_x_continuous("", breaks = NULL) + 
  scale_y_continuous("", breaks = NULL) + 
  geom_point(data = selected, size = 10, color = "white") +
  geom_point(data = selected, size = 5, aes(colour = colour))
