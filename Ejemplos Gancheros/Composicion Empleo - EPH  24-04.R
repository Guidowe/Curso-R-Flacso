rm(list=ls())
gc()

library(xlsx)
library(readxl)
library(shiny)
library(shinythemes)
library(plotly)
library(ggjoy)
library(tidyverse)
library(ggplot2)
library(ggthemes)  
library(ggrepel)   
library(scales)
library(statar)

script.dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
bases.dir <-paste0(dirname(script.dir),"/Fuentes/")
resultados.dir<-paste0(dirname(script.dir),"/Resultados/")

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

options(scipen = 999)
#####Variables Individuales
Variables_Interes <- c("CODUSU","PONDERA","TRIMESTRE","ANO4","CH03","CH04","CH06","REGION","AGLOMERADO","ESTADO","CAT_OCUP",
                       "PP04A","PP07H","NIVEL_ED","PP04D_COD","PP04B_COD","PP3E_TOT","INTENSI","IPCF","PONDIH","PONDIIO","P21",
                       "PP10C","PP10D", "PP10A", "PP10E", "PP11A", "PP11B_COD", "PP11D_COD", "PP11N")

####Levanto Bases####


set.seed(92491)
Individual_t117 <- read.table(paste0(bases.dir,"usu_individual_t117.txt"),
                              sep=";", dec=",", header = TRUE) %>% 
  select(Variables_Interes) %>% 
  mutate(ING_PC_rd = IPCF+runif(nrow(.),min = -0.01,max =0.01))

set.seed(92491)
Individual_t416 <- read.table(paste0(bases.dir,"usu_individual_t416.txt"),
                              sep=";", dec=",", header = TRUE) %>% 
  select(Variables_Interes) %>% 
  mutate(ING_PC_rd = IPCF+runif(nrow(.),min = -0.01,max =0.01))

set.seed(92491)
Individual_t316 <- read.table(paste0(bases.dir,"usu_individual_t316.txt"),
                              sep=";", dec=",", header = TRUE) %>%  
  select(Variables_Interes) %>% 
  mutate(ING_PC_rd = IPCF+runif(nrow(.),min = -0.01,max =0.01))

set.seed(92491)
Individual_t216 <- read.table(paste0(bases.dir,"usu_individual_t216.txt"),
                              sep=";", dec=",", header = TRUE) %>%  
  select(Variables_Interes) %>% 
  mutate(ING_PC_rd = IPCF+runif(nrow(.),min = -0.01,max =0.01))


#####Levanto fuentes secundarias####
dic.regiones <- read_excel(paste0(bases.dir,'Regiones.xlsx'))
dic.aglomerados <- read_excel(paste0(bases.dir,'Aglomerados EPH.xlsx'))


