#Cargamos la librería _tidyverse_ con la cual trabajaremos para procesar la información

library(tidyverse, warn = FALSE)

#Levantamos las Bases Individuales de 4 trimestres.       


individual.216 <- read.table("Fuentes/usu_individual_t216.txt", sep=";", dec=",", header = TRUE, fill = TRUE)
individual.316 <- read.table("Fuentes/usu_individual_t316.txt", sep=";", dec=",", header = TRUE, fill = TRUE)
individual.416 <- read.table("Fuentes/usu_individual_t416.txt", sep=";", dec=",", header = TRUE, fill = TRUE)
individual.117 <- read.table("Fuentes/usu_individual_t117.txt", sep=";", dec=",", header = TRUE, fill = TRUE)

## Pasos para la construccion del Panel

#Paso 1
variables <- c('CODUSU','NRO_HOGAR','COMPONENTE', 'ANO4','TRIMESTRE',
               'ESTADO','PONDERA', 'CH04')

#Paso 2  
Bases_Continua <- bind_rows(
  individual.216  %>% select(variables),
  individual.316  %>% select(variables),
  individual.416  %>% select(variables),
  individual.117  %>% select(variables))

Bases_Continua <- Bases_Continua %>% 
  filter(ESTADO != 0) %>% 
  mutate(Trimestre = paste(ANO4, TRIMESTRE, sep="_")) %>% 
  arrange(Trimestre) %>% 
  mutate(Id_Trimestre = match(Trimestre,unique(Trimestre)))

Bases_Continua_Replica <- Bases_Continua_Id

names(Bases_Continua_Replica)[4:(length(Bases_Continua_Replica)-1)] <- 
  paste0(names(Bases_Continua_Replica)[4:(length(Bases_Continua_Replica)-1)],"_t1")


Bases_Continua_Replica$Id_Trimestre <- Bases_Continua_Replica$Id_Trimestre - 1

Panel_Continua <- inner_join(Bases_Continua,Bases_Continua_Replica)

##Cuantos casos tenemos??
nrow(Panel_Continua)  #Muestrales
sum(Panel_Continua$PONDERA)  #Ponderados

Registros_en_panel<- Panel_Continua %>% 
  group_by(ANO4,TRIMESTRE) %>% 
  summarise(Casos_panel = n())

Registros_en_bases<- Bases_Continua_Id %>% 
  group_by(ANO4,TRIMESTRE) %>% 
  summarise(Casos_base = n())

Casos_Porcentaje <- Registros_en_bases %>% 
  left_join (Registros_en_panel) %>% 
  mutate(Porcentaje = Casos_panel/Casos_base)

##Inconsistencias
Inconsist <- Panel_Continua %>% 
  mutate(Inconsist = case_when(CH04!=CH04_t1 ~ "inconsistente",
                               TRUE ~ "consistente")) %>% 
  group_by(Trimestre,Inconsist) %>% 
  summarise(Muestrales = n(),
            Ponderados = sum(PONDERA)) %>% 
  group_by(Trimestre) %>% 
  mutate(Porcentaje_muestral= Muestrales/sum(Muestrales),
         Porcentaje_pond= Ponderados/sum(Ponderados))
