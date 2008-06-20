library(nlme)
library(effects)
Oxboys$Subject <- factor(Oxboys$Subject)

model1 <- lm(height ~ age, data = Oxboys)
model2 <- lm(height ~ age * Subject, data = Oxboys)
model3 <- lme(height ~ age, data = Oxboys, random = ~ 1 + age | Subject)

# Get predictions of mean change
age_grid <- seq(-1, 1, length = 50)
pred1 <- predict(model1, data.frame(age=age_grid))
pred2 <- effect("age", model2, default.levels = 50)
pred3 <- predict(model3, data.frame(age=age_grid), level=0)

pred <- data.frame(
  age = age_grid,
  m1 = pred1,
  m2 = pred2,
  m3 = pred3
)

qplot(age, height, data=Oxboys, geom="line", group=Subject)

# Per boy models ---------------------------------------------

l(plyr)
single_model <- function(df) lm(height ~ age, data=df)
models <- dlply(Oxboys, .(Subject), single_model)
coefs <- ldply(models, coef)
names(coefs) <- c("Subject", "intercept", "slope")
qplot(intercept, slope, data=coefs)#  + geom_smooth(se=F)


# Simpler example --------------------------------------------

model <- lme(height ~ age, data = Oxboys, random = ~ 1 + age | Subject)

age_grid <- seq(-1, 1, length = 50)
subjects <- unique(Oxboys$Subject)

preds <- expand.grid(age = age_grid, Subject = subjects)
preds$height <- predict(model, pred_grid)

oplot <- qplot(age, height, data=Oxboys, group = Subject, geom="line")
oplot + geom_line(data = preds, colour = "#3366FF", size= 0.5)

Oxboys$fitted <- predict(model)
Oxboys$resid <- with(Oxboys, fitted - height)

oplot %+% Oxboys + aes(y = resid)

model2 <- update(model, height ~ age + I(age ^ 2))
Oxboys$fitted2 <- predict(model2)
Oxboys$resid2 <- with(Oxboys, fitted2 - height)

oplot %+% Oxboys + aes(y = resid2)

