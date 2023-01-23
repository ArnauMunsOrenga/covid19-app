#Loading packages ====
library(lubridate)
library(dplyr)
library(stringr)
library(tidyr)
library(readxl)
library(httr)
library(shinyBS)
library(DT)
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(shinydashboard)
library(flexdashboard)
library(shinyjs)
library(shinyLP)
library(shinyhelper)
library(plotly)
library(shinyWidgets)
library(shinyalert)
library(shinymanager)
library(gotop)
library(shinyscreenshot)
library(janitor)
library(leaflet)
library(rsconnect)
# packages = c(
#              'lubridate',
#              'dplyr',
#              'stringr',
#              'tidyr',
#              'readxl',
#              'httr',
#              'shinyBS',
#              'DT',
#              'shiny',
#              'shinythemes',
#              'shinycssloaders',
#              'shinydashboard',
#              'flexdashboard',
#              'shinyjs',
#              'shinyLP',
#              'shinyhelper',
#              'plotly',
#              'shinyWidgets',
#              'shinyalert',
#              'RJSONIO',
#              'shinymanager',
#              'gotop',
#              "shinyscreenshot"
#              )
# 
# for(p in packages){
#   if(!require(p, character.only = T)){
#     install.packages(p)
#   }
#   library(p, character.only = T)
# }


# Load input files
start_time<-Sys.time()
#setwd(dirname(rstudioapi::getSourceEditorContext()$path))


#LOAD AND PROCESS DATA ----

#COVID TOTAL
covid_data <- read.csv2(file = "data/Registre_de_casos_de_COVID-19_a_Catalunya_per_municipi_i_sexe.csv", header = T, sep = ",") %>% 
  clean_names() %>% 
  mutate(tipus_cas_data = as.Date(tipus_cas_data, "%d/%m/%Y")) %>% 
  select(-c(sexe_codi)) %>% 
  filter(comarca_descripcio != "")

#COMARQUES
lat_lon <- read.csv2(file = "data/Caps_de_municipi_de_Catalunya_georeferenciats.csv", header = T, sep = ",") %>% 
  clean_names() %>% 
  select(comarca, codi_comarca, longitud, latitud) %>% 
  group_by(comarca, codi_comarca) %>% 
  mutate(longitud = as.numeric(longitud), latitud = as.numeric(latitud)) %>% 
  summarize(longitud = mean(longitud), latitud = mean(latitud, na.rm=T)) %>% 
  rename("comarca_codi" = "codi_comarca")

covid_data_comarques_total <- covid_data %>% 
  group_by(comarca_descripcio, comarca_codi) %>% 
  summarise(num_casos = sum(num_casos)) %>% 
  left_join(lat_lon, by = "comarca_codi") %>% 
  select(-comarca)

poblacio_comarques <- read.csv2(file = "data/poblacio_comarques.csv", header = T, sep = ";") %>% 
  clean_names() %>% 
  select(-literal)

covid_data_comarques_densitat <- covid_data_comarques_total %>% 
  left_join(poblacio_comarques, by = c("comarca_codi" = "codi")) %>% 
  mutate(densitat_covid = num_casos / total)%>% 
  arrange(desc(densitat_covid))
  
#MUNICIPIS

lat_lon_municipi <- read.csv2(file = "data/Caps_de_municipi_de_Catalunya_georeferenciats.csv", header = T, sep = ",") %>% 
  clean_names() %>% 
  select(municipi, codi_municipi, codi_municipi_ine, longitud, latitud) %>% 
  group_by(municipi, codi_municipi, codi_municipi_ine) %>% 
  mutate(longitud = as.numeric(longitud), latitud = as.numeric(latitud)) %>% 
  summarize(longitud = mean(longitud), latitud = mean(latitud, na.rm=T)) %>% 
  rename("municipi_codi_local" = "codi_municipi",
         "municipi_codi" = "codi_municipi_ine"
         )

covid_data_municipis_total <- covid_data %>% 
  group_by(municipi_descripcio, municipi_codi) %>% 
  summarise(num_casos = sum(num_casos)) %>% 
  left_join(lat_lon_municipi, by = "municipi_codi") %>% 
  select(-municipi)


poblacio_municipis <- read.csv2(file = "data/poblacio_municipis.csv", header = T, sep = ";") %>% 
  clean_names() %>% 
  select(-literal)

covid_data_municipis_densitat <- covid_data_municipis_total %>%
  left_join(poblacio_municipis, by = c("municipi_codi_local" = "codi")) %>%
  mutate(densitat_covid = num_casos / total) %>% 
  arrange(desc(densitat_covid))

# line charts ----

evolucio_total <- covid_data %>% 
  mutate(any_mes = lubridate::floor_date(tipus_cas_data, "month")) %>% 
  group_by(any_mes) %>% 
  summarise(total_mes = sum(num_casos, na.rm=T))

evolucio_total_acumulada <- evolucio_total %>% mutate(total_acumulat = cumsum(total_mes))

evolucio_total_per_tipus <- covid_data %>% 
  mutate(any_mes = lubridate::floor_date(tipus_cas_data, "month")) %>% 
  group_by(any_mes, tipus_cas_descripcio) %>% 
  summarise(total_mes = sum(num_casos, na.rm=T))

evolucio_total_per_tipus_acumulada <- evolucio_total_per_tipus 
evolucio_total_per_tipus_acumulada$total_acumulat <- ave(evolucio_total_per_tipus_acumulada$total_mes, evolucio_total_per_tipus_acumulada$tipus_cas_descripcio, FUN=cumsum)

casos_x_sexe <- covid_data %>% 
  mutate(any_mes = lubridate::floor_date(tipus_cas_data, "month")) %>% 
  group_by(sexe_descripcio) %>% 
  summarise(total_mes = sum(num_casos, na.rm=T))

mitjana_casos_comarca_mes <- covid_data %>% 
  mutate(any_mes = lubridate::floor_date(tipus_cas_data, "month")) %>% 
  group_by(any_mes, comarca_descripcio) %>% 
  summarise(mitjana_casos_mes = sum(num_casos, na.rm=T)) %>% 
  group_by(comarca_descripcio) %>% 
  summarise(mitjana_casos_mes = mean(mitjana_casos_mes, na.rm=T)) %>% 
  mutate(mitjana_casos_mes = round(mitjana_casos_mes,2))

covid_barcelona <- covid_data %>% 
  filter(districte_codi!="") %>% 
  select(districte_codi, districte_descripcio) %>% 
  unique %>% 
  arrange(districte_codi) %>% 
  mutate(longitud = c(2.17319,2.16179,2.1546,2.13007,2.1394,2.15641,2.1677,2.17727,2.19022,2.19933),
         latitud = c(41.38022,41.38896,41.37263,41.38712,41.40104,41.40237,41.41849, 41.44163,41.43693,41.41814)) %>% 
  mutate(longitud = as.numeric(longitud),
         latitud = as.numeric(latitud)) %>% 
  left_join(covid_data %>% 
              filter(districte_codi!="") %>% 
              group_by(districte_codi, districte_descripcio) %>% summarize(total_casos = sum(num_casos, na.rm=T)), by = c("districte_codi", "districte_descripcio"))

# Auxiliar functions ----


# m <- leaflet() %>% setView( 1.647020, 41.690635, zoom = 8)
# m %>% addTiles()
  

