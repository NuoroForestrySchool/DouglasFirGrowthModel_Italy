Modelling brest height diameter growth
================
Roberto Scotti
November 2017

html\_document
==============

``` r
library(ggplot2)
df <- increment_borings %>%
  select(1:5) %>%
  left_join(select(stands, id_ads, eta2017)) %>%
  mutate(d_inc_f = `da-sottoc-a-5anni` / 5,
         delta_eta = eta2017-40,
         d_inc_v = `da-sottoc-a-CIRCA_40anniDiEtà` / delta_eta) %>%
  assign("df", .)
```

    ## Joining, by = "id_ads"

``` r
ggplot(df) + 
  geom_point(aes(d_inc_f, d_inc_v, color = as.factor(delta_eta)), alpha = .3) +
  geom_smooth(aes(d_inc_f, d_inc_v, color = as.factor(delta_eta)))
```

    ## `geom_smooth()` using method = 'loess'

![](StudioPerInc_d130_files/figure-markdown_github-ascii_identifiers/visualize-1.png)

``` r
lm(data=df, d_inc_v~d_inc_f*as.factor(delta_eta)) %>%
  summary()
```

    ## 
    ## Call:
    ## lm(formula = d_inc_v ~ d_inc_f * as.factor(delta_eta), data = df)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.84818 -0.14825 -0.01556  0.13210  1.65595 
    ## 
    ## Coefficients:
    ##                                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                    -0.07232    0.08365  -0.864 0.387730    
    ## d_inc_f                         0.60668    0.05710  10.625  < 2e-16 ***
    ## as.factor(delta_eta)7           0.48118    0.13802   3.486 0.000532 ***
    ## as.factor(delta_eta)8           0.24428    0.14827   1.648 0.100058    
    ## as.factor(delta_eta)12          0.50218    0.09038   5.556 4.44e-08 ***
    ## as.factor(delta_eta)15          0.86324    0.15896   5.431 8.69e-08 ***
    ## as.factor(delta_eta)38          0.18972    0.09559   1.985 0.047719 *  
    ## d_inc_f:as.factor(delta_eta)7   0.30548    0.06920   4.414 1.24e-05 ***
    ## d_inc_f:as.factor(delta_eta)8   0.35917    0.07311   4.913 1.21e-06 ***
    ## d_inc_f:as.factor(delta_eta)12  0.29402    0.05892   4.990 8.28e-07 ***
    ## d_inc_f:as.factor(delta_eta)15  0.18700    0.08730   2.142 0.032673 *  
    ## d_inc_f:as.factor(delta_eta)38 -0.22769    0.06174  -3.688 0.000250 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.2848 on 512 degrees of freedom
    ## Multiple R-squared:  0.947,  Adjusted R-squared:  0.9459 
    ## F-statistic: 832.2 on 11 and 512 DF,  p-value: < 2.2e-16

Two readings have been taken for each increment boring: \* d\_inc\_f : the cumulative width of the last 5 year-rings \* d\_inc\_v : the width till the age of 40 years

The second one includes a variable number of rings, depending on current age. Standardising to yearly increments, for most cases relatively similar values are attained, but significant difference are evident at least for 'delta' equal 38 and 7.

In these cases yearly increments estimated based on just 2 or even 33 more year-rings are doubled with respect to the estimate based only on the last five years. There seems to be a mistake in the readings!
