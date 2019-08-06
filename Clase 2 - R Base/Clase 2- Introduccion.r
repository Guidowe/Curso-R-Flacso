rm(list=ls())

# Defino el objeto "A" con el contenido "1".
A <- 1

# Al definir un elemento, el mismo queda guardado en el ambiente del programa, y podrá ser utilizado posteriormente para observar su contenido o para realizar una operación con el mismo
A 
A+6

# Al correr una linea con el nombre del objeto, la consola del programa nos muestra 
# su contenido. Entre Corchetes Observamos el número de orden del elemento en cuestión
# El operador = es equivalente a <-, pero en la práctica no se utiliza 
# para la definición de objetos.   
B = 2
B

# <- es un operador Unidireccional, es decir que:     
A <- B # implica que A va tomar como valor el contenido del objeto B, y no al revés.

A <- B
A   #Ahora A toma el valor de B, y B continua conservando el mismo valor
B

## R base
# Con R base nos referimos a los comandos básicos que vienen incorporados en el R,
# sin necesidad de cargar librerías. 

# Operadores lógicos: 

# $>$
# $>=$
# $<$
# $<=$
# $==$
# $!=$
  
#Redefinimos los valores A y B
A <-  10
B  <-  20

#Realizamos comparaciones lógicas
A >  B
A >= B
A <  B
A <= B
A == B
A != B

C <- A != B
C

# Como muestra el último ejemplo, el resultado de una operación lógica puede 
# almacenarse como el valor de un objeto.

## Operadores aritméticos:

#suma
A <- 5+6
A
#Resta
B <- 6-8
B
#cociente
C <- 6/2.5
C
#multiplicacion
D <- 6*2.5
D

## Funciones:
# Las funciones son series de procedimientos estandarizados, que toman como imput 
# determinados argumentos a fijar por el usuario, y devuelven un resultado acorde 
# a la aplicación de dichos procedimientos. Su lógica de funcionamiento es:   
#  funcion(argumento1 = arg1, argumento2 = arg2)      

# A lo largo del curso iremos viendo numerosas funciones, según lo requieran los 
# distintos ejercicios. Sin embargo, veamos ahora algunos ejemplos para comprender 
# su funcionamiento:    
  
# paste() : concatena una serie de caracteres, indicando por última instancia como separar a cada uno de ellos        
# paste0(): concatena una serie de caracteres sin separar
# sum(): suma de todos los elementos de un vector   
# mean() promedio aritmético de todos los elementos de un vector   

paste("Pega","estas",4,"palabras", sep = " ")

#Puedo concatenar caracteres almacenados en objetos
paste(A,B,C,sep = "**")

# Paste0 pega los caracteres sin separador
paste0(A,B,C)

1:5

sum(1:5)
mean(1:5,na.rm = TRUE)


## Objetos:    
Valores
- Vectores
- Data Frames
- Listas

### Valores
# Los valores y vectores pueden ser a su vez de distintas clases:
  
# Numeric     
A <-  1
class(A)

# Character
A <-  paste('Soy', 'una', 'concatenación', 'de', 'caracteres', sep = " ")
A
class(A)

# Factor
A <- factor("Soy un factor, con niveles fijos")
class(A)

### Vectores
# Para crear un vector utilizamos el comando c(), de combinar.
C <- c(1, 3, 4)
C

C <- C + 2
C

D <- C + 1:3 #esto es equivalente a hacer 3+1, 5+2, 6+9 
D

#crear un vector que contenga las palabras: "Carlos","Federico","Pedro"
E <- c("Carlos","Federico","Pedro")
E

E[2]

elemento2 <-  E[2]
elemento2

rm(elemento2)
elemento2

E[2] <- "Pablo"
E

### Data Frames
INDICE  <- c(100,   100,   100,
             101.8, 101.2, 100.73,
             102.9, 102.4, 103.2)

FECHA  <-  c("Oct-16", "Oct-16", "Oct-16",
             "Nov-16", "Nov-16", "Nov-16",
             "Dic-16", "Dic-16", "Dic-16")


GRUPO  <-  c("Privado_Registrado","Público","Privado_No_Registrado",
             "Privado_Registrado","Público","Privado_No_Registrado",
             "Privado_Registrado","Público","Privado_No_Registrado")


Datos <- data.frame(INDICE, FECHA, GRUPO)
Datos


Datos$FECHA
Datos[3,2]
Datos$FECHA[3]
Datos$FECHA[3,2]

Datos[Datos$FECHA=="Dic-16",]

###Por separado
Indices_Dic <- Datos$INDICE[Datos$FECHA=="Dic-16"]
Indices_Dic

mean(Indices_Dic)

### Todo junto
mean(Datos$INDICE[Datos$FECHA=="Dic-16"])

### Listas
superlista <- list(A,B,C,D,E,FECHA, DF = Datos, INDICE, GRUPO)
superlista

superlista$DF$FECHA[2]

# Instalación de paquetes complementarios al R Base          
install.packages("nombre_del_paquete") 
library(nombre_del_paquete)

# Lectura y escritura de archivos
## .csv  y  .txt
dataframe <- read.delim(file, header = TRUE, sep = "\t", quote = "\"", dec = ".", fill = TRUE, comment.char = "", ...) 

individual_t117 <- read.table(file = '../Fuentes/usu_individual_t117.txt',sep=";", dec=",", header = TRUE, fill = TRUE)
individual_t117

#View(individual_t117)
names(individual_t117)
summary(individual_t117)[,c(8,10,31,133)]
head(individual_t117)[,1:5]

## Excel 
# install.packages("openxlsx") # por única vez
library(openxlsx) #activamos la librería

#creamos una tabla cualquiera de prueba
x <- 1:10
y <- 11:20
tabla_de_R <- data.frame(x,y)

# escribimos el archivo
write.xlsx( x = tabla_de_R, file = "archivo.xlsx",row.names = FALSE)

#getwd()

#Si queremos exportar multiples dataframes a un Excel, debemos armar previamente una lista de ellos. Cada dataframe, se guardará en una pestaña de excel, cuyo nombre correspondera al que definamos para cada Dataframe a la hora de crear la lista.
Lista_a_exportar <- list("Indices Salarios" = Datos,
                         "Tabla Numeros" = tabla_de_R)

write.xlsx( x = Lista_a_exportar, file = "archivo_2_hojas.xlsx",row.names = FALSE)

#leemos el archivo especificando la ruta (o el directorio por default) y el nombre de la hoja que contiene los datos
Indices_Salario <- read.xlsx(xlsxFile = "archivo_2_hojas.xlsx",sheet = "Indices Salarios")
#alternativamente podemos especificar el número de orden de la hoja que deseamos levantar
Indices_Salario <- read.xlsx(xlsxFile = "archivo_2_hojas.xlsx",sheet = 1)
Indices_Salario

# Paquetes a utilizar a lo largo del curso:
install.packages(c("tidyverse","openxlsx",'ggplot2','ggthemes', 'ggrepel','ggalt','kableExtra'))

