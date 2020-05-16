setwd("C:/Users/Usuario/Documents/curso reph/trabajo")
data<-read.csv("usu_individual_t117.txt", sep=";")
library(tidyverse)
view(data)

###Definicion de Sectores###

data <- data %>% 
  mutate(sector_actividad=case_when(
    PP04B_COD %in% c(0101:0300) ~ "Agricultura",
    PP04B_COD %in% c(0500:0900) ~ "Minería",
    PP04B_COD %in% c(1001:3300) ~ "Manufactura",
    PP04B_COD %in% c(3501:3900) ~ "Elec Gas Agua",
    PP04B_COD==4000 ~ "Construcción", 
    PP04B_COD %in% c(4501:4811) ~ "Comercio",
    PP04B_COD %in% c(4901:5300) ~ "Transporte",
    PP04B_COD %in% c(5500:5602) ~ "Hoteles y Restaurantes",
    PP04B_COD %in% c(5800:6300) ~ "Comunicaciones",
    PP04B_COD %in% c(6400:6600) ~ "Serv Financieros",
    PP04B_COD== 6800 ~ "Serv Inmobiliarios",
    PP04B_COD %in% c(6900:7500) ~ "Serv Profesionales",
    PP04B_COD %in% c(7701:8200) ~ "Serv Administrativos",
    PP04B_COD %in% c(8300:8403) ~ "Adm Pública",
    PP04B_COD %in% c(8501:8509) ~ "Educacion", 
    PP04B_COD %in% c(8600:8800) ~ "Salud", 
    PP04B_COD %in% c(9000:9302) ~ "Ocio", 
    PP04B_COD %in% c(9401:9609) ~ "Otros Servicios",
    PP04B_COD %in% c(9700:9800) ~ "Serv Domestico",
    PP04B_COD==9900 ~ "Org Extraterritorial"))

###Formalidad-Informalidad para el total
  
informalidad_total <- data %>% 
  summarise(Formales          = sum(PONDERA[ESTADO == 1 & PP07H==1]),
            Informales      = sum(PONDERA[ESTADO == 1 & PP07H==2]),
            Tasa_Formalidad                  = Formales/(Formales+Informales),
            Tasa_Informalidad                = Informales/(Formales+Informales))%>%
  select(3,4) %>% 
  mutate(Tasa_Formalidad=sprintf("%1.1f%%", 100*Tasa_Formalidad),
         Tasa_Informalidad=sprintf("%1.1f%%", 100*Tasa_Informalidad))

##informalidad sectores


informalidad_sector <- data %>% 
  filter(PP04B_COD %in% c(0101:9900)) %>%
  group_by(sector_actividad)%>%
  summarise(Formales          = sum(PONDERA[ESTADO == 1 & PP07H==1]),
            Informales      = sum(PONDERA[ESTADO == 1 & PP07H==2]),
            Tasa_Formalidad                  = Formales/(Formales+Informales),
            Tasa_Informalidad               = Informales/(Formales+Informales)) %>% 
  select(-c(2:3)) %>% 
  mutate(Tasa_Formalidad=round(Tasa_Formalidad,2),
         Tasa_Informalidad=round(Tasa_Informalidad,2))

informalidad_sector

grafico1<-ggplot(informalidad_sector, aes(x=reorder(sector_actividad,-Tasa_Informalidad),y=Tasa_Informalidad, fill=sector_actividad))+
  geom_bar(stat="identity", width=0.5)+
  labs(x = "Sector",
       y = "Tasa Informalidad",
       title = "Informalidad según sector",
       subtitle = "1trim_2017",
       caption = "Fuente: EPH")+
  theme(legend.position = 'none')

grafico1+ coord_flip()

grafico1 + coord_flip()


###genero y empleo sectorial##

genero <- data %>% 
  group_by(CH04) %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            Tasa_Actividad                  = PEA/Poblacion,
            Tasa_Empleo                     = Ocupados/Poblacion,
            Tasa_Desocupacion               = Desocupados/PEA)%>% 
  select(-c(2:5)) %>% 
  mutate(Tasa_Actividad=sprintf("%1.1f%%", 100*Tasa_Actividad),
         Tasa_Empleo=sprintf("%1.1f%%", 100*Tasa_Empleo),
         Tasa_Desocupacion=sprintf("%1.1f%%", 100*Tasa_Desocupacion),
         CH04 = case_when(CH04 == 1 ~ "Varon",
                          CH04 == 2 ~ "Mujer"))

