setwd("~/RICERCA/GitHub/DouglasFirGrowthModel_Italy/GO_DoNaTo")
library(ggplot2)
library(rpart)
df_ipso <- heights %>%
  filter(sp=="dou") %>%
  left_join(select(h_dom, id_ads, SI_MN94_50, plantation_year)) %>%
  mutate(age = current_year - plantation_year,
         SC = plyr::round_any(SI_MN94_50, 5, round))
df_ipso %>% select(id_ads, SI_MN94_50, age, SC) %>% unique() %>% 
  arrange(SI_MN94_50, age) %>% 
  print() %$% 
  plot(age, SI_MN94_50)
# ALL id_ads in class '40 m',, only 'C-A' in class 35 and c('C-B', 'V-B') in 45
# Excluding the old ones, SiteIndex decreses sharply with age!!
# Analysis has to be limited to the central Site Class (i.e. exluding SC of 35 and 45 m)

library(rpart.plot)
df <- rpart(h~diam+age+SI_MN94_50, df_ipso[df_ipso$SC==40,])
prp(df, extra=1, cex=.5)
df_ipso %>% select(diam, age, SI_MN94_50) %>% summary()
df_ipso %$% plot(diam, age)
library(ggplot2)
expand.grid(diam = seq(20, 100, 10), age = seq(40, 80, 20), SI_MN94_50 = seq(35, 45, 10)) %>%
  mutate(h_pred = predict(df, newdata = .)) %>%
  ggplot(aes( diam, jitter(.$h_pred))) + geom_line(aes(colour= as.factor(age), linetype = as.factor(SI_MN94_50)))

source("Functions/F_treeHeight.R")
df_ipso <- heights %>%
  filter(sp=="dou") %>%
  left_join(select(h_dom, id_ads, d_dom, SI_MN94_50, plantation_year)) %>%
  mutate(d_dom = unlist(d_dom),
         age = current_year - plantation_year,
         h_pred0 = treeHeight(diam, age, SI_MN94_50, SI_base_age = 50, d_dom),
         h_pred = predict(df))

qplot(h_pred0, h_pred, data = df_ipso)

qplot(h_pred0, h-h_pred0, data = df_ipso)

df_ipso2 <- df_ipso %>%
  transmute(model = "DoNaTo", id_ads = id_ads, diam = diam, h = h, h_pred = h_pred, h_residuals = h - h_pred) %>%
  union(transmute(df_ipso, model = "Georg", id_ads = id_ads, diam = diam, h = h, h_pred = h_pred0, h_residuals = h - h_pred0))

ggplot(data = df_ipso2, group = model) + 
  geom_point(aes(h_pred, h_residuals, shape = model, color = model)) +
  labs(x = "predicted h", y = "residual") +
  scale_shape_manual(values=c(1, 4)) 
# previous model is not suited for current case!!

heights %>%
  filter(sp=="dou") %>%
  left_join(select(h_dom, id_ads, SI_MN94_50, plantation_year)) %>%
  mutate(age = current_year - plantation_year,
         SC = as.factor(plyr::round_any(SI_MN94_50, 5, round)))

df_ipso %>%
  filter(SC==40) %>%
  plot_ly(type="scatter3d", x = ~diam, z = ~h, y = ~age,
          color = ~SI_MN94_50) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'd_130 [cm]'),
                      yaxis = list(title = 'age [years]'),
                      zaxis = list(title = 'heigth [m]')))
# Curves do not evidence any major form modification with age,
# they simply move up with age

summary(m <- lm(h ~ log(diam) * id_ads, data= df_ipso))
# no significant contribution from slope modification, 
#   but offset modification importance is hidden
# Residuals:
# Min      1Q  Median      3Q     Max 
# -5.2862 -1.2748 -0.0047  1.2351  5.2784 
# Residual standard error: 1.989 on 270 degrees of freedom
# Multiple R-squared:  0.9071,	Adjusted R-squared:  0.8999 
# F-statistic: 125.6 on 21 and 270 DF,  p-value: < 2.2e-16

summary(m <- lm(h ~ log(diam) + id_ads, data= df_ipso))
# having a single slope, offset importance is evident
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -5.2850 -1.3294  0.0454  1.2866  5.4145 
# Residual standard error: 1.99 on 280 degrees of freedom
# Multiple R-squared:  0.9036,	Adjusted R-squared:  0.8998 
# F-statistic: 238.7 on 11 and 280 DF,  p-value: < 2.2e-16
# ----
#  VERY BIG RESIDUALS
# Coefficients:
# Estimate Std. Error t value Pr(>|t|)    
#  log(diam)    16.4194     0.5069  32.395  < 2e-16 ***
slope_new <- coef(m)["log(diam)"]
# ---- previous model
 sc <- c(b0=-2.44244294517553006685e+00, b1=4.37506179872294120869e-01)
# slope <- sc["b0"] + sc["b1"] * age
age <- 40:60
plot(age, sc["b0"] + sc["b1"] * age)
abline(h=slope_new, lty=2)
# Slopes from previous model are way too steel for the considered ages!
#        age 40.0000 45.00000 50.00000 55.0000 60.00000
#  slope_old 15.0578 17.24534 19.43287 21.6204 23.80793

source("Functions/F_treeHeight2.R")
df_ipso <- heights %>%
  filter(sp=="dou") %>%
  left_join(select(h_dom, id_ads, d_dom, SI_MN94_50, plantation_year)) %>%
  mutate(d_dom = unlist(d_dom),
         age = current_year - plantation_year,
         h_pred = treeHeight(diam, age, SI_MN94_50, SI_base_age = 50, d_dom))
ggplot(data = df_ipso) + 
  geom_boxplot(aes(as.factor(age), h-h_pred))
ggplot(data = df_ipso) + 
  geom_point(aes(diam, h, color = id_ads), shape = 20, size = 2, alpha = .4) +
  geom_line(aes(diam, h_pred, colour= id_ads), size = .7) +
  geom_smooth(aes(diam, h, colour= id_ads), se = F, size = 1, linetype="dashed") +
  geom_point(aes(d_dom, h_dom, color = id_ads), data = h_dom, shape = 13, size = 4) +
  facet_wrap(~age)