Bases <- bind_rows(Individual_t216,Individual_t316,Individual_t416,Individual_t117) %>%
  mutate(Periodo = paste0(ANO4,"_T",TRIMESTRE),
         Id_Trimestre = match(Periodo,unique(Periodo)),  
         Ventana = case_when(Id_Trimestre == 1 ~ "Interanual",
                             Id_Trimestre == 2 ~ "Trimestral"),
         Sector = case_when(ESTADO == 1 & CAT_OCUP==3 & PP04A!=1  & PP07H==1 ~"Asal. Priv. No Precarios",
                            ESTADO == 1 & CAT_OCUP==3 & PP04A!=1  & PP07H==2 ~"Asal. Priv. Precarios",
                            ESTADO == 1 & PP04A ==1   ~"Estatales",
                            ESTADO == 1 & CAT_OCUP==2 ~ "Cuentapropistas",
                            ESTADO == 1 & CAT_OCUP==1 ~ "Patrones",
                            ESTADO == 1 & CAT_OCUP==4 ~ "TFSR",
                            ESTADO == 2 ~ "Desocupados",
                            ESTADO == 3 ~ "Inactivos",
                            ESTADO == 4 ~ "Menores",
                            ESTADO == 0 ~ "Entrevista no Realiz",
                            TRUE ~ "Resto Ocupados"),
         Categorias_Ocup = case_when(Sector == "Estatales" ~ "Estatal",
                                     Sector == "Asal. Priv. Precarios" ~ "Privado no registrado",
                                     Sector %in% c("Asal. Priv. No Precarios",
                                                   "Cuentapropistas","Patrones","TFSR",
                                                   "Resto Ocupados")~"Privado.Resto"),
         Sexo = case_when (CH04 == 1 ~"Varon", CH04 == 2 ~"Mujer"),
         Grupo_etario = factor (x = case_when(CH06<=29 ~ "Hasta 29 años",
                                              CH06>=30 & CH06<=64 ~ "De 30 a 64 años",
                                              CH06>=65 ~ "65 años o más"),
                                levels = c("Hasta 29 años","De 30 a 64 años","65 años o más")),
         Parentesco = factor(x = case_when(CH03 == 1 ~ "Jefe",
                                           CH03 == 2 ~ "Conyuge",
                                           CH03 == 3 ~ "Hijos",
                                           CH03 %in% 4:10 ~ "Otros"),
                             levels = c("Jefe","Conyuge","Hijos","Otros")),
         Educacion = factor (x = case_when(NIVEL_ED %in% c(1,2,3,7) ~ "Hasta secundario incompleto",
                                           NIVEL_ED %in% c(4,5) ~ "Sec completo/ Sup incompleto",
                                           NIVEL_ED %in% 6 ~ "Superior completo"),
                             levels = c("Hasta secundario incompleto","Sec completo/ Sup incompleto","Superior completo")),
         Tipo_empleo = factor (x= case_when(Sector == "Estatales" ~ "Estatal",
                                            Sector == "Asal. Priv. Precarios" ~ "Asalariados Priv. Precarios",
                                            Sector == "Asal. Priv. No Precarios" ~ "Asal. Priv. No Precarios",
                                            Sector %in% c("Cuentapropistas","Patrones")~"Independientes",
                                            ESTADO == 1 & CAT_OCUP %in% c(4,9) ~ "Resto Ocupados"), 
                               levels = c("Estatal","Asalariados Priv. Precarios","Asal. Priv. No Precarios","Independientes","Resto Ocupados")),
         Ocup5 = substrRight(PP04D_COD,1),
         Calif_ocup = factor (x = case_when(Ocup5 == 1 ~ "Profesional",
                                            Ocup5 == 2 ~ "Tecnico",
                                            Ocup5 == 3 ~ "Operativo",
                                            Ocup5 == 4 ~ "No calificado", 
                                            TRUE ~ "No definido"),
                              levels = c("Profesional","Tecnico","Operativo","No calificado","No definido")),
         Intensidad = factor (x = case_when(INTENSI == 1 ~ "Subocupado",
                                            INTENSI == 2 ~ "Ocupado pleno",
                                            INTENSI == 3 ~ "Sobreocupado",
                                            INTENSI == 4 ~ "No trabajo en la semana",
                                            TRUE ~ "No definido"),
                              levels = c("Subocupado","Ocupado pleno","Sobreocupado","No trabajo en la semana")),
         Horas_Ocup_Ppal = case_when(PP3E_TOT >= 35 ~ "35hs o mas",
                                     PP3E_TOT < 35 ~ "Menos de 35hs "),
         Sexo_Horas = case_when(CH04 == 1 & PP3E_TOT < 35 ~ "Hombres < 35hs",
                                CH04 == 2 & PP3E_TOT < 35 ~ "Mujeres < 35hs",
                                CH04 == 1 & PP3E_TOT >= 35 ~ "Hombre  >= 35hs",
                                CH04 == 2 & PP3E_TOT >= 35 ~ "Mujeres >= 35hs"),
         Rama = factor (x = case_when((PP04B_COD >= 1001 & PP04B_COD <= 3300) | 
                                        (PP04B_COD >= 10   & PP04B_COD <= 33)      ~ "Industria manufacturera",
                                      PP04B_COD == 4000 | PP04B_COD == 40       ~ "Construccion",
                                      ((PP04B_COD >= 4500 & PP04B_COD <= 4811) | 
                                         (PP04B_COD >= 45   & PP04B_COD <= 48) )|     
                                        ((PP04B_COD >= 5500 & PP04B_COD <= 5602)| 
                                           (PP04B_COD >= 55   & PP04B_COD <= 56))      ~ "Comercio, Hoteles y restaurants",
                                      (PP04B_COD >= 4900 & PP04B_COD <= 5300) | 
                                        (PP04B_COD >= 49   & PP04B_COD <= 53)   |
                                        (PP04B_COD >= 5800 & PP04B_COD <= 6300) | 
                                        (PP04B_COD >= 58   & PP04B_COD <= 63)      ~ "Transporte y almac. - Comunicaciones",
                                      (PP04B_COD >= 6400 & PP04B_COD <= 8200) | 
                                        (PP04B_COD >= 64   & PP04B_COD <= 82)      ~ "Ss financieros e Inmuebles -  Ss empresariales",
                                      (PP04B_COD >= 8401 & PP04B_COD <= 8403) | 
                                        PP04B_COD  == 84                          ~ "Adm. publica y defensa",
                                      (PP04B_COD >= 8501 & PP04B_COD <= 8509) | 
                                        PP04B_COD  == 85                          ~ "Enseñanza",
                                      ((PP04B_COD >= 8600 & PP04B_COD <= 8800) | 
                                         (PP04B_COD >= 86   & PP04B_COD <= 88))|
                                        ((PP04B_COD >= 9000 & PP04B_COD <= 9609) |
                                           (PP04B_COD >= 90   & PP04B_COD <= 96))    ~ "Ss comunitarios, sociales y de salud",
                                      PP04B_COD == 9700 | PP04B_COD == 97       ~ "Servicio domestico",
                                      (PP04B_COD >= 3501 & PP04B_COD <= 3900) | 
                                        PP04B_COD == 9900 | 
                                        (PP04B_COD >= 35   & PP04B_COD <= 39) |
                                        ((PP04B_COD >= 9996 & PP04B_COD <= 9999) | 
                                           PP04B_COD == 99)|
                                        ((PP04B_COD >= 101  & PP04B_COD <= 900)  | 
                                           (PP04B_COD >= 01   & PP04B_COD <= 09) )     ~ "Otras ramas"),
                        levels = c("Industria manufacturera","Construccion","Comercio, Hoteles y restaurants","Transporte y almac. - Comunicaciones","Ss financieros e Inmuebles -  Ss empresariales",
                                   "Adm. publica y defensa","Enseñanza","Ss comunitarios, sociales y de salud","Servicio domestico","Otras ramas")),
         Tipo_desocupado = factor (x = case_when(ESTADO == 2 & PP10A == 0 ~ "No respondieron",
                                                 ESTADO == 2 & PP10D == 2 ~ "Nunca trabajó",
                                                 ESTADO == 2 & (PP10C==1 | PP10D==1) ~ "Desocupados Cesantes"),
                                   levels = c("Desocupados Cesantes","Nunca trabajó","No respondieron")),
         Tipo_empleo_anterior = factor (x = case_when(Tipo_desocupado == "Nunca trabajó" ~ "Nunca trabajó",
                                                      Tipo_desocupado == "Desocupados Cesantes" & PP10E != 6 & PP11A == 1 ~ "Estatal",
                                                      Tipo_desocupado == "Desocupados Cesantes" & PP10E != 6 & (PP11A == 2 |PP11A == 3) ~ "Privado",
                                                      Tipo_desocupado == "Desocupados Cesantes" & PP10E == 6 ~ "Su último trabajo fue hace más de 3 años",
                                                      TRUE ~ "No definido"),
                                        levels = c("Estatal","Privado","Su último trabajo fue hace más de 3 años","Nunca trabajó","No definido")),
         Ocup5 = substrRight(PP11D_COD,1),
         Calif_ocup_anterior = factor (x = case_when(Tipo_desocupado == "Desocupados Cesantes" & Ocup5 == 1 ~ "Profesional",
                                                     Tipo_desocupado == "Desocupados Cesantes" & Ocup5 == 2 ~ "Tecnico",
                                                     Tipo_desocupado == "Desocupados Cesantes" & Ocup5 == 3 ~ "Operativo",
                                                     Tipo_desocupado == "Desocupados Cesantes" & Ocup5 == 4 ~ "No calificado",
                                                     Tipo_desocupado == "Desocupados Cesantes" & PP10E == 6 ~ "Su último trabajo fue hace más de 3 años",
                                                     Tipo_desocupado == "Nunca trabajó" ~ "Nunca trabajó",
                                                     TRUE ~ "No definido"),
                                       levels = c("Profesional","Tecnico","Operativo","No calificado","Su último trabajo fue hace más de 3 años",
                                                  "Nunca trabajó","No definido")),
         Duracion_Desemp = case_when ((PP10A==1 & PP10E>=0) | (PP10A>=2 & PP10E==1) ~"Menos de 1 mes",
                                      (PP10A==2 & (PP10E>=2 | PP10E==0)) | (PP10A>=3 & PP10E==2) ~"De 1 a 3 meses",
                                      (PP10A==3 & (PP10E>=3 | PP10E==0)) | (PP10A>=4 & PP10E==3) ~"De 3 a 6 meses",
                                      (PP10A==4 & (PP10E>=4 | PP10E==0)) | (PP10A>=5 & PP10E==4) ~"De 6 a 12 meses",
                                      (PP10A==5 & (PP10E>=5 | PP10E==0))                         ~"Mas de 1 año",
                                      TRUE ~ "No definido"),
         Rama_anterior = factor(x = case_when((PP11B_COD >= 1001 & PP11B_COD <= 3300) | 
                                                (PP11B_COD >= 10   & PP11B_COD <= 33)   ~ "Industria manufacturera",
                                              PP11B_COD == 4000 | PP11B_COD == 40       ~ "Construccion",
                                              ((PP11B_COD >= 4500 & PP11B_COD <= 4811) | 
                                                 (PP11B_COD >= 45   & PP11B_COD <= 48) )|  
                                                (PP11B_COD >= 5500 & PP11B_COD <= 5602) | 
                                                (PP11B_COD >= 55   & PP11B_COD <= 56)      ~ "Comercio, Hoteles y restaurants",
                                              (PP11B_COD >= 4900 & PP11B_COD <= 5300) | 
                                                (PP11B_COD >= 49   & PP11B_COD <= 53)   | 
                                                (PP11B_COD >= 5800 & PP11B_COD <= 6300) | 
                                                (PP11B_COD >= 58   & PP11B_COD <= 63)      ~ "Transporte y almac. - Comunicaciones",
                                              (PP11B_COD >= 6400 & PP11B_COD <= 8200) | 
                                                (PP11B_COD >= 64   & PP11B_COD <= 82)      ~ "Ss financieros e Inmuebles -  Ss empresariales",
                                              (PP11B_COD >= 8401 & PP11B_COD <= 8403) | 
                                                PP11B_COD  == 84                          ~ "Adm. publica y defensa",
                                              (PP11B_COD >= 8501 & PP11B_COD <= 8509) | 
                                                PP11B_COD  == 85                          ~ "Enseñanza",
                                              PP11B_COD == 9700 | PP11B_COD == 97       ~ "Servicio domestico",
                                              (PP11B_COD >= 9000 & PP11B_COD <= 9609) | 
                                                (PP11B_COD >= 90   & PP11B_COD <= 96) |
                                                (PP11B_COD >= 8600 & PP11B_COD <= 8800) | 
                                                (PP11B_COD >= 86   & PP11B_COD <= 88)   ~ "Ss comunitarios, sociales y de salud",
                                              ((PP11B_COD >= 3501 & PP11B_COD <= 3900) | 
                                                 PP11B_COD == 9900  |  
                                                 (PP11B_COD >= 35   & PP11B_COD <= 39))|
                                                ((PP11B_COD >= 101  & PP11B_COD <= 900)|
                                                   (PP11B_COD >= 01   & PP11B_COD <= 09))|  
                                                (PP11B_COD >= 9996 & PP11B_COD <= 9999) |  PP11B_COD == 99   ~ "Otras ramas",
                                              (Tipo_desocupado == "Desocupados Cesantes" &
                                                 PP10E == 6)   |Tipo_desocupado == "Nunca trabajó" ~ "Nunca trabajó o más de 3 años desocup",
                                              TRUE ~ "Otras ramas"),
                                levels = c("Industria manufacturera","Construccion","Comercio, Hoteles y restaurants",
                                           "Transporte y almac. - Comunicaciones","Ss financieros e Inmuebles -  Ss empresariales",
                                           "Adm. publica y defensa","Enseñanza","Ss comunitarios, sociales y de salud","Servicio domestico",
                                           "Otras ramas","Nunca trabajó o más de 3 años desocup"))) %>% 
  group_by(Periodo) %>% 
  mutate(quintil_IFPC  = as.character(xtile(ING_PC_rd,n=5,w = PONDIH))) %>% 
  ungroup() %>% 
  left_join(dic.aglomerados) %>% 
  left_join(dic.regiones)


