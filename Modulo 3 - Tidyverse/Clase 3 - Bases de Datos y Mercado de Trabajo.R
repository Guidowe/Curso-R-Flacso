## ---- warning=FALSE,message=FALSE-----------------------------------------------
library(tidyverse)
library(openxlsx)


## -------------------------------------------------------------------------------
list.files("Fuentes/")


## -------------------------------------------------------------------------------
Individual_t117 <-
  read.table(file = "Fuentes/usu_individual_t117.txt",
  sep = ";",
  dec = ",",
  header = TRUE,
  fill = TRUE)
  
  
Aglom <- read.xlsx("Fuentes/Aglomerados EPH.xlsx")

names(Individual_t117)

## -------------------------------------------------------------------------------
Datos  <- Individual_t117[1:5000,
c("AGLOMERADO","CH04","CH06","PONDERA")]
Datos


## -------------------------------------------------------------------------------
pepito <- Datos %>% 
  filter(CH04==1 , CH06>=50)



## -------------------------------------------------------------------------------
base2 <- Datos %>% 
    filter(CH04==1 | CH06>=50)



## -------------------------------------------------------------------------------
Datos <- Datos %>% 
  rename(EDAD = CH06)

Datos



## -------------------------------------------------------------------------------
Datos <- Datos %>% 
  mutate(Edad_Cuadrado=EDAD^2)
Datos


## -------------------------------------------------------------------------------
Datos <- Datos %>% 
  mutate(Grupos_Etarios = 
           case_when(
             EDAD  < 18   ~ "Menores",
             EDAD  %in%  18:65   ~ "Adultos",
             EDAD  > 65 ~ "Adultos Mayores"
             )
         )
Datos


## -------------------------------------------------------------------------------
ver <- Datos %>% 
  select(CH04,PONDERA)


ver <- Datos %>% 
  select(-PONDERA)



## -------------------------------------------------------------------------------
Datos <- Datos %>% 
  arrange(CH04,desc(EDAD))
Datos


## -------------------------------------------------------------------------------
valor <- mean(Datos$EDAD)
weighted.mean(x = Datos$EDAD,w = Datos$PONDERA)


Datos %>% 
  mutate(Edad2=case_when(EDAD <0 ~ 0.5,
                          TRUE ~  as.numeric(EDAD)))
Edad_prom <- Datos %>%       
   summarise(Edad_prom = mean(EDAD),
             suma_edad = sum(EDAD),
             Edad_prom_pond = weighted.mean(x = EDAD,w = PONDERA))



## -------------------------------------------------------------------------------
Edad_sexo <- Datos %>% 
  group_by(AGLOMERADO) %>%
  summarise(Edad_Prom = weighted.mean(EDAD,PONDERA)) 
  


## -------------------------------------------------------------------------------
Encadenado <- Datos %>% 
  filter(Grupos_Etarios == "Adultos") %>% 
  mutate(Sexo = case_when(CH04 == 1 ~ "Varon",
                          CH04 == 2 ~ "Mujer")) %>% 
  select(-Edad_Cuadrado)
  
Encadenado


## -------------------------------------------------------------------------------
Aglom

 
Datos_c_nombre <- left_join(Datos,Aglom)


## -------------------------------------------------------------------------------
Datos_join <- Datos %>% 
  left_join(.,Aglom, by = "AGLOMERADO")

Poblacion_Aglomerados <- Datos_join %>% 
  filter(AGLOMERADO != 5) %>% 
  group_by(Nom_Aglo) %>% 
  summarise(Varones = sum(PONDERA[CH04==1]),
            Mujeres = sum(PONDERA[CH04==2]))

Poblacion_Aglomerados



## -------------------------------------------------------------------------------
pob.aglo.long <- Poblacion_Aglomerados %>% 
  pivot_longer(cols = 2:3,
               names_to = "Sexo",
               values_to = "Poblacion")

pob.aglo.long


## -------------------------------------------------------------------------------
pob.aglo.long %>% 
  pivot_wider(names_from = "Sexo",values_from = "Poblacion")
  


## -------------------------------------------------------------------------------

Datos_gather <- Poblacion_Aglomerados %>%  
  gather(.,
   key   = Grupo,
   value = Total, 
   2:3)  

Datos_gather


## -------------------------------------------------------------------------------
Datos_Spread <- Datos_gather %>% 
  spread(.,       # el . llama a lo que esta atras del %>% 
  key = Grupo,    #la llave es la variable cuyos valores van a dar los nombres de columnas
  value = Total) #los valores con que se llenan las celdas

Datos_Spread  


## -------------------------------------------------------------------------------
Poblacion_ocupados <- Individual_t117 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]))

Poblacion_ocupados


## -------------------------------------------------------------------------------
Empleo <- Individual_t117 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Tasa_Empleo    = Ocupados/Poblacion)

Empleo


## -------------------------------------------------------------------------------
Empleo %>% 
  mutate(Tasa_Empleo_Porc = sprintf("%1.1f%%",100*Tasa_Empleo))


## ----eval=FALSE, warining = FALSE-----------------------------------------------
## Lista_a_exportar <- list("Tasa de Empleo"  = Empleo,
##                          "Poblacion Aglos" = Poblacion_Aglomerados)
## 
## write.xlsx(x = Lista_a_exportar,file = "Resultados/ejercicioclase3.xlsx")
## 

