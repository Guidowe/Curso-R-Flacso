## -----------------------------------------------------------------------------
library(tidyverse)
library(openxlsx)

Individual_t117 <-
  read.table("../Fuentes/usu_individual_t117.txt",
             sep = ";",
             dec = ",",
             header = TRUE,
             fill = TRUE )

Individual_t119 <-
  read.table("../Fuentes/usu_individual_t119.txt",
             sep = ";",
             dec = ",",
             header = TRUE,
             fill = TRUE )

Individual_t216 <-
  read.table("../Fuentes/usu_individual_t216.txt",
             sep = ";",
             dec = ",",
             header = TRUE,
             fill = TRUE )

Individual_t316 <-
  read.table("../Fuentes/usu_individual_t316.txt",
             sep = ";",
             dec = ",",
             header = TRUE,
             fill = TRUE )

Individual_t416 <-
  read.table("../Fuentes/usu_individual_t416.txt",
             sep = ";",
             dec = ",",
             header = TRUE,
             fill = TRUE )



## -----------------------------------------------------------------------------
variables <- c("CH06","CH04","P21","CAT_OCUP","ESTADO","PONDERA","PONDIH")



## -----------------------------------------------------------------------------
Individual_t117 <- Individual_t117[,variables]
Individual_t119 <- Individual_t119[,variables]
Individual_t216 <- Individual_t216[,variables]
Individual_t316 <- Individual_t316[,variables]
Individual_t416 <- Individual_t416[,variables]



## -----------------------------------------------------------------------------
Tabla1_t117 <- Individual_t117 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]))

Tabla1_t119 <- Individual_t119 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]))

Tabla1_t216 <- Individual_t216 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]))

Tabla1_t316 <- Individual_t316 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]))

Tabla1_t416 <- Individual_t416 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]))




## -----------------------------------------------------------------------------
Tabla2_t117 <- Individual_t117 %>%   
  filter(CH06 %in%  18:35) %>% 
  group_by(CH04) %>%
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA)




## -----------------------------------------------------------------------------
Tabla3_t117 <- Individual_t117 %>%   
  filter(ESTADO==1) %>% 
  filter(CAT_OCUP==3) %>% 
  mutate(Grupo_Etario = case_when(CH06 %in%  18:35~"Jovenes",
                                  CH06 %in%  36:70~"Adultos")) %>% 
  group_by(CH04,Grupo_Etario) %>%
  summarise(Salario_Promedio = weighted.mean(P21,PONDIH)) %>% 
  filter(!is.na(Grupo_Etario))

Tabla4_t117 <- Individual_t117 %>%   
  filter(ESTADO==1) %>% 
  filter(CAT_OCUP==3) %>%   
  filter(CH06 %in%  36:70) %>% 
  group_by(CH04) %>%
  summarise(Salario_Promedio = weighted.mean(P21,PONDIH))



## -----------------------------------------------------------------------------
Lista_a_exportar <- list("Tasa de Ocupado t117"  = Tabla1_t117,
                         "Tasa de empleo t117"   = Tabla2_t117,
                         "Salario Promedio"      = Tabla3_t117)

write.xlsx(Lista_a_exportar,"../Resultados/Resultados Practica Indiv.xlsx")