# Bases_ej <- Bases %>% 
#   mutate(Parentesco = factor(x = Parentesco,levels = c("Jefe","Conyuge","Hijos","Otros")))


Distrib_quintiles_IFPC <- Bases %>%
  group_by(Periodo,quintil_IFPC) %>%
  summarise(registros = n(),
            suma_PONDERA  = sum(PONDERA,na.rm = TRUE),
            suma_PONDIH  = sum(PONDIH,na.rm = TRUE),
            Cant_Ocup = sum(PONDIH[ESTADO==1],na.rm = TRUE),
            Cant_Desocup = sum(PONDIH[ESTADO==2],na.rm = TRUE),
            Cant_Inact_y_Menores = sum(PONDIH[ESTADO %in% c(3,4)],na.rm = TRUE),
            Cant_No_Resp = sum(PONDIH[ESTADO == 0],na.rm = TRUE))

A <- Distrib_quintiles_IFPC %>% 
  group_by(Periodo) %>% 
  summarise(Cant_Ocup = sum(Cant_Ocup))

B <- Bases %>% 
  group_by(Periodo) %>% 
  summarise(Cant_Ocup = sum(PONDERA[ESTADO == 1]))

Tasas <- Bases %>% 
  mutate(Periodo = paste0(TRIMESTRE, "T", ANO4)) %>%
  group_by(Periodo) %>%
  mutate(Poblacion = sum(PONDERA),
         Pob_Pondih= sum(PONDIH)) %>% 
  group_by(Periodo) %>% 
  summarise(Tasa_Ocup = sum(PONDERA[ESTADO==1],na.rm =TRUE)/unique(Poblacion),
            Tasa_Ocup_Pondih = sum(PONDIH[ESTADO==1],na.rm =TRUE)/unique(Pob_Pondih),
            Tasa_Desocup = sum(PONDERA[ESTADO==2],na.rm =TRUE)/unique(Poblacion),
            Tasa_Desocup_Pondih = sum(PONDIH[ESTADO==2],na.rm =TRUE)/unique(Pob_Pondih)) 




