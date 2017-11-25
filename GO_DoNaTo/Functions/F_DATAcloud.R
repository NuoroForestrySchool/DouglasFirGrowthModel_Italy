DATA_cloud <- function(table) {
  
  if (typeof(table)!="character") return("Usage: DATA_cloud(<table_name>)")
  
  library("googlesheets")
  library('sqldf')
  suppressMessages(library(dplyr))
  
  BaseDati <- gs_title("BaseDati")
  print(t(t(BaseDati$ws$ws_title)))
  
  # AdS <- BaseDati %>% gs_read(ws=table)
  return( BaseDati %>% gs_read(ws=table))
  
}
