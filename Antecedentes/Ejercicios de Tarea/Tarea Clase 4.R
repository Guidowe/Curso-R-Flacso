rm(list=ls())
dir <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
bases.dir      <-  paste0(dirname(dir),"/Fuentes/")
resultados.dir <- paste0(dirname(dir),"/Resultados/")

library(tidyverse)
library(openxlsx)
library(ggthemes)
library(ggplot2)


Individual_t117 <- read.table(paste0(bases.dir,"usu_individual_t117.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE)
Regiones <- read.xlsx(paste0(bases.dir,"Regiones.xlsx"))
Aglomerados <- read.xlsx(paste0(bases.dir,"Aglomerados EPH.xlsx"))

Base<- Individual_t117 %>% 
  left_join(Regiones) %>% 
  left_join(Aglomerados)

  
  #Filtro la base restringiendola a una región
  Tasas_Desocupacion <- Base %>% 
    group_by(Region,Sexo = CH04) %>% 
    summarise(Poblacion         = sum(PONDERA),
              Ocupados          = sum(PONDERA[ESTADO == 1]),
              Desocupados       = sum(PONDERA[ESTADO == 2]),
              PEA               = Ocupados + Desocupados,
             Tasa_Desocupacion  = Desocupados/PEA) %>% 
    mutate(Sexo = case_when(Sexo == 1 ~ "Varones",
                            Sexo == 2 ~ "Mujeres"))

  
for(Reg in unique(Base$Region)){
    
#Filtro la tabla restringiendola a una región
  Base_reg <- Tasas_Desocupacion %>%
      filter(Region == Reg)  
  
Graf <- Base_reg %>% 
    ggplot(., aes(Sexo, Tasa_Desocupacion, fill = Sexo, 
                  label = sprintf("%1.1f%%", 100*Tasa_Desocupacion)))+
    geom_col(position = "stack", alpha=0.6) + 
    geom_text(position = position_stack(vjust = 0.5), size=3)+
    labs(x="",y="Porcentaje",
         title = unique(Base_reg$Region),
         subtitle = "Tasa de Desocupacion")+
    theme_minimal()+
    scale_y_continuous()+
    theme(legend.position = "bottom",
          legend.title=element_blank(),
          axis.text.x = element_text(angle=25))    
print(Graf)  
}
