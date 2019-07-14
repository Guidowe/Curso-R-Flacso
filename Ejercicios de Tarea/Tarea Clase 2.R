rm(list=ls())
script.dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
dir <- paste0(dirname(script.dir),"/")
bases.dir <- paste0(dir,"Fuentes/")
resultados.dir <- paste0(dir,"Resultados/")

### Replicar ambos ejercicios anteriores para distintos trimestres,
### levantando las bases desde el segundo trimestre 2016 hasta la última.
library(tidyverse)

Individual_t216 <-
  read.table(
    paste0(bases.dir, "usu_individual_t216.txt"),
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

Individual_t316 <-
  read.table(
    paste0(bases.dir, "usu_individual_t316.txt"),
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

Individual_t416 <-
  read.table(
    paste0(bases.dir, "usu_individual_t416.txt"),
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

Variables <- c("ANO4","TRIMESTRE","CH04","CH06","P21","ESTADO","CAT_OCUP","PONDERA","PONDIH")

Tasas_ej_1b  <- bind_rows(Individual_t216 %>% select(Variables),
                          Individual_t316 %>% select(Variables),
                          Individual_t416 %>% select(Variables)) %>% 
  filter(CH06 >= 18  & CH06<= 35) %>% 
  group_by(CH04,ANO4,TRIMESTRE) %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA) %>% 
  select(-c(Poblacion,Ocupados,Desocupados,PEA)) %>%
  ungroup() %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Hombre",
                          CH04 == 2 ~ "Mujer"))


Sal_Medio <- bind_rows(Individual_t216 %>% select(Variables),
                         Individual_t316 %>% select(Variables),
                         Individual_t416 %>% select(Variables)) %>% 
  mutate(GruposEdad = case_when(CH06 %in% (18:35) ~ "18a35",
                                CH06 %in% (36:70) ~ "36a70")) %>% 
  filter(ESTADO == 1, CAT_OCUP ==3, GruposEdad %in% c("18a35","36a70")) %>% 
  group_by(ANO4,TRIMESTRE,GruposEdad,CH04) %>% 
  summarise(Salario_Medio = weighted.mean(P21,w = PONDIH)) %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Hombre",
                          CH04 == 2 ~ "Mujer"))

