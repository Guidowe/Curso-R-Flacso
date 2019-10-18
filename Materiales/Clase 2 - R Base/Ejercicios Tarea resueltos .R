rm(list=ls())
library(tidyverse)
library(openxlsx)

COSA <- 5*6

VECTOR0 <- c(1,3,4)

VECTOR1 <- VECTOR0*3

VECTOR2 <- VECTOR0*10

VECTOR3 <- VECTOR0*5

DFRAME <- data.frame(VECTOR1, VECTOR2, VECTOR3)

VECTOR4 <- c("Club", "Atlético", "Independiente")

VECTOR5 <- c("Hola", "Que tal", "Como estas")

VECTOR6 <- c("Estoy", "practicando", "R")

DATAF <- data.frame(VECTOR1, VECTOR2, VECTOR3, VECTOR4, VECTOR5, VECTOR6)

T416 <- read.table(paste0("rutafuentes/usu_individual_t416.txt"),header = TRUE, sep = ";")  

HOJACBA <- read.xlsx(xlsxFile= "rutafuentes/CANASTAS.xlsx"), sheet= "CBA")
