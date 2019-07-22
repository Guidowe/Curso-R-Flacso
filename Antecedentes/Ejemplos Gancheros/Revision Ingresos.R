rm(list=ls())
gc()
sum_na=function(x){
  ifelse(all(is.na(x)),NA,sum(x,na.rm=T))
}
library(xlsx)
library(readxl)
library(shiny)
library(shinythemes)
library(plotly)
#library(ggjoy)
library(tidyverse)
library(ggplot2)
library(ggthemes)  
library(ggrepel)   
library(scales)
library(statar)
library(outliers)
library(DT)

script.dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
bases.dir <-paste0(dirname(script.dir),"/Fuentes/")
resultados.dir<-paste0(dirname(script.dir),"/Resultados/")

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

options(scipen = 999)
##ELEJIR VARIABLES para EPH continua###
Bases_Continua <- data.frame()
Variables_Continua <- c("CODUSU","ANO4","TRIMESTRE","AGLOMERADO","REGION" ,"H15","NRO_HOGAR","COMPONENTE","CH03",
                        "CH04", "CH06", "CH12","ESTADO","CAT_OCUP","CAT_INAC","PP02E","PP02I", "INTENSI",
                        "PP04A", "PP04B_COD","PP07H", "PP10A","PP11L","PP11L1","PP11M",
                        "PP11N", "PP11O","P21","PP08J1","PONDERA","PP04D_COD", "PP04C", 
                        "NIVEL_ED","PONDIIO","PP04B3_ANO","PP07E","PP3E_TOT","PP3F_TOT","PP04B3_ANO")

#####Levanto fuentes secundarias####
dic.regiones <- read_excel(paste0(bases.dir,'Regiones.xlsx'))
dic.aglomerados <- read_excel(paste0(bases.dir,'Aglomerados EPH.xlsx'))

####Elijo las Bases que voy a leventar####
Bases_Todas <- list.files(bases.dir)
Bases_Indiv <- Bases_Todas[grep("usu_individual",Bases_Todas)]

####LEVANTO LAS BASES 1617####
for (i in Bases_Indiv) {
  
  ind_nuev <- read.table(paste0(bases.dir,i),sep = ";",dec = ",",header = TRUE)  %>%
    select(Variables_Continua)
  ind_nuev$PP04B_COD <- as.integer(paste(ind_nuev$PP04B_COD))
  Bases_Continua <- bind_rows(Bases_Continua,ind_nuev)
  print(unique(ind_nuev[,c("ANO4","TRIMESTRE")]))
  rm(ind_nuev)
  gc()
}

