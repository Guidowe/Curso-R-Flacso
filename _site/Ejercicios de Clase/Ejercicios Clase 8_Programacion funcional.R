#Reiniciar R

library(tidyverse)
library(purrr)


# Crear una **función** llamada _HolaMundo_ que imprima el texto "Hola mundo"

HolaM <- function(){
  print("Hola mundo")
}

HolaM()

# - Crear una **función** que devuelva la sumatoria de los números enteros comprendidos entre 1 y un parámetro _x_ a definir.

Sumatoria_enteros <- function(x){
  Vector <- 1:x
  return(sum(Vector))
}

Sumatoria_enteros(x = 10)

# - Levantar la base Individual del 4to trimestre de 2016

individual_t416 <- read.table("Fuentes/usu_individual_t416.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE)

# - Guardar la base Individual del 4to trimestre de 2016 como un archivo de extensión .RDS
saveRDS(individual_t416,"Resultados/Base_formato_r.RDS")

# - Volver a levantar la base, pero como .RDS y asignarla con el nombre _BaseRDS_ ¿tarda más o menos?
Base_RDS <- readRDS("Resultados/Base_formato_r.RDS")


# - Crear una **función** que calcule la frecuencia expandida por un ponderador a designar


expansion <- function(data){
  
  sum(data['PONDERA'])
}

expansion(individual_t416)



# - Utilizar dicha función para calcular la frecuencia poblaciónal por Sexo y Región



## usando dplyr
individual_t416 %>% 
  group_by(CH04, REGION) %>% 
  summarise(frecuencia_poblacional = sum(PONDERA))

# usando purrr
individual_t416 %>% 
  group_by(CH04, REGION) %>% 
  nest() %>% 
  mutate(frecuencia_poblacional=unlist(map(data,expansion)))



# - Modificar la función anterior para que devuelva un vector con la frecuencia muestra **y** la frecuencia poblacional

expansion <- function(data){
  
  tibble('frecuencia_poblacional'=sum(data['PONDERA']),'frecuencia_muestral'=nrow(data))
}

expansion(individual_t416)

# - Utilizar la función modificada para calcular la frecuencias frecuencias muestrales y poblacionales por Sexo y Región
# usando purrr
individual_t416 %>% 
  group_by(CH04, REGION) %>% 
  nest() %>% 
  mutate(frecuencias=map(data,expansion)) %>% 
  unnest(frecuencias) #abrimos el dataframe resultante


