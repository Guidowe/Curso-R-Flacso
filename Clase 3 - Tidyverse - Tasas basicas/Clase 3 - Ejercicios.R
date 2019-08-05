library(tidyverse)
library(openxlsx)

Individual_t117 <-
  read.table(
    paste0("Fuentes/usu_individual_t117.txt"),
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

### - Crear un vector que contenga los nombres de las siguientes variables de interés para realizar algunos ejercicios:
### Edad, Sexo, Ingreso de la ocupación principal, Categoría ocupacional, ESTADO, PONDERA y PONDIH
Variables <- c("ANO4","TRIMESTRE","CH04","CH06","P21","ESTADO","CAT_OCUP","PONDERA","PONDIH")

### - Acotar la Base únicamente a las variables de interés 

Individual_t117_acotada <- Individual_t117 %>% 
  select(Variables)

### Calcular las tasas de actividad, empleo y desempleo según sexo, para jóvenes entre 18 y 35 años
Tasas_ej_1 <- Individual_t117_acotada %>% 
  filter(CH06 >= 18  & CH06<= 35) %>% 
  group_by(CH04) %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA) %>% 
  select(-c(2:5)) %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Varón",
                          CH04 == 2 ~ "Mujer"))

###Calcular el salario promedio por sexo, para dos grupos de edad: 18 a 35 años y 36 a 70 años.
###Recordatorio: La base debe filtrarse para contener únicamente OCUPADOS ASALARIADOS
Tasas_ej_2 <- Individual_t117_acotada %>% 
  mutate(GruposEdad = case_when(CH06 %in% (18:35) ~ "18a35",
                                CH06 %in% (36:70) ~ "36a70")) %>% 
  filter(ESTADO == 1, CAT_OCUP ==3, GruposEdad %in% c("18a35","36a70")) %>% 
  group_by(GruposEdad,CH04) %>% 
  summarise(Salario_Medio = weighted.mean(P21,w = PONDIH)) %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Varón",
                          CH04 == 2 ~ "Mujer"))



###Grabar los resultados en un excel (Creando un objeto que contenga el directorio a utilizar).
Lista_a_exportar <- list("Tasas_Jovenes"= Tasas_ej_1,
                         "Salario_Grupos_Edad"= Tasas_ej_2)

openxlsx::write.xlsx(x = Lista_a_exportar,
                     file = "Resultados/Ejercicios_clase_3.xlsx")
