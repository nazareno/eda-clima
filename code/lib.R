# Lê os dados com cuidado com tipos e formato
read_projectdata <- function(){
    library(dplyr)
    readr::read_csv(here::here("data/clima_cg_jp-semanal.csv"), 
                    col_types = "cTdddd") %>% 
        mutate(ano = lubridate::year(semana), 
               mes = lubridate::month(semana))
}
