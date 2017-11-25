source("Functions/F_SiteIndex_MN94.R")
felling_year <- 2017
# dominant height and 
# site class  evaluation

# cumulative frequencies 
cum_frq <- 
  dbh_tally %>%
  group_by(id_ads, d_130) %>%
  summarise(n_ha_tot = sum(n_ha)) %>%
  group_by(id_ads) %>%
  arrange(desc(d_130)) %>%           #  in DESCENDING order!
  do(mutate(., cum_n_ha = cumsum(n_ha_tot)))

# dominant diameter: quadratic mean of the 100 dickest diams
d_dom <-
  cum_frq %>%
  filter(cum_n_ha >= 100) %>%
  group_by(id_ads) %>%
  filter(d_130 == max(d_130)) %>% 
  # lower limit: the diam including the 100ed, 
  #              the largest of those including and below the 100ed
  mutate(n_ha_tot = n_ha_tot - (cum_n_ha - 100)) %>%
  union(filter(cum_frq, cum_n_ha < 100)) %>%
  summarise(n_tot = sum(n_ha_tot), 
            d_dom = sqrt(sum(n_ha_tot * d_130^2)/n_tot ))

# height corresponding to dominant diameter
h_dom <-
  heights %>%
  filter(sp == "dou") %>%
  group_by(id_ads) %>%
  do(hm=loess(h~diam, .)) %>%
  left_join(d_dom) %>%
  group_by(id_ads) %>%
  do(d_dom = .$d_dom, 
     f = predict(.$hm[[1]], data.frame(diam=.$d_dom), se = TRUE)) %>%
  group_by(id_ads) %>%
  do(d_dom = .$d_dom[[1]], 
     h_dom = (.$f[[1]]$fit[[1]]),
     se.h_dom = (.$f[[1]]$se.fit[[1]])
  ) %>%
  left_join(select(stands, id_ads, eta2017)) %>%
  mutate(felling_year = felling_year, age = eta2017, d_dom = d_dom[[1]],
         h_dom = h_dom[[1]],  se.h_dom = se.h_dom[[1]],
         plantation_year = 2017 - eta2017,
         SI_MN94_50 = dougSI_MN94(age, h_dom)) %>%
  select(-eta2017)
rm("cum_frq", "d_dom")
