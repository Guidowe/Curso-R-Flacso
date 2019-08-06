
# Programa y materiales de cursada

***


> Docentes: Pablo Tiscornia - Guido Weksler - Diego Kozlowski - Natsumi Shokida.


### Presentación
En los últimos años se han difundido muchas herramientas estadísticas novedosas para el análisis de información socioeconómica. En particular el software denominado "R", por tratarse de un software libre, se extiende cada vez más en diferentes disciplinas y recibe el aporte de investigadores e investigadoras en todo el mundo, multiplicando sistemáticamente sus capacidades.
  
Este programa se destaca, entre varias cosas, por su capacidad de trabajar con grandes volúmenes de información, utilizar múltiples bases de datos en simultáneo,  generar reportes, realizar gráficos a nivel de publicación y por su comunidad de usuarios y usuarias  que publican sus sintaxis y comparten sus problemas, hecho que potencia la capacidad de consulta y de crecimiento. A su vez, la expresividad del lenguaje permite diseñar funciones específicas que permiten optimizar de forma personalizada el trabajo cotidiano con R. 

*** 
  
### Objetivos del curso
El presente Taller tiene como objetivo principal introducirse en el aprendizaje del lenguaje de programación “R” aplicado procesamiento de la Encuesta Permanente de Hogares (EPH) - INDEC. Se apunta a brindar a los y las participantes herramientas prácticas para el procesamiento de datos haciendo énfasis en la producción y el análisis de estadísticas socioeconómicas en pos de abrir puertas para realizar investigaciones propias sobre diversas temáticas relacionadas al mercado de trabajo y las condiciones de vida de la población.
  
La Encuesta Permanente de Hogares será la base de datos de aplicación elegida para el curso, dado que representa un insumo fundamental para realizar estudios sobre el mercado de trabajo y las condiciones de vida de la población. Se hará una introducción a los lineamientos conceptuales principales de la encuesta, en pos de que los y las participantes puedan abordar con datos distintas problemáticas vinculadas al mercado de trabajo y las condiciones de vida de la población.

*** 

### Clases y contenido


