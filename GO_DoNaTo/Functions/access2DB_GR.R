## hide ws key
suppressMessages(library(dplyr))
DataBase <- gs_key("1-2qcNq5d0aw9GW0rh6fouRF_VfgtrUYcRh4ikRDEIg8")
#DataBase <- gs_title("GO_BaseDati_GR")
replace_ws <- function(wsn, wsi, sfile) {
  if(wsn %in% gs_ws_ls(sfile)) 
    sfile <- gs_ws_delete(sfile, ws = wsn)
  sfile <- sfile %>%
    gs_ws_new(ws_title = wsn,
              input = wsi, 
              trim = T)
  return(sfile)
}