# Distrib_quintiles_P21 <- Bases %>%
#    group_by(Periodo,quintil_P21) %>%
#    summarise(registros = n(),
#              suma_PONDIIO  = sum(PONDIIO,na.rm = TRUE),
#              Cant_Ocup = sum(PONDERA[ESTADO==1],na.rm = TRUE))
# 

# Composicion_Tasa_Aglom <- Bases %>% 
#   mutate(Periodo = paste0(TRIMESTRE, "T", ANO4)) %>%
#   group_by(Periodo,AGLOMERADO) %>%
#   mutate(Poblacion = sum(PONDERA)) %>% 
#   group_by(Periodo,AGLOMERADO,Categorias_Ocup) %>% 
#   summarise(Tasa = sum(PONDERA[ESTADO==1],na.rm =TRUE)/unique(Poblacion)) %>% 
#   filter(Tasa != 0) %>% 
#   left_join(dic.aglomerados) %>% 
#   select(Nom_Aglo,everything()) %>% 
#   mutate(Nom_Aglo = str_wrap(Nom_Aglo,width = 15))
# 
#  Composicion_Tasa_Nac <- Bases %>% 
#    mutate(Periodo = paste0(TRIMESTRE, "T", ANO4)) %>%
#    group_by(Periodo) %>%
#    mutate(Poblacion = sum(PONDERA,na.rm =TRUE),
#           Ocupados          = sum(PONDERA[ESTADO == 1],na.rm =TRUE),
#           Desocupados       = sum(PONDERA[ESTADO == 2],na.rm =TRUE),
#           PEA               = Ocupados + Desocupados) %>% 
#    group_by(Periodo,Rama) %>% 
#    summarise(Tasa_Empleo = sum(PONDERA[ESTADO==1],na.rm =TRUE)/unique(Poblacion),
#              Tasa_Desocupacion = sum(PONDERA[ESTADO==2],na.rm =TRUE)/unique(PEA)) %>% 
#    filter(!is.na(Rama))  
# unique(Bases$Rama)