CreaPanel_Continua <- function(Periodo = "Anual"){
  
  Bases_Continua <<- Bases_Continua  %>% 
    mutate(Sector = case_when(ESTADO == 1 & CAT_OCUP==3 & PP04A!=1  & PP07H==1 ~"Asal. Priv. No Precarios",
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
           Trimestre = paste(ANO4, TRIMESTRE, sep="_"),
           Tamano_estab = case_when(PP04C  <=7       ~ "1a25",
                                    PP04C %in% 8:9   ~ "26a100",
                                    PP04C %in% 10:13 ~ "mas_100"),
           ING_hora = P21/30*7/PP3E_TOT) %>%
    arrange(Trimestre) %>% 
    mutate(Id_Trimestre = match(Trimestre,unique(Trimestre)))
  
  
  
  ##Creo una Replica de la base, y le agrego (_t1) al nombre de cada 
  ##variable, excepto a las que voy a usar para "matchear".
  
  Bases_Continua_join <- Bases_Continua
  names(Bases_Continua_join)[!(names(Bases_Continua_join) %in% 
                                 c("CODUSU","COMPONENTE","NRO_HOGAR","Id_Trimestre"))] <- paste0(names(Bases_Continua_join)[
                                   !(names(Bases_Continua_join) %in% 
                                       c("CODUSU","COMPONENTE","NRO_HOGAR","Id_Trimestre"))],"_t1")
  
  ##En Base a la amplitud del panel que especificaré al correr en la funcion resto en la Base 
  ##Replica el identificador de Trimestre construido, para hacer un join  con la Base.
  t <- case_when(Periodo == "Anual"      ~ 4,
                 Periodo == "3trim"      ~ 3,
                 Periodo == "Consecutivo"~ 1)
  
  Bases_Continua_join$Id_Trimestre <- Bases_Continua_join$Id_Trimestre - t
  
  Panel_Continua <- inner_join(Bases_Continua,Bases_Continua_join) %>% 
    mutate(Consistencia = case_when(abs(CH06_t1-CH06) > 2 | 
                                      CH04 != CH04_t1 ~ FALSE,
                                    TRUE ~ TRUE))
  
  Consistencias_Continua <<- Panel_Continua %>%
    group_by(Trimestre) %>% 
    summarise(Sin_Controles = n(),
              Con_Controles = sum_na(Consistencia),
              Perdida = 1 - (Con_Controles/Sin_Controles))
  
  
  Panel_Continua <- Panel_Continua %>%
    filter(Consistencia == TRUE)
  
  return(Panel_Continua)
  
}

Panel_Continua_Trimestral   <- CreaPanel_Continua(Periodo = "Consecutivo")

Bases_Continua  <- Bases_Continua %>%
  left_join(dic.regiones)%>%
  left_join(dic.aglomerados)

Analisis_Panel <- Panel_Continua_Trimestral %>% 
  mutate(Relativo_P21 = P21_t1/P21,
         Datos_Persona = paste0 (" \n ",
                            "P21: ",P21," \n ",
                            "P21_t1: ",P21_t1," \n ",
                            "Cat_ocup: ",CAT_OCUP," \n ",
                            "Categoria: ",Categorias_Ocup," \n ",
                            "Califica: ",Calif_ocup," \n ",
                            "Nivel: ",Educacion," \n ",
                            "Sexo: ",CH04," \n "))

Sugeridos_rev <- Bases_Continua %>% 
  filter(P21>0) %>% 
  group_by(Trimestre,Educacion,Sector) %>% 
  mutate(puntajes = round(scores(P21,type = "chisq" ),digits = 2),
         P21_prom_grupo = weighted.mean(P21,PONDIIO),
         P21_mediana_grupo = median(P21,PONDIIO),
         Tam_muestral = n()) %>%   
  filter(puntajes >  100) %>%
  arrange(desc(puntajes)) %>% 
  select(CODUSU,NRO_HOGAR,COMPONENTE,Nom_Aglo,Parentesco,Trimestre,Educacion,Sector,CH04,CH06,puntajes,Tam_muestral,P21,P21_prom_grupo,P21_mediana_grupo,PONDIIO)


Resumen <- Sugeridos_rev %>% 
  group_by(Trimestre) %>%
 summarise(Casos_muestr = n(),
           Casos_PONDIIO = sum_na(PONDIIO))
  
  
  
######## SHINY ######## 
Interfaz <- fluidPage(
  titlePanel(title = "Revisión Ingresos"),
  tabsetPanel(
    id = 'Display',
    tabPanel("Sugerencias Revision",
             fluidRow(
             column(4,
               selectizeInput(inputId = "Agrupam", label =  "Elegir 2 Agrupamientos:",
                              multiple = TRUE, 
                              choices = c("Sexo" = "Sexo",
                                          "Grupo etario" = "Grupo_etario",
                                          "Nivel educativo" = "Educacion",
                                          "Sector" = "Sector",
                                          "Posición en el hogar"  = "Parentesco",
                                          "Tipo de empleo"  = "Tipo_empleo",
                                          "Calificación ocupacional" = "Calif_ocup",
                                          "Intensidad" = "Intensidad"),
                                          selected = c("Sexo","Tipo_empleo"))
               ),
             column(8,
                    radioButtons(inputId = "Variable_rev", label =  "Variable de Revision:",
                                 choices = c("P21" ="P21",
                                             "ING_hora" = "ING_hora"
                                 ),
                                 selected = "P21")
                    )
             ),
             fluidRow(
               dataTableOutput("table"))),
             
    tabPanel("Segumiento en panel",fluid = TRUE, 
             fluidRow(
               column(4,
                      selectizeInput(inputId = "CODUSU",
                                     label =  "CODUSU",
                                     multiple = FALSE, 
                                     choices = unique(Bases_Continua$CODUSU),
                                     selected = unique(Bases_Continua$CODUSU)[1])
               ),
               column(7,
                      selectizeInput(inputId = "NRO_HOGAR",
                                     label =  "NRO HOGAR",
                                     multiple = FALSE, 
                                     choices = unique(Bases_Continua$NRO_HOGAR))
               ),
               
               column(8,
                      selectizeInput(inputId = "COMPONENTE",
                                     label =  "COMPONENTE",
                                     multiple = FALSE, 
                                     choices = unique(Bases_Continua$COMPONENTE),
                                     selected = unique(Bases_Continua$COMPONENTE)[1])
               )
             ),
             fluidRow(
               dataTableOutput("table_panel")))
  )
)




Servidor <- function(input, output) {
  
  output$table   <- renderDataTable({
    
   
    in_agrup <- input$Agrupam[1]
    in_agrup2 <- input$Agrupam[2]
    in_variable_rev <-  input$Variable_rev

    Sugeridos_rev2 <- Bases_Continua %>% 
      rename_(Variable_seleccionada = in_variable_rev) %>% 
      filter(Variable_seleccionada>0 & is.finite(Variable_seleccionada)) %>% 
      group_by_("Trimestre",in_agrup,in_agrup2) %>% 
      mutate(puntajes = round(scores(Variable_seleccionada,type = "chisq" ),digits = 2),
             Prom_grupo = round(weighted.mean(Variable_seleccionada,PONDIIO),2),
             Mediana_grupo = round(median(Variable_seleccionada,PONDIIO),2),
             Tam_muestral = n(),
             Variable_seleccionada = round(Variable_seleccionada,2)) %>%   
      filter(puntajes >  100) %>%
      arrange(desc(puntajes)) %>% 
      select_(in_agrup,in_agrup2,"puntajes","Variable_seleccionada","Prom_grupo","Mediana_grupo",
              "CODUSU","NRO_HOGAR","COMPONENTE","Nom_Aglo","Parentesco","Trimestre",
              "Educacion","Sector","CH04","CH06","Intensidad","Tam_muestral","PONDIIO")
    
   datatable(Sugeridos_rev2,filter="top",selection="multiple", escape=FALSE)
  }
    )

  output$table_panel   <- renderDataTable({
    
    
    in_COMPONENTE <- input$COMPONENTE
    in_NRO_HOGAR <- input$NRO_HOGAR
    in_CODUSU <-  input$CODUSU
    
    Mirar_Panel <- Bases_Continua %>% 
      filter(COMPONENTE == in_COMPONENTE,NRO_HOGAR == in_NRO_HOGAR,
             CODUSU == in_CODUSU)
      
    datatable(Mirar_Panel,filter="top",selection="multiple", escape=FALSE)
  }
  )
  
  
    
}

shinyApp(
  ui = Interfaz,
  server = Servidor
)

###Pruebas
# Bases_Regresion<- Bases_Continua %>% filter(P21>0,!is.na(Calif_ocup),!is.na(Tipo_empleo),PP3E_TOT>0) %>% 
#   mutate(filas = row.names(.))
# 
# mod <- lm(P21 ~ Calif_ocup + Sector + PP3E_TOT , data=Bases_Regresion)
# cooksd <- cooks.distance(mod)
# 
# plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
# abline(h = 4*mean(cooksd, na.rm=T), col="red")  # add cutoff line
# text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4*mean(cooksd, na.rm=T),names(cooksd),""), col="red")
# 
# influential <- data.frame(cooksd_aa = cooksd[cooksd>3*mean(cooksd, na.rm=T)],
#                           filas = names(cooksd[cooksd>3*mean(cooksd, na.rm=T)]))
# 
# Ver <- Bases_Regresion  %>% 
#   right_join(influential) %>% 
#   select(-P21,everything(),P21)
# 
