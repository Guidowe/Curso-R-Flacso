# Reiniciar


# cargamos las librerias
library(tidyverse)
library(purrr)
library(fs)

# Loops
for(i in 1:10){
  print(i^2)
}

for(Valores in 1:10){
  print(Valores^2)
  
}



# Estructuras Condicionales

##if
if( 2+2 == 4){
  print("Menos Mal")
}

if( 2+2 == 148.24){
  print("R, tenemos un problema")
}


##ifelse
if_else(2+2==4, true = "Joya",false = "Error")

# Funciones

## funcion suma

suma <- function(valor1, valor2) {
  valor1+valor2
}

suma(5,6)

## funcion con strings
funcion_prueba <- function(parametro1,parametro2) {
  paste(parametro1, parametro2, sep = " <--> ")
}

funcion_prueba(parametro1 = "A ver", parametro2 = "Que pasa")

Otra_funcion_prueba <- function(parametro1 ,parametro2 = "String default") {
  paste(parametro1, parametro2, sep = " <--> ")
  
}

Otra_funcion_prueba(parametro1 = "Valor 1 ")

##### map ####

# armamos un pequeño dataframe de juguete

ABC_123 <- data.frame(Letras = LETTERS[1:20],Num = 1:20)

#recordemos la funcion_prueba
funcion_prueba

#mapeamos el DF en la funcion prueba
resultado <- map2(ABC_123$Letras,ABC_123$Num,funcion_prueba)
resultado[1:3]

#enmarcado en el DF

ABC_123 %>% 
  mutate(resultado= map2(Letras,Num,funcion_prueba))

#unlist

resultado[1:3] %>% unlist()

ABC_123 %>% 
  mutate(resultado= unlist(map2(Letras,Num,funcion_prueba)))

#iterando uno solo de los parametros
map(ABC_123$Letras,funcion_prueba,ABC_123$Num)[1:2]

ABC_123 %>% 
  mutate(resultado= map(Letras,funcion_prueba,Num))


## Iterando en la EPH

# creamos el vector de paths
bases_individuales_path <- dir_ls(path = 'Fuentes/', regexp= 'individual')
bases_individuales_path

#armamos una funcion
leer_base_eph <- function(path) {
  read.table(path,sep=";", dec=",", header = TRUE, fill = TRUE) %>% 
    select(ANO4,TRIMESTRE,REGION,P21,CH04, CH06)
}

# leemos todas las bases
bases_df <- tibble(bases_individuales_path) %>%
  mutate(base = map(bases_individuales_path, leer_base_eph))

bases_df

#las juntamos
bases_df <- bases_df %>% unnest()
bases_df

# anidamos por region
bases_df %>% 
  group_by(REGION) %>% 
  nest()

## Ejemplo. Regresion lineal

lmfit <- lm(P21~factor(CH04)+CH06,data = bases_df)

summary(lmfit)

broom::tidy(lmfit)

### Loopeando

resultados <- tibble()

for (region in unique(bases_df$REGION)) {
  
  data <- bases_df %>% 
    filter(REGION==region)
  
  lmfit <- lm(P21~factor(CH04)+CH06,data = data)
  
  lmtidy <- broom::tidy(lmfit)
  lmtidy$region <- region
  resultados <- bind_rows(resultados,lmtidy)
  
}

resultados

### Usando MAP

#nos armamos una funcion
fun<-function(porcion,grupo) {  broom::tidy(lm(P21~factor(CH04)+CH06,data = porcion))}


bases_df_lm <- bases_df %>% 
  group_by(REGION) %>% #agrupamos
  nest() %>% # anidamos el dataset
  mutate(lm = map(data,fun)) # corremos nuestra funcion para cada grupo

bases_df_lm

bases_df_lm %>%  
  unnest(lm) #juntamos todo

# con el atajo de group_modify
bases_df %>% 
  group_by(REGION) %>% 
  group_modify(fun)

# armamos una funcion que devuelve la regresion lineal entrenada
fun<-function(porcion,grupo) {lm(P21~factor(CH04)+CH06,data = porcion)}

bases_df %>% 
  group_by(REGION) %>%
  nest() %>%  
  mutate(lm = map(data,fun)) #ejecutamos la nueva funcion

map2(ABC_123$Letras,ABC_123$Num,funcion_prueba)[1:3]

#walk

walk2(ABC_123$Letras,ABC_123$Num,funcion_prueba)

#nueva funcion que imprime en consola
imprimir_salida <- function(x,y){
  print(funcion_prueba(x,y))
}

walk2(ABC_123$Letras,ABC_123$Num,imprimir_salida)

# Lectura y escritura de archivos intermedia
## RData

x <- 1:15
y <- list(a = 1, b = TRUE, c = "oops")

#Para guardar

save(x, y, file = "Clase 8 - Programacion funcional/xy.RData")

#Para leer
load('/xy.RData')
## __RDS__
x
saveRDS(x, "Clase 8 - Programacion funcional/x.RDS")

Z <- readRDS("Clase 8 - Programacion funcional/x.RDS")
Z
