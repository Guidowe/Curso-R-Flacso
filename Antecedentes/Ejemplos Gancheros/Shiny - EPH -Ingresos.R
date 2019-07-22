rm(list=ls())

source("G:/Programas/Guias R/Funciones IPC/funciones IPC.R")
library(shiny)
library(shinythemes)
library(plotly)
library(ggjoy)
bases.dir <- "C:/Users/gweks/Desktop/Trabajos/EPH/shiny - EPH/Fuentes/"

#####Variables Individuales
var.ind <- c('CODUSU', 'ANO4','TRIMESTRE','NRO_HOGAR','COMPONENTE','REGION','ESTADO',
             "CAT_OCUP",'AGLOMERADO','PP03J',"INTENSI", 'PONDERA', 'CH04', 'CH06', 'ITF',
             'PONDIH',"P21","P47T","TOT_P12","T_VI")


####Levanto Bases####
Individual_t117 <- read.table(paste0(bases.dir,"usu_individual_t117.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE) %>%
    select(var.ind)

Individual_t216 <- read.table(paste0(bases.dir,"usu_individual_t216.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE) %>%
  select(var.ind)

Individual_t316 <- read.table(paste0(bases.dir,"usu_individual_t316.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE)%>%
  select(var.ind)

Individual_t416 <- read.table(paste0(bases.dir,"usu_individual_t416.txt"),
                              sep=";", dec=",", header = TRUE, fill = TRUE) %>%
  select(var.ind)

dic.regiones <- read_excel(paste0(bases.dir,'Regiones.xlsx'))

Bases <- Individual_t117 %>% 
  mutate(Categorias = case_when(ESTADO == 1 & CAT_OCUP == 1 ~ "Patrones",
                                ESTADO == 1 & CAT_OCUP == 2 ~ "Cuenta Propia",
                                ESTADO == 1 & CAT_OCUP == 3 ~ "Asalariados",
                                ESTADO == 1 & CAT_OCUP == 4 ~ "TFSR",
                                ESTADO == 2 ~ "Desocupados",
                                ESTADO  %in%  c(3,4) ~ "Inact y Menores",
                                TRUE ~ "OTROS"
                                ),
         Categorias = str_wrap(Categorias,width = 20),
         Trimestre = paste0("Trim_",ANO4,"_",TRIMESTRE),
         Identificador = paste0(CODUSU," - ", NRO_HOGAR," - ", COMPONENTE)) %>% 
  left_join(dic.regiones)


#####Levanto fuentes secundarias####
# Adequi <- read_excel(paste0(bases.dir,"ADEQUI.xls"))
# CBA <- read_excel(paste0(bases.dir,"CANASTAS.xlsx"),sheet = "CBA")
# CBT <- read_excel(paste0(bases.dir,"CANASTAS.xlsx"),sheet = "CBT")


###### Promedio trimestral de Canastas ######


###### SHINY ######
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Shiny EPH"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      # sliderInput(inputId = "Edad",label =  "rango:",
      #             min = -1, max = 110, value = c(18,65), step = 1),
      # 
      radioButtons(inputId = "Region", label =  "Región:",
                         choices = c("Todas"    = "Todas",
                                     "Pampeana" ="Pampeana",
                                     "Noreste"  = "Noreste",
                                     "Patagonia"= "Patagonia",
                                     "Cuyo"     = "Cuyo",
                                     "Noroeste" ="Noroeste",
                                     "GBA"      = "GBA"), selected = "GBA"),
      
      radioButtons(inputId = "Serie", label =  "Serie:",
                   choices = c('Ingreso Ocup Ppal'  = "P21",
                               "Ingreso total Indiv" = "P47T",
                               "Ingreso otras ocup" = "TOT_P12",
                               "Ingreso no laboral" = "T_VI",
                               'Ingreso Total Familiar' = "ITF" 
                               ),
                   selected = "P21")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: incidencias ----
      plotlyOutput(outputId = "plot1")
      # Output: kernel ----
      #plotlyOutput(outputId = "plot2")
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  output$plot1 <- renderPlotly({
   
    Basegraf <- Bases
    
    in_Region <- input$Region
    in_Serie <- input$Serie
     
    if(in_Region != "Todas"){
    Basegraf <- Basegraf %>% 
      filter(Region == in_Region)}
    
    Basegraf <- Basegraf %>% select_("Serie" = in_Serie,
                              "Categorias",
                              "CODUSU",
                              "Identificador",
                              "Trimestre") %>% 
      filter(Serie>0)
       Trim <- unique(Basegraf$Trimestre)

        a <- ggplot(Basegraf,aes(x=Categorias,
                                  y = Serie,
                                  color = Categorias,
                                  #group = Categorias,
                                  label= Identificador))+
      #facet_wrap(~ Trimestre,ncol = 2,scales = "free")+
      labs(x= " ", y = " ",
           title = paste0(in_Region," - ","Variable: ",in_Serie),
           subtitle = Trim)+
      geom_boxplot(alpha = 0.6)+
      geom_point(alpha = 0.5)+
      theme_tufte()+
      theme(panel.grid.minor.y = element_line(color = "grey90"),
            panel.grid.major.y = element_line(color = "grey80"),
            legend.position = "none",
            axis.text.x =  element_text())+
      scale_y_continuous(labels = scales::comma)
   
     ggplotly(a)

  })
 
  
}


graficos <- shinyApp(ui = ui, server = server)
runApp(graficos)

