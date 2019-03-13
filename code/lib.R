# Lê os dados com cuidado com tipos e formato
read_projectdata <- function(){
    library(dplyr)
    readr::read_csv(here::here("data/clima_cg_jp.csv"), 
                    col_types = "cTdddd") %>% 
        mutate(ano = lubridate::year(dia), 
               mes = lubridate::month(dia))
}
