###- Levantar la última base individual de EPH
bases.dir <- "Fuentes/"

"Fuentes/"

library(tidyverse)
Individual_t117 <-
  read.table(paste0(bases.dir, "usu_individual_t117.txt"),
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

### - Crear un vector que contenga los nombres de las siguientes variables de interés para realizar algunos ejercicios:
### Edad, Sexo, Ingreso de la ocupación principal, Categoría ocupacional, ESTADO, PONDERA y PONDIH
Variables <- c("ANO4","TRIMESTRE","CH04","CH06","P21","ESTADO","CAT_OCUP","PONDERA","PONDIH","PONDIIO")

### - Acotar la Base únicamente a las variables de interés 

Individual_t117 <- Individual_t117 %>% 
  select(Variables)

#############Punto 8######################
Base_PUNTO_8 <- Individual_t117 %>% 
  filter(ESTADO != 0)

nrow(Base_PUNTO_8)

#############Punto 9######################
Base_PUNTO_9 <- Individual_t117 %>% 
  filter(ESTADO == 1,CAT_OCUP==3) %>%
  filter(P21>0) %>% 
  summarise(Inprom = weighted.mean(P21,PONDIIO))

Base_PUNTO_9
#############Punto 10######################
Base_PUNTO_10 <- Individual_t117 %>% 
  filter(ESTADO == 1,CAT_OCUP==3) %>%
  filter(P21>0) %>% 
  group_by(CH04) %>%  
  summarise(Inprom = weighted.mean(P21,PONDIIO))




A <- Individual_t117 %>% 
  filter(ESTADO == 1,CAT_OCUP==3) %>%
  filter(P21<=0)
B <- unique(A[,c("P21","PONDIIO")])
