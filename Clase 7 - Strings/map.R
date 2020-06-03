library(tm)
library(tidyverse)
letras.mayusc <- LETTERS[1:20]
letras.minusc <- letters[1:20]
numeros <- 1:20

map(letras.mayusc,tolower)

map2(letras,numeros,paste)

map(letras,paste,numeros)

