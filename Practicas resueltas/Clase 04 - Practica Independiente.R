## ----echo=TRUE------------------------------------------------------------------------
library(readxl)
library(tidyverse)
ADEQUI <- read_excel("../Fuentes/ADEQUI.xlsx")
Regiones <- read_excel("../Fuentes/Regiones.xlsx")
base <- read.table("../Fuentes/usu_individual_t117.txt",header = T,sep = ";",dec = ",")


## ----echo=TRUE------------------------------------------------------------------------
base %>% 
  summarise(Casos_Ponderados =sum(PONDIH[ITF<15000]))


## ----echo=TRUE------------------------------------------------------------------------
base_con_identificador <- base %>% 
  left_join(ADEQUI,by = c("CH04", "CH06")) %>% 
  group_by(CODUSU,NRO_HOGAR) %>% 
  mutate(Personas_en_hogar = n(),
         adequi_en_hogar = sum(adequi))


## ----echo=TRUE------------------------------------------------------------------------
base_con_identificador %>% 
  ungroup() %>% 
  filter(Personas_en_hogar>=7) %>% 
  summarise(PERSONAS = sum(PONDERA))




## -------------------------------------------------------------------------------------
base_a_nivel_hogar <- base_con_identificador %>% 
  group_by(CODUSU,NRO_HOGAR) %>% 
  summarise(PONDIH = unique(PONDIH),
            ITF = unique(ITF),
            REGION = unique(REGION),
            Personas = n(),
            adequi_en_hogar = sum(adequi))


base_a_nivel_hogar %>% 
  filter(Personas>=7) %>% 
  ungroup() %>% 
  summarise(HOGARES = sum(PONDIH))

## -------------------------------------------------------------------------------------
base_a_nivel_hogar %>% 
  mutate(ITF.pc = ITF/Personas,
         ITF.ae = ITF/adequi_en_hogar) %>% 
  group_by(REGION) %>% 
  summarise(ITF.pc.promedio = weighted.mean(ITF.pc,PONDIH),
            ITF.ae.promedio = weighted.mean(ITF.ae,PONDIH)) %>% 
  left_join(Regiones)