[Clase 1 - Conceptos Principales de EPH:](https://pablotis.github.io/Presentaciones/index.html#1)
  
+ Temas de clase: 
  + Presentación del curso.
  + Presentación de la Encuesta Permanente de Hogares: Lineamientos conceptuales y metodología
  + Abordaje del marco teórico y analítico de la EPH y sus aplicaciones prácticas.
  + Síntesis del operativo de campo, cobertura y periodicidad de la Encuesta
  + Definiciones de las principales variables de interés a abordar en el curso: Condición de actividad, categoría ocupacional, precariedad y pobreza
  + Metodología usuaria de las Bases de microdatos. Utilización del Diseño de Registro.
  
+ [Ejercicios](https://pablotis.github.io/Presentaciones/index.html#115)

[Clase 2 – Introduciendo a R:](link)
  
+ Temas de clase:
  + Descripción del programa “R”. Lógica sintáctica del lenguaje y comandos básicos
  + Presentación de la plataforma RStudio para trabajar en “R”
  + Caracteres especiales en “R”
  + Operadores lógicos y aritméticos
  + Definición de Objetos: Valores, Vectores y DataFrames
  + Tipos de variable (numérica, de caracteres, lógicas)
  + Lectura y Escritura de Archivos
  
+ [Script](link)
+ [Ejercicios](link)

[Clase 3 – Trabajando con bases de datos y Mercado de Trabajo:](Clase%203%20-%20Tidyverse%20-%20Tasas%20basicas/Clase%203%20-%20Bases%20de%20Datos%20y%20Mercado%20de%20Trabajo.nb.html)
  
+ Temas de clase:
  + Limpieza de Base de datos: Renombrar y recodificar variables, tratamiento de valores faltantes (missing values/ NA´s)
  + Seleccionar variables, ordenar y agrupar la base de datos para realizar cálculos
  + Creación de nuevas variables
  + Aplicar filtros sobre la base de datos
  + Construir medidas de resumen de la información
  + Tratamiento de variables numéricas (edad, ingresos, horas de trabajo, cantidad de hijos / componentes del hogar, entre otras).
  + Ejercicios prácticos para aplicar lo expuesto: Replicar Informe Técnico de Mercado de Trabajo (EPH-INDEC) 
  + Cálculo de tasas básicas del mercado de trabajo (tasa de actividad, empleo, desempleo, entre otras) 
  + Cálculo de tasas para distintos subconjuntos poblacionales (por aglomerado, sexo, grupos de edad)
  
+ [Script](Clase%203%20-%20Tidyverse%20-%20Tasas%20basicas/Clase%203%20-%20Bases%20de%20Datos%20y%20Mercado%20de%20Trabajo.R)
+ [Ejercicios](Clase%203%20-%20Tidyverse%20-%20Tasas%20basicas/Clase%203%20-%20Ejercicios.R)

[Clase 4: Cálculo de tasas de Pobreza e Indigencia.](Clase%204%20-%20Tidyverse%20-%20Pobreza/Clase%204%20-%20Tidyverse%20y%20Pobreza.nb.html)
  
+ Temas de clase:
  + Definición de la Canasta Básica Alimentaria y Canasta Básica Total
  + Metodología del cálculo de pobreza por línea (para personas y hogares)
  + Ejercicio de estimación de tasas de Pobreza e Indigencia
  + Ejercicio de estimación de tasas de Pobreza e Indigencia para subgrupos poblacionales (Género, Edad, Regiones)

+ [Script](Clase%204%20-%20Tidyverse%20-%20Pobreza/Clase%204%20-%20Tidyverse%20y%20Pobreza.R)
+ [Ejercicios](Clase%204%20-%20Tidyverse%20-%20Pobreza/Clase%204%20-%20Ejercicios.R)
  


[Clase 5 - Variables de ingresos y gráficos:](Clase%205%20-%20Graficos%20y%20Distribucion%20del%20Ingreso/Clase%205-%20Graficos%20e%20Ingresos.nb.html)
  
+ Temas de clase:
  + Procesamiento de indicadores agregados sobre las variables de ingresos (Ingresos laborales, no laborales, de ocupación principal, total familiar) 
  + Gráficos básicos de R (función “plot”): Comandos para la visualización ágil de la información
  + Gráficos elaborados en R (función “ggplot”): 
    + Gráficos de línea, barras, Boxplots y distribuciones de densidad
    + Parámetros de los gráficos: Leyendas, ejes, títulos, notas, colores
    + Gráficos con múltiples cruces de variables.

+ [Script](Clase%205%20-%20Graficos%20y%20Distribucion%20del%20Ingreso/Clase%205-%20Graficos%20e%20Ingresos.R)
+ [Ejercicios](Clase%205%20-%20Graficos%20y%20Distribucion%20del%20Ingreso/Ejercicios%20-%20Clase%205.R)


[Clase 6: Pool de Datos en Panel. Gráficos y Matrices de Transición.](Clase%206%20-%20Paneles/Clase%206%20-%20Pool%20de%20Datos%20en%20Panel.nb.html)
  
+ Temas de clase:
  + Metodología de trabajos en panel con EPH: (Esquema de rotación de la EPH, Variables para la identificación de los individuos en distintos períodos, Consistencias)
  + Proceso para la construcción de paneles en R.
  + Cálculo de Frecuencias de transiciones de estados (Categorías Ocupacionales, Situaciones de Pobreza/Indigencia)
  + Gráficos de Transición de estados

+ [Script](Clase%206%20-%20Paneles/Clase%206%20-%20Pool%20de%20Datos%20en%20Panel.R)
+ [Ejercicios](Clase%206%20-%20Paneles/Clase%206%20-%20Ejercicios.R)

[Clase 7: Documentación en R. Generación de reportes/informes.](Clase%207%20-%20Markdown/Clase%207.%20Markdown.nb.html)
  
+ Temas de clase:
  + Manejo de las extensiones del software “Rmarkdown” y “RNotebook” para elaborar documentos de trabajo, presentaciones interactivas e informes:
    + Opciones para mostrar u ocultar código en los reportes
    + Definición de tamaño, títulos y formato con el cual se despliegan los gráficos y tablas en el informe
    + Caracteres especiales para incluir múltiples recursos en el texto del informe: Links a páginas web, notas al pie, enumeraciones, cambios en el formato de letra (tamaño, negrita, cursiva)
    + Código embebido en el texto para automatización de reportes

+ [Markdown](Clase%207%20-%20Markdown/Clase%207.%20Markdown.Rmd)

[Clase 8: Introducción a R Intermedio:](Clase%208%20-%20Programacion%20funcional/Clase_8-Programacion%20funcional.nb.html)

+ Temas de clase: 
  + Acercamiento a técnicas más sofisticadas en R, útiles para automatizar el procesamiento periódico de la información:
    + Estructuras de código condicionales
    + Loops
    + Creación de funciones a medida del usuario
  + Herramientas para continuar el aprendizaje en R: Foros reconocidos de usuarios de R. Comunidades donde se comparten conocimientos, experiencias, consultas. Comandos para acceder a los documentos de ayuda.

+ [Script](Clase%208%20-%20Programacion%20funcional/Clase_8-Programacion%20funcional.R)
+ [Ejercicios](Clase%208%20-%20Programacion%20funcional/Ejercicios%20Clase%208_Programacion%20funcional.R)

[Clase 9: Trabajos prácticos: R en concreto / examen]
  

+ Se presentará a los/as alumnos/as problemas concretos vinculados a la EPH y en relación a las experiencias que se fueron volcando a lo largo de la cursada. Se deberán abordar mediante el uso de R, aplicando lo aprendido en los módulos anteriores. En conjunto se expondrán los desafíos que emergen en el momento y la evaluación de las herramientas adecuadas para su abordaje y resolución. Entre los temas giran aquellos vinculados a la distribución personal del ingreso/Construcción de percentiles de ingreso; el mercado laboral a través de la herramienta Panel de datos; la documentación en R (Estilo de Notas de Clase).
+	Espacio para consultas puntuales sobre los temas vistos durante el curso y presentación del trabajo final a entregar.


#### Librerias a instalar

```
install.packages(c("tidyverse","openxlsx",'ggplot2','ggthemes', 'ggrepel','ggalt','kableExtra','GGally','ggridges','fs','purrr','rmarkdown'))
```
