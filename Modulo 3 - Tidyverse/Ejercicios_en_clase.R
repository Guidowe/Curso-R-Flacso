#Reiniciar R

library(tidyverse, warn = FALSE)
library(openxlsx, warn = FALSE)

###Selecciono variables
var.ind <- c('CODUSU','NRO_HOGAR' ,'COMPONENTE','ANO4','TRIMESTRE','REGION',
             'AGLOMERADO', 'PONDERA', 'CH04', 'CH06', 'ITF',
             'PONDIH','P21',"P47T","PONDIIO","PONDII")

###Levanto Bases y otros archivos necesarios
individual.316 <- read.table("Fuentes/usu_individual_t316.txt",
                             sep=";", dec=",", 
                             header = TRUE, fill = TRUE) %>% 
  select(var.ind)

individual.416 <- read.table("Fuentes/usu_individual_t416.txt", sep=";", dec=",", header = TRUE, fill = TRUE) %>% 
  select(var.ind)

# Calcular Brecha en el ingreso promedio entre varones y mujeres (Ambos Trimestres, P21, P47T)
Brecha_Ingresos <- Bases %>% 
  mutate(Sexo = case_when(CH04==1~"Varones",
                          CH04==2~"Mujeres")) %>% 
  group_by(Sexo,ANO4,TRIMESTRE) %>%
  filter(P21>0) %>% 
  summarise(Ingreso_Ocup_Ppal = weighted.mean(x = P21,w = PONDIIO),
            Ingreso_Tot_Indiv = weighted.mean(x = P47T,w = PONDII)) %>% 
  pivot_longer(names_to = "Tipo_Ingreso",values_to = "Valor",cols = 4:5) %>% 
  pivot_wider(.,names_from = Sexo,values_from = Valor)  %>% 
  mutate(Brecha = Varones/Mujeres)

# Calcular la tasa de pobreza para varones y mujer, y para tres grupos de edad ()
Pobreza_sexo <- Pobreza_Individual_paso3 %>% 
  mutate(Sexo = case_when(CH04==1~"Varones",
                          CH04==2~"Mujeres"),
         Grupos_Etarios = case_when(CH06 <18 ~"Menores",
                                    CH06 %in% 18:65 ~"Adultos",
                                    CH06 > 65 ~"Adultos Mayores")) %>% 
  group_by(Sexo,Situacion,ANO4,TRIMESTRE,Grupos_Etarios) %>% 
  summarise(Casos_Ponderados = sum(PONDIH)) %>% 
  group_by(Sexo,ANO4,Grupos_Etarios,TRIMESTRE) %>% 
  summarise(Indigencia = Casos_Ponderados[Situacion == "Indigente"]/sum(Casos_Ponderados),
            Pobreza = sum(Casos_Ponderados[Situacion != "No.Pobre"])/sum(Casos_Ponderados))
  
# Brecha_Ingresos_Totales <- Bases %>% 
#   mutate(Sexo = case_when(CH04==1~"Varones",
#                           CH04==2~"Mujeres")) %>% 
#   group_by(Sexo,ANO4,TRIMESTRE) %>%
#   filter(P21>0) %>% 
#   summarise(Ingreso_Ocup_Ppal = weighted.mean(x = P47T,w = PONDIIO)) %>% 
#   pivot_wider(.,names_from = Sexo,values_from = Ingreso_Ocup_Ppal) %>% 
#   mutate(Brecha = Varones/Mujeres)
