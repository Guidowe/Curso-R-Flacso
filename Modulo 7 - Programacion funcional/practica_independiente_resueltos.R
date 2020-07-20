#' ---
#' title: Programacion Funcional
#' output:
#'   html_notebook:
#'     toc: yes
#'     toc_float: yes
#' date: ""
#' subtitle: Práctica independiente
#' ---
#' 
#' ### definición de funciones
#' 
#' Crear una **función** llamada _HolaMundo_ que imprima el texto "Hola mundo"
#' 
## ---------------------------------------------------------------------------------



#' 
#' Crear una **función** que devuelva la sumatoria de los números enteros comprendidos entre 1 y un parámetro _x_ a definir.
## ---------------------------------------------------------------------------------




#' 
#' Crear una **función** que dado un parametro _vector_:
#' 
#' - Imprima (**print()**) la media del vector
#' - Devuelva (**return()**) el ratio entre el máximo y mínimo valor de un vector
#' - Garantizar que la función sólo opere en caso de que todos los valores del vector índicado sean números positivos.
#' 
## ---------------------------------------------------------------------------------


#' 
#' 
#' ### Ejercicios sobre purrr
#' `mtcars` es una base de juguete que viene con rbase
## ---------------------------------------------------------------------------------
mtcars

#' 
#' __Ej 1__ Para cada columna de mtcars, calcular la media. Devolver una lista
#' 
## ---------------------------------------------------------------------------------
map(mtcars,mean)

#' 
#' __Ej 2__ Hacer lo mismo que en 1, pero devolver un vector nombrado
#' 
## ---------------------------------------------------------------------------------
vector<- unlist(map(mtcars,mean))
vector

#' 
#' __Ej 3__ Calcular la media, pero podando el 5% de los valores más altos y bajos. Pista: Tirar el `?mean` para ver si tiene un parametro que permite hacer la poda.
#' 
## ---------------------------------------------------------------------------------
?mean
map(mtcars,mean,trim = 0.05)


#' 
#' __Ej 4__ 
#' 0 - Hacer un gráfico de puntos tomando el dataset *mtcars*, para ver la relación entre los valores de las variables disp y mpg 
## ---------------------------------------------------------------------------------
  ggplot(mtcars, aes(disp, mpg))+
    geom_point()

#' 
#' 1 - Crear un dataframe *mtcars_cyl_6* que conserve solo los casos donde `cyl == 6`
## ---------------------------------------------------------------------------------
mtcars_cyl_6 <- mtcars %>%
  filter(cyl == 6)

#' 
#' 2 - Hacer una función que:
#' 
#'  - Tome como imputs un set de datos y un parámetro denominado "titulo"
#'  - Entregue como output un gráfico de puntos con la relación entre las variables disp y mpg, titulado en base al parámetro titulo
#' 
## ---------------------------------------------------------------------------------
# definimos la función
graficar_disp_mpg <- function(data,titulo ="Agregame un titulo"){
  
  ggplot(data, aes(disp, mpg))+
    geom_point()+
    labs(title = titulo)
}

#' 
#' 3 - Probar esta función con el dataset  **mtcars_cyl_6**
## ---------------------------------------------------------------------------------
graficar_disp_mpg(mtcars_cyl_6)
graficar_disp_mpg(mtcars_cyl_6,titulo = "Relacion ente variables mpg y disp")


#' 
#' 4 - Crear un dataframe **mtcars_nest** que agrupe los datos por la variable *cyl*, para luego crear una nueva variable *grafic* que genere este mismo gráfico para cada uno de los valores de cyl.
## ---------------------------------------------------------------------------------
mtcars_nest <- mtcars %>% 
  group_by(cyl) %>% 
  nest() 

mtcars_nest <- mtcars_nest %>% 
  mutate(grafico= map2(.x = data, .y = cyl,.f =  graficar_disp_mpg))

mtcars_nest$grafico[2] #Veo un ejemplo

#' 
#' Exportar a un PDF todos los graficos creados en el paso anterio
#' 
## ---------------------------------------------------------------------------------
pdf('Resultados/mtcars.pdf')
mtcars_nest$grafico
dev.off()

#' 
