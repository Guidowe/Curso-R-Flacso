rm(list=ls())
library(tidyverse)
library(ggthemes)
library(ggjoy)
library(ggplot2)

dir <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
bases.dir      <-  paste0(dirname(dir),"/Fuentes/")
resultados.dir <- paste0(dirname(dir),"/Resultados/")


Individual_t117 <- read.table(paste0(bases.dir,"usu_individual_t117.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE)

### - Ejercicio 1

ggdata <- Individual_t117 %>% 
  select(ESTADO,CH06,PP07H,PONDERA, CAT_OCUP) %>% 
  filter(ESTADO == 1, CAT_OCUP == 3) %>% 
  mutate(Calidad_vinculo  = as.factor(case_when(PP07H == 1 ~ "Protegidos",
                                                         PP07H == 2 ~ "Precarios",
                                                         FALSE      ~ "Ns/Nr")))

ggplot(ggdata, aes(x = Calidad_vinculo , y = CH06, fill = Calidad_vinculo)) +
  geom_boxplot(alpha=0.6)+
  labs(x="", y="Edad",
       title="Distribución de edades de los ocupados asalariados",
       subtitle = "Según calidad del vinculo", 
       caption = "Fuente: Encuesta Permanente de Hogares")+
  theme_tufte()+
  scale_fill_gdocs()+
  theme(legend.position = "none",
        legend.title = element_blank(),
        plot.title   = element_text(size = 12))
####################Ejercicio 2
Individual_t117 <- read.table(paste0(bases.dir,"usu_individual_t117.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE) %>% 
  select(ANO4,TRIMESTRE,PONDERA,PP07H, CAT_OCUP,ESTADO)

Individual_t216 <- read.table(paste0(bases.dir,"usu_individual_t216.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE) %>% 
  select(ANO4,TRIMESTRE,PONDERA,PP07H, CAT_OCUP,ESTADO)

Individual_t316 <- read.table(paste0(bases.dir,"usu_individual_t316.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE)%>% 
  select(ANO4,TRIMESTRE,PONDERA,PP07H, CAT_OCUP,ESTADO)

Individual_t416 <- read.table(paste0(bases.dir,"usu_individual_t416.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE)%>% 
  select(ANO4,TRIMESTRE,PONDERA,PP07H, CAT_OCUP,ESTADO)

Union_Bases <- bind_rows(Individual_t216, 
                         Individual_t316,
                         Individual_t416,
                         Individual_t117) %>% 
  mutate(periodo = paste(ANO4, TRIMESTRE, sep = "_")) 

Tasa_Precariedad <- Union_Bases %>% 
  filter(ESTADO ==1, CAT_OCUP ==3) %>% 
  group_by(periodo) %>% 
  summarise(Precarios  = sum(PONDERA[PP07H == 2],na.rm = TRUE),
            Protegidos = sum(PONDERA[PP07H == 1],na.rm = TRUE),
            Desconocid = sum(PONDERA[!(PP07H  %in% c(1,2))],na.rm = TRUE),
            Tasa_Prec = Precarios/(Precarios+Protegidos))

Tasa_Precariedad %>% #Podemos usar los "pipes" para llamar al Dataframe que continen la info
  ggplot(aes(x = periodo,
             y = Tasa_Prec,
             group = 'Tasa_Prec',#Agrupar nos permitirá generar las lineas del gráfico
             label= round(Tasa_Prec*100,2))) +  #Agregamos una etiqueta a los datos (Redondeando la variable a 2 posiciones decimales)
  labs(x = "Trimestre",
       y = "Tasa_Prec",
       title = "Evolución de la tasa de precariedad",
       subtitle = "Serie 2trim_2016 - 1trim_2017", caption = "Fuente: EPH")+ #Agregamos titulo y modificamos  ejes
  geom_point(size= 3)+ #puedo definir tamaño de las lineas
  geom_line( size= 1 )+
  geom_label(label.size = 0.25)+ #Aplico la etiqueta
  theme_minimal()+ #Elijo un tema para el gráfico
  theme(legend.position = "none") #Elimino la leyenda
