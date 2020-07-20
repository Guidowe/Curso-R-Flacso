> Docentes: Pablo Tiscornia y Guido Weksler.

# Materiales de cursada
Los materiales para la cursada se encuentran estructurados por módulos. En esta página encontrarán en cada módulo un botón de descarga de los contenidos. 
A ello se le suma un conjunto de fuentes comunes que se utilizaran en varias clases. Pueden optar por descargar todos los materiales antes de iniciar el curso con el botón de __Download.zip__ que figura arriba. En ese caso, les avisaremos si durante el transcurso del curso actualizamos algún módulo en particular para que lo descarguen nuevamente. 

### Fuentes comunes
[![](img/Download.png)](Fuentes.rar)

#### Librerias a instalar
A lo largo del curso se utilizarán librerías complemetarias al lenguaje RBase. Con la siguiente línea de código se pueden instalar las principales de ellas:
```
install.packages(c("tidyverse","openxlsx",'ggplot2','ggthemes', 'ggrepel','ggalt','kableExtra','GGally','ggridges','fs','purrr','rmarkdown','esquisse','eph','treemapify','gapminder','viridis'))
```


### Presentación
En los últimos años se han difundido muchas herramientas estadísticas novedosas para el análisis de información socioeconómica. En particular el software denominado "R", por tratarse de un software libre, se extiende cada vez más en diferentes disciplinas y recibe el aporte de investigadores e investigadoras en todo el mundo, multiplicando sistemáticamente sus capacidades.
  
Este programa se destaca, entre varias cosas, por su capacidad de trabajar con grandes volúmenes de información, utilizar múltiples bases de datos en simultáneo,  generar reportes, realizar gráficos a nivel de publicación y por su comunidad de usuarios y usuarias  que publican sus sintaxis y comparten sus problemas, hecho que potencia la capacidad de consulta y de crecimiento. A su vez, la expresividad del lenguaje permite diseñar funciones específicas que permiten optimizar de forma personalizada el trabajo cotidiano con R. 

*** 
  
### Objetivos del curso
El presente Taller tiene como objetivo principal introducirse en el aprendizaje del lenguaje de programación “R” aplicado procesamiento de la Encuesta Permanente de Hogares (EPH) - INDEC. Se apunta a brindar a los y las participantes herramientas prácticas para el procesamiento de datos haciendo énfasis en la producción y el análisis de estadísticas socioeconómicas en pos de abrir puertas para realizar investigaciones propias sobre diversas temáticas relacionadas al mercado de trabajo y las condiciones de vida de la población.
  
La Encuesta Permanente de Hogares será la base de datos de aplicación elegida para el curso, dado que representa un insumo fundamental para realizar estudios sobre el mercado de trabajo y las condiciones de vida de la población. Se hará una introducción a los lineamientos conceptuales principales de la encuesta, en pos de que los y las participantes puedan abordar con datos distintas problemáticas vinculadas al mercado de trabajo y las condiciones de vida de la población.

*** 
  
# Programa

### Módulos y contenidos

__Módulo 1 - Conceptos Principales de EPH:__

[![](img/Download.png)](Modulo%201%20-%20EPH.rar)

+ Temas de clase: 
  + Presentación del curso.
  + Presentación de la Encuesta Permanente de Hogares: Lineamientos conceptuales y metodología
  + Abordaje del marco teórico y analítico de la EPH y sus aplicaciones prácticas.
  + Síntesis del operativo de campo, cobertura y periodicidad de la Encuesta
  + Definiciones de las principales variables de interés a abordar en el curso: Condición de actividad, categoría ocupacional, precariedad y pobreza
  + Metodología usuaria de las Bases de microdatos. Utilización del Diseño de Registro.
  
<br>

__Módulo 2 – R Base:__
 
[![](img/Download.png)](Modulo%202%20-%20R%20Base.rar)

+ Temas de clase:
  + Descripción del programa “R”. Lógica sintáctica del lenguaje y comandos básicos
  + Presentación de la plataforma RStudio para trabajar en “R”
  + Caracteres especiales en “R”
  + Operadores lógicos y aritméticos
  + Definición de Objetos: Valores, Vectores y DataFrames
  + Tipos de variable (numérica, de caracteres, lógicas)
  + Lectura y Escritura de Archivos
  
<br>

__Módulo 3 - Tidyverse__

[![](img/Download.png)](Modulo%203%20-%20Tidyverse.rar)

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

+ Cálculo de los indicadores de pobreza e indigencia por línea de ingresos.
  + Definición de la Canasta Básica Alimentaria y Canasta Básica Total
  + Metodología del cálculo de pobreza por línea (para personas y hogares)
  + Ejercicio de estimación de tasas de Pobreza e Indigencia
  + Ejercicio de estimación de tasas de Pobreza e Indigencia para subgrupos poblacionales (Género, Edad, Regiones)  

<br>

__Módulo 4 - Visualización de la información__  

[![](img/Download.png)](Modulo%204%20-%20Graficos.rar)

+ Temas de clase:
  + Gráficos básicos de R (función “plot”): Comandos para la visualización ágil de la información
  + Gráficos elaborados en R (función “ggplot”): 
    + Gráficos de línea, barras, Boxplots 
    + Extensiones de ggplot

  
<br>

__Módulo 5: Documentación en R. Generación de reportes/informes.__

[![](img/Download.png)](Modulo%205%20-%20Markdown.rar)

+ Temas de clase:
  + Manejo de las extensiones del software “Rmarkdown” y “RNotebook” para elaborar documentos de trabajo, presentaciones interactivas e informes:
    + Opciones para mostrar u ocultar código en los reportes
    + Definición de tamaño, títulos y formato con el cual se despliegan los gráficos y tablas en el informe
    + Caracteres especiales para incluir múltiples recursos en el texto del informe: Links a páginas web, notas al pie, enumeraciones, cambios en el formato de letra (tamaño, negrita, cursiva)
    + Código embebido en el texto para automatización de reportes

<br>

__Módulo 6: Strings__

[![](img/Download.png)](Modulo%206%20-%20Strings.rar)

+ Temas de clase: 
  + Acercamiento a técnicas de text mining:
    + Paquete stringr: Localización, substracción, y reemplazo de patrones en variables strings 
    + Expresiones regulares
    + Corpus de texto, Normalización, Armado de DocumentTermMatrix y Nubes de Palabras
  
<br>

__Modulo 7: Programación Funcional:__

[![](img/Download.png)](Modulo%207%20-%20Programacion%20funcional.rar)

+ Temas de clase: 
  + Acercamiento a técnicas más sofisticadas en R, útiles para automatizar el procesamiento periódico de la información:
    + Estructuras de código condicionales
    + Loops
    + Creación de funciones a medida del usuario
  
<br>

# Bibliografía complementaria

- [Grolemund, G. y Wickham, H. (2019), R para Ciencia de Datos](https://es.r4ds.hadley.nz)

- [Wickham, H. (2016), ggplot2: elegant graphics for data analysis. Springer, 2016. ](https://ggplot2-book.org/)

- [Vázquez Brust, A. (2019), Ciencia de Datos para Gente Sociable](https://bitsandbricks.github.io/ciencia_de_datos_gente_sociable/)