genero


ocupados_sector<-data %>% 
  filter(ESTADO==1, PP04B_COD %in% c(0101:9900))%>%
  group_by(sector_actividad)%>%
  summarise(Ocupados_sector    =sum(PONDERA))%>%
  mutate(Participacion= Ocupados_sector/sum(Ocupados_sector)) %>% 
  select(1,3) %>% 
  mutate(Participacion=sprintf("%1.1f%%", 100*Participacion))
    
ocupados_sector



ocupados_sector_genero<-data %>% 
  filter(ESTADO==1, PP04B_COD %in% c(0101:9900))%>%
  group_by(sector_actividad)%>%
  summarise(Ocupados_sector_v    =sum(PONDERA[CH04==1]),
            Ocupados_sector_m    =sum(PONDERA[CH04==2]))%>%
  mutate(Participacion_varones= Ocupados_sector_v/sum(Ocupados_sector_v),
         Participacion_mujeres= Ocupados_sector_m/sum(Ocupados_sector_m)) %>% 
  select(-c(2,3)) %>% 
  mutate(Participacion_varones=sprintf("%1.1f%%", 100*Participacion_varones),
         Participacion_mujeres=sprintf("%1.1f%%", 100*Participacion_mujeres))


ocupados_sector_genero<-data %>% 
  filter(ESTADO==1, PP04B_COD %in% c(0101:9900))%>%
  group_by(sector_actividad)%>%
  summarise(Ocupados_sector_v    =sum(PONDERA[CH04==1]),
            Ocupados_sector_m    =sum(PONDERA[CH04==2]))%>%
  mutate(Participacion_varones= Ocupados_sector_v/sum(Ocupados_sector_v),
         Participacion_mujeres= Ocupados_sector_m/sum(Ocupados_sector_m)) %>% 
  select(-c(2,3)) %>% 
  mutate(Participacion_varones=round(Participacion_varones,2),
         Participacion_mujeres=round(Participacion_mujeres,2))%>% 
  rename(Varones=Participacion_varones,
         Mujeres=Participacion_mujeres)%>%
  gather(.,
         key=Género,
         value=Participación,
         2:3)

ocuapdos_sector_genero

grafico2<-ggplot(ocupados_sector_genero, aes(x=reorder(sector_actividad,-Participación),y=Participación, fill=sector_actividad))+
  geom_bar(stat="identity", width=0.5)+
  labs(x = "Sector",
       y = "Participación",
       title = "Distribución del empleo según sectores",
       subtitle = "1trim_2017",
       caption = "Fuente: EPH")+
  theme(legend.position = 'none')+
  facet_wrap(~Género)

grafico2 + coord_flip()

grafico2 + coord_flip()


ocupados_genero_sector<-data %>% 
  filter(ESTADO==1, PP04B_COD %in% c(0101:9900))%>%
  group_by(sector_actividad,CH04)%>%
  summarise(Ocupados_sector    =sum(PONDERA))%>%
  mutate(Participacion= Ocupados_sector/sum(Ocupados_sector)) %>% 
  select(-3) %>% 
  mutate(Participacion=sprintf("%1.1f%%", 100*Participacion),
         CH04 = case_when(CH04 == 1 ~ "Varon",
                          CH04 == 2 ~ "Mujer"))

ocupados_genero_sector<-data %>% 
  filter(ESTADO==1, PP04B_COD %in% c(0101:9900))%>%
  group_by(sector_actividad,CH04)%>%
  summarise(Ocupados_sector    =sum(PONDERA))%>%
  mutate(Participacion= Ocupados_sector/sum(Ocupados_sector)) %>% 
  select(-3) %>% 
  mutate(Participacion=round(Participacion,2),
         CH04 = case_when(CH04 == 1 ~ "Varón",
                          CH04 == 2 ~ "Mujer"))

grafico3<- ggplot(ocupados_genero_sector, aes(sector_actividad, Participacion, fill= CH04))+
  geom_col(position = "stack", alpha=0.6)+   
  labs(x = "Sector",
       y = "Distribucion",
       title = "Distribución del empleo por género segun sectores",
       subtitle = "1trim_2017",
       caption = "Fuente: EPH")

grafico3 + coord_flip()


            
            