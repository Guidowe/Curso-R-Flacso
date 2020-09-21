library(tidyverse)
letras.mayusc <- LETTERS[1:20]
letras.minusc <- letters[1:20]
numeros <- 1:20


map(.x = letras.mayusc,
    .f = tolower)

map2(.x = letras.mayusc,.y = numeros,.f = paste)

pmap(.l = list(letras.mayusc,
            letras.minusc,
            numeros),
     .f = paste)

map(.x = letras.mayusc,.f = paste,numeros)

