# Function that estimates height for given: dhh , age,
#          SiteIndex SI30 (M&N94, base age=30) and dominat dbh
# rs, 29apr2016
source("Functions/F_SiteIndex_MN94.R")

treeHeight <- function( dbh, age, SI, SI_base_age = 30, dom_d, min_h=2) {

# height~lod(dbh) slopes varies with age
# (direct influence of SI30 is not clear, data too limited to estimate)
# see "StudioCurveIpsometricheStoriche.R"
# final output
# > summary(hadm <- lm(slope~Age, data=coef))        # OK
# 
# Call:
#   lm(formula = slope ~ Age, data = coef)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -7.4251 -2.1374 -0.0433  1.5111  7.1651 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)   
# (Intercept)  -2.4424     4.4091  -0.554  0.58683   
# Age           0.4375     0.1157   3.781  0.00149 **
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 3.751 on 17 degrees of freedom
# Multiple R-squared:  0.4568,  Adjusted R-squared:  0.4248 
# F-statistic: 14.29 on 1 and 17 DF,  p-value: 0.001492
sc <- c(b0=-2.44244294517553006685e+00, b1=4.37506179872294120869e-01)
slope <- sc["b0"] + sc["b1"] * age
dom_h <- dougHdom_MN94(age, SI, SI_base_age)
interc <- dom_h - slope * log(dom_d)
return(pmax(min_h, interc + slope * log(dbh)))
}
