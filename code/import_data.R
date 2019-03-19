library(tidyverse)
library(lubridate)
# devtools::install_github('lhmet/inmetr')
library(inmetr)

# descobri a estação que me interessa assim:
# bdmep_meta %>% 
#     filter(name == "Campina Grande")


start_date <- "01/01/1988"
end_date <- format(Sys.Date(), "%d/%m/%Y")

met_data_cg <- bdmep_import(id = 82795,
                            sdate = start_date, 
                            edate = end_date, 
                            email = "nazareno@gmail.com",
                            passwd = "xxx", # você precisa se cadastrar em http://www.inmet.gov.br/portal/index.php?r=bdmep/bdmep
                            verbose = TRUE)

met_data_jp <- bdmep_import(id = 82798,
                            sdate = start_date, 
                            edate = end_date, 
                            email = "nazareno@gmail.com",
                            passwd = "xxx", # você precisa se cadastrar em http://www.inmet.gov.br/portal/index.php?r=bdmep/bdmep
                            verbose = TRUE)

met_data = bind_rows("Campina Grande" = met_data_cg, "João Pessoa" = met_data_jp, .id = "cidade")

por_dia = met_data %>% 
    mutate(dia = floor_date(date, unit = "day")) %>% 
    group_by(cidade, dia) %>% 
    summarise(tmedia = mean(tair), 
              tmax = max(tmax, na.rm = T), 
              tmin = max(tmin, na.rm = T), 
              chuva = sum(prec, na.rm = T)) %>% 
    filter(!is.na(tmedia), !is.infinite(tmax), !is.infinite(tmin))  

# glimpse(meteo_cg)

por_dia %>% 
    write_csv(here::here("data/clima_cg_jp.csv"))

por_dia %>% 
    mutate(semana = lubridate::floor_date(dia, unit = "weeks")) %>% 
    group_by(cidade, semana) %>% 
    summarise(tmedia = mean(tmedia), 
              tmax = max(tmax), 
              tmin = min(tmin), 
              chuva = sum(chuva)) %>% 
    write_csv("data/clima_cg_jp-semanal.csv")

