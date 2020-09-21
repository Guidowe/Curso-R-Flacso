#' ---
#' title:  Manejo de Strings
#' output:
#'   html_notebook:
#'     toc: yes
#'     toc_float: yes
#' date: ""
#' subtitle: Práctica Guiada
#' ---
## ----message=FALSE, warning=FALSE-------------------------------------------------
library(rtweet)
library(tidyverse)
library(tm)
library(stringr)
library(wordcloud2)

#' 
#' ## Cargamos la base de tweets
## ---------------------------------------------------------------------------------
villa_azul_tweets <- readRDS("Modulo 6 - Strings/data/villa_azul_tweets.RDS")

#' 
#' Ejercicio 1: Cuantos caracteres figuran en el tweet más largo de toda la base
## ---------------------------------------------------------------------------------
max(str_length(villa_azul_tweets$text))

#' Ejercicio 2: Mostrar el tweet más largo de toda la base. Pista: La función `top_n` permite filtrar conservando los *n* valores más altos de una variable.
## ---------------------------------------------------------------------------------
maximo <- villa_azul_tweets %>% 
  top_n(str_length(text),n = 1)

maximo$text

#' 
#' Ejercicio 3: Crear objetos que conserven únicamente:
#'  - Los registros cuyos tweets mencionen a Chile
#'  - Los registros cuyos tweets provengan de un dispositivo iPhone o iPad
#'  - Los registros cuyos tweets contengan alguna mención (@)
#' 
## ---------------------------------------------------------------------------------
chile <- villa_azul_tweets %>% 
  filter(str_detect(string = text,pattern = "chile"))

## ---------------------------------------------------------------------------------
tweets.iphone <- villa_azul_tweets %>% 
  filter(str_detect(string = source,pattern = "iP(hone|ad)"))

tweets.con.menciones <- villa_azul_tweets %>% 
  filter(str_detect(string = text,pattern = "@"))

#' Ejercicio 4:
#' Crear una nueva columna en la base denominada *text2* que tome la variable text pero remplace cualquier número del texto por un espacio en blanco
## ---------------------------------------------------------------------------------
v2 <- villa_azul_tweets %>% 
  mutate(text2 = str_replace_all(text,
                                 pattern = "[:digit:]",
                                 replacement = " "))

#' 
#' Ejercicio 5:
#' Crear una lista que separe la variable **name** cada vez que encuentre un espacio (Ej: Que logre separar un nombre como "Andrés Rodriguez") 
## ---------------------------------------------------------------------------------
Nombres <-  str_split(string = villa_azul_tweets$name,
                      pattern = " ")

#' Ejercicio 6: Crear un dataframe que para usuario de twitter (screen_name) exprese: 
#'  - Cuantos tweets realizó
#'  - Cuantos retweets tuvo en total y en promedio
#'  - Cuantos de sus tweets contienen algun #?
#' 
## ---------------------------------------------------------------------------------
tweets.por.cuenta <- villa_azul_tweets %>% 
  group_by(screen_name) %>% 
  summarise(Tweets = n(),
            retweets.total = sum(retweet_count),
            retweets.prom = retweets.total/Tweets,
            hasthags = sum(str_detect(string = text,pattern = "#")))


#' 