#####SHINY TASA DE EMPLEO#####
# Define UI for app that draws a histogram 
ui_PONDERA <- fluidPage(
  
  tabsetPanel(
    tabPanel("Empleo", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 radioButtons(inputId = "Categoria", label =  "Elegir Categoria :",
                              choices = c("Sexo" = "Sexo",
                                          "Grupo etario" = "Grupo_etario",
                                          "Nivel educativo" = "Educacion",
                                          "Posición en el hogar"  = "Parentesco",
                                          "Tipo de empleo"  = "Tipo_empleo",
                                          "Calificación ocupacional" = "Calif_ocup",
                                          "Rama de actividad" = "Rama",
                                          "Intensidad" = "Intensidad",
                                          "Horas en Ocup Ppal" = "Horas_Ocup_Ppal",
                                          "Horas en Ocup Ppal x Sexo" = "Sexo_Horas"), 
                              selected = "Sexo"),
                 
                 # radioButtons(inputId = "Periodo", label =  "Elegir Periodo :",
                 #              choices = c("Trimestral" = "Trimestral",
                 #                          "Interanual" = "Interanual"), selected = "Trimestral"),
                 
                 selectizeInput('Aglomerado',
                                'Aglomerado',
                                choices = c("Total Pais",unique(Bases$Nom_Aglo)),
                                selected = "Total Pais",             
                                multiple = FALSE
                 ) 
                 
               ),
                              mainPanel(
                                plotlyOutput(outputId = "plot1")
                                )
             )
    ),
    tabPanel("Desempleo", fluid = TRUE,
             
             sidebarLayout(
               sidebarPanel(
                 
                 
                 
                 radioButtons(inputId = "Categoria_Desocup", label =  "Elegir Categoria :",
                              choices = c("Sexo" = "Sexo",
                                          "Grupo etario" = "Grupo_etario",
                                          "Posición en el hogar"  = "Parentesco",
                                          "Nivel educativo" = "Educacion",
                                          "Duración del desempleo"  = "Duracion_Desemp",
                                          "Tipo de empleo de la última ocupación" = "Tipo_empleo_anterior",
                                          "Calificación ocupacional de la última ocupación" = "Calif_ocup_anterior",
                                          "Rama de actividad de la última ocupación" = "Rama_anterior"), 
                              selected = "Sexo"),
                 
                 # radioButtons(inputId = "Periodo", label =  "Elegir Periodo :",
                 #              choices = c("Trimestral" = "Trimestral",
                 #                          "Interanual" = "Interanual"), selected = "Trimestral"),
                 
                 selectizeInput('Aglomerado_Desempleo',
                                'Aglomerado',
                                choices = c("Total Pais",unique(Bases$Nom_Aglo)),
                                selected = "Total Pais",             
                                multiple = FALSE
                 ) 
                 
                 
               ),
               
               #Main panel for displaying outputs
               mainPanel(
                 
                 plotlyOutput(outputId = "plot2")
                 
               )
               )
             )
    )
  )


