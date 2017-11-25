library(googlesheets)
source("Functions/access2DB.R", echo=F, verbose=F)
# t <- 
tibble::tribble(
  ~table,              ~sheet,
  "species",           "Specie",
  "stands",            "AdS",
  "dbh_tally",         "Cavallettamento",
  "heights",           "Altezze",
  "increment_borings", "Carotine") %>% 
  group_by(sheet) %>% 
  do(assign(.$table, gs_read(DataBase, ws=.$sheet), pos=1)) %>%
  rm()
# save(list=as.vector(t$table), file="GO_DonatoDB.Rdata")
# load("../GO_DonatoDB.Rdata")
dbh_tally <- dbh_tally %>% 
  tidyr::gather("species", "freq", -id_ads, -d_130, na.rm=T) %>%
  left_join(select(stands, id_ads, sup_m_quadri)) %>%
  mutate(n_ha = 10000 * freq / sup_m_quadri) 