# Define server logic required to draw a histogram 
server_PONDERA <- function(input, output) {
  
  output$plot1 <- renderPlotly({
    
    Categoria_Elegida <- input$Categoria 
    Periodo_Elegido <- input$Periodo   
    Tasa_Elegida <- input$Tasa 
    Aglo_Elegido <- input$Aglomerado

    
    Bases2 <- Bases   
        if(input$Aglomerado!="Total Pais"){
          
          Bases2 <- Bases %>% 
          filter(Nom_Aglo == Aglo_Elegido)
        }

      
     Composicion_Tasa_Empleo <- Bases2 %>% 
      #filter(Ventana  %in%  c(NA,Periodo_Elegido)) %>% 
      #mutate(Periodo = paste0(TRIMESTRE, "T", ANO4)) %>%
      group_by_("Periodo") %>%
      mutate(Poblacion = sum(PONDERA,na.rm =TRUE)) %>% 
      group_by_("Periodo",Categoria_Elegida) %>% 
      summarise(Tasa_Empleo = sum(PONDERA[ESTADO==1],na.rm =TRUE)/unique(Poblacion)) %>% 
      filter(Tasa_Empleo != 0) %>% 
      mutate(Tasa_label = sprintf("%1.2f%%", 100*Tasa_Empleo))
  
     a <- ggplot(Composicion_Tasa_Empleo, aes_string("Periodo", "Tasa_Empleo", fill = Categoria_Elegida, 
                                                     label = "Tasa_label"))+
       geom_bar(stat = "identity", position = "stack")+
       #    geom_col(position = "stack", alpha=0.6) + 
       geom_text(position = position_stack(vjust = 0.5), size=3,angle = 90)+
       labs(x="Trimestre",y=paste0("Composicion de Tasa de empleo por ",Categoria_Elegida))+
       theme_tufte()+
       #scale_fill_fivethirtyeight()+
       scale_y_continuous(labels = percent)+
       theme(legend.position = "bottom",
             legend.title=element_blank(),
             axis.text.x = element_text(angle=0))  
    
     ggplotly(a)
  })
          
  output$plot2 <- renderPlotly({
    
    Categoria_Elegida_Desocup <- input$Categoria_Desocup 
    Periodo_Elegido <- input$Periodo   
    Tasa_Elegida <- input$Tasa 
    Aglo_Elegido_Desempleo <- input$Aglomerado_Desempleo
    
    
    Bases2 <- Bases   
    if(input$Aglomerado_Desempleo!="Total Pais"){
      
      Bases2 <- Bases %>% 
        filter(Nom_Aglo == Aglo_Elegido_Desempleo)
    }
    
    
    Composicion_TasaDesocup_Nac <- Bases2 %>% 
      # filter(Ventana  %in%  c(NA,Periodo_Elegido)) %>% 
      #mutate(Periodo = paste0(TRIMESTRE, "T", ANO4)) %>%
      group_by(Periodo) %>%
      mutate(PEA = sum(PONDERA[ESTADO==1 |ESTADO==2],na.rm =TRUE)) %>% 
      group_by_("Periodo",Categoria_Elegida_Desocup) %>% 
      summarise(Tasa_Desocup = sum(PONDERA[ESTADO==2],na.rm =TRUE)/unique(PEA)) %>% 
      filter(Tasa_Desocup != 0) %>% 
      mutate(Tasa_label = sprintf("%1.2f%%", 100*Tasa_Desocup))
    
    b <- ggplot(Composicion_TasaDesocup_Nac, aes_string("Periodo", "Tasa_Desocup", fill = Categoria_Elegida_Desocup, 
                                                        label = "Tasa_label"))+
      geom_bar(stat = "identity", position = "stack")+
      #    geom_col(position = "stack", alpha=0.6) + 
      geom_text(position = position_stack(vjust = 0.5), size=3,angle = 90)+
      labs(x="Trimestre",y=paste0("Composicion de Tasa de Desocupacion por ",Categoria_Elegida_Desocup))+
      theme_tufte()+
      #scale_fill_fivethirtyeight()+
      scale_y_continuous(labels = percent)+
      theme(legend.position = "bottom",
            legend.title=element_blank(),
            axis.text.x = element_text(angle=0))    
    
    ggplotly(b)
  })
}

shinyApp(ui = ui_PONDERA, server = server_PONDERA)



# #####SHINY TASA DE EMPLEO PARA LOS QUINTILES DE INGRESO TOTAL FAMILIAR#####
# 
# # Define UI for app that draws a histogram 
# ui_PONDIH <- fluidPage(
#   
#   # App title
#   titlePanel("Composicion de la Tasa de Empleo"),
#   
#   # Sidebar layout with input and output definitions 
#   sidebarLayout(
#     
#     # Sidebar panel for inputs 
#     sidebarPanel(
#       
#       
#       
#       radioButtons(inputId = "Categoria", label =  "Elegir Categoria :",
#                    choices = c("Quintil de Ingreso" = "quintil_IFPC"), 
#                    selected = "quintil_IFPC"),
#       
#       radioButtons(inputId = "Periodo", label =  "Elegir Periodo :",
#                    choices = c("Trimestral" = "Trimestral",
#                                "Interanual" = "Interanual"), selected = "Trimestral"),
#       
#       selectizeInput('Aglomerado',
#                      'Aglomerado',
#                      choices = c("Total Pais",unique(Bases$Nom_Aglo)),
#                      selected = "Total Pais",             
#                      multiple = FALSE
#       ) 
#       
#     ),
#     
#     # Main panel for displaying outputs 
#     mainPanel(
#       
#       plotlyOutput(outputId = "plot1")
#     )
#   )
# )
# 
# # Define server logic required to draw a histogram 
# server_PONDIH <- function(input, output) {
#   
#   output$plot1 <- renderPlotly({
#     
#     Categoria_Elegida <- input$Categoria 
#     Periodo_Elegido <- input$Periodo   
#     Tasa_Elegida <- input$Tasa 
#     Aglo_Elegido <- input$Aglomerado
#     
#     if(input$Aglomerado!="Total Pais"){
#       
#       Bases <- Bases %>% 
#         filter(Nom_Aglo == Aglo_Elegido)
#     }
#     
#     
#     Composicion_Tasa_Nac <- Bases %>% 
#       filter(Ventana  %in%  c(NA,Periodo_Elegido)) %>% 
#       mutate(Periodo = paste0(TRIMESTRE, "T", ANO4)) %>%
#       group_by_("Periodo") %>%
#       mutate(Pob_Pondih = sum(PONDIH,na.rm =TRUE)) %>% 
#       group_by_("Periodo",Categoria_Elegida) %>% 
#       summarise(Tasa_Empleo = sum(PONDIH[ESTADO==1],na.rm =TRUE)/unique(Pob_Pondih)) %>% 
#       filter(Tasa_Empleo != 0) %>% 
#       mutate(Tasa_label = sprintf("%1.1f%%", 100*Tasa_Empleo))
#     
#     
#     a <- ggplot(Composicion_Tasa_Nac, aes_string("Periodo", "Tasa_Empleo", fill = Categoria_Elegida, 
#                                                  label = "Tasa_label"))+
#       geom_bar(stat = "identity", position = "stack")+
#       #    geom_col(position = "stack", alpha=0.6) + 
#       geom_text(position = position_stack(vjust = 0.5), size=3,angle = 90)+
#       labs(x="Trimestre",y=paste0("Composicion de Tasa de empleo por ",Categoria_Elegida))+
#       theme_tufte()+
#       #scale_fill_fivethirtyeight()+
#       scale_y_continuous(labels = percent)+
#       theme(legend.position = "bottom",
#             legend.title=element_blank(),
#             axis.text.x = element_text(angle=0))    
#     
#     ggplotly(a)
#     
#   })
# }
# 
# shinyApp(ui = ui_PONDIH, server = server_PONDIH)
# 
# 
# 
# 
# 
# 
# 
# 
# 
# #####ANALISIS TASA DE DESOCUPACION#####
# 
# #####SHINY TASA DE DESOCUPACION POR QUINTIL DE INGRESO PC FAMILIAR#####
# 
# # Define UI for app that draws a histogram
# ui <- fluidPage(
#   
#   # App title 
#   titlePanel("Composición de la Tasa de Desocupación"),
#   
#   # Sidebar layout with input and output definitions
#   sidebarLayout(
#     
#     # Sidebar panel for inputs
#     sidebarPanel(
#       
#       
#       
#       radioButtons(inputId = "Categoria", label =  "Elegir Categoria :",
#                    choices = c("Quintil de Ingreso" = "quintil_IFPC"), 
#                    selected = "quintil_IFPC"),
#       
#       radioButtons(inputId = "Periodo", label =  "Elegir Periodo :",
#                    choices = c("Trimestral" = "Trimestral",
#                                "Interanual" = "Interanual"), selected = "Trimestral")
#       
#       
#     ),
#     
#     # Main panel for displaying outputs 
#     mainPanel(
#       
#       plotlyOutput(outputId = "plot1")
#     )
#   )
# )
# 
# # Define server logic required to draw a histogram 
# server <- function(input, output) {
#   
#   output$plot1 <- renderPlotly({
#     
#     Categoria_Elegida <- input$Categoria 
#     Periodo_Elegido <- input$Periodo   
#     Tasa_Elegida <- input$Tasa 
#     
#     Composicion_TasaDesocup_Nac <- Bases.Desocup %>% 
#       filter(Ventana  %in%  c(NA,Periodo_Elegido)) %>% 
#       mutate(Periodo = paste0(TRIMESTRE, "T", ANO4)) %>%
#       group_by(Periodo) %>%
#       mutate(PEA = sum(PONDERA[ESTADO==1 |ESTADO==2],na.rm =TRUE)) %>% 
#       group_by_("Periodo",Categoria_Elegida) %>% 
#       summarise(Tasa_Desocup = sum(PONDERA[ESTADO==2],na.rm =TRUE)/unique(PEA)) %>% 
#       filter(Tasa_Desocup != 0) %>% 
#       mutate(Tasa_label = sprintf("%1.1f%%", 100*Tasa_Desocup))
#     
#     
#     a <- ggplot(Composicion_TasaDesocup_Nac, aes_string("Periodo", "Tasa_Desocup", fill = Categoria_Elegida, 
#                                                         label = "Tasa_label"))+
#       geom_bar(stat = "identity", position = "stack")+
#       #    geom_col(position = "stack", alpha=0.6) + 
#       geom_text(position = position_stack(vjust = 0.5), size=3,angle = 90)+
#       labs(x="",y=paste0("Composicion de Tasa de desocupación por ",Categoria_Elegida))+
#       theme_tufte()+
#       #scale_fill_fivethirtyeight()+
#       scale_y_continuous(labels = percent)+
#       theme(legend.position = "bottom",
#             legend.title=element_blank(),
#             axis.text.x = element_text(angle=0))    
#     
#     ggplotly(a)
#     
#   })
# }
# 
# shinyApp(ui = ui, server = server)
# 
# 
# 
