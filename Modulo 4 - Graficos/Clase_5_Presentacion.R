

## ----libreria, echo=TRUE, warning=FALSE----------------------------------------------
library(tidyverse)
library(questionr) # funciones para facilitar trabajo con encuestas
library(eph)
library(ggthemes)  # funciones para tunear gráficos
library(GGally)


## ------------------------------------------------------------------------------------
base <- get_microdata(year = 2018,
                      trimester = 1,
                      type = "individual") 


## ----echo=TRUE-----------------------------------------------------------------------
class(base$P21)


## ----echo=TRUE-----------------------------------------------------------------------
any(is.na(base$P21))


## ----echo=TRUE-----------------------------------------------------------------------
summary(base$P21)


## ----g1, eval = F, echo = F----------------------------------------------------------
ggplot(data = base) +
  aes(x = P21,
      weights = PONDIIO) +
  geom_histogram()


## ----echo=TRUE-----------------------------------------------------------------------
base <- base %>% 
  filter(P21 > 0 & P21 < 50000)


## ----echo=TRUE-----------------------------------------------------------------------
summary(base$P21)


ggplot(data = base) +
  aes(x = P21,
      weights = PONDIIO) +
  geom_histogram(fill = "salmon",
                 color = "grey")




## ----boxplot, eval = F, echo = F-----------------------------------------------------
ggplot(data = base) +
  aes(x = NIVEL_ED) +
  aes(y = P21) +
  geom_boxplot() +
  aes(group = NIVEL_ED)


## ----echo=TRUE-----------------------------------------------------------------------
class(base$NIVEL_ED)


## ----echo=TRUE-----------------------------------------------------------------------
table(base$NIVEL_ED)


## ----echo=TRUE-----------------------------------------------------------------------
base <- base %>% 
  mutate(NIVEL_ED = factor(NIVEL_ED,
                           levels = c(7,1:6),
                           labels = c("Sin instruccion", "Primaria incompleta", "Primaria completa",
                                      "Secundaria incompleta", "Secundaria completa",
                                      "Sup. incompleto", "Sup. completo")))


## ----echo=TRUE-----------------------------------------------------------------------
table(base$NIVEL_ED)


## ----g3, eval = F, echo = F----------------------------------------------------------
ggplot(data = base) +
  aes(x = NIVEL_ED) +
  aes(y = P21) +
  geom_boxplot() +
  aes(group = NIVEL_ED) +
  aes(fill = NIVEL_ED) +
  theme_minimal() +
  labs(x = "Máximo nivel educativo alcanzado") +
  labs(y = "Ingreso de la ocupación principal") +
  labs(title = "Boxplot del Ingreso de la Ocupación Principal por máximo nivel de estudios alcanzado") +
  labs(caption = "Fuente: Elaboración propia en base a EPH-INDEC") +
  scale_y_continuous(limits = c(0, 50000)) +
  coord_flip()


ggplot(data = base) +
  aes(x = P21,weights = PONDIIO) +
  geom_density() +
  aes(group = NIVEL_ED) +
  aes(color = NIVEL_ED) +
  theme_minimal() +
  labs(x = "Ingreso de la ocupación principal") +
  labs(title = "Ingreso de la Ocupación Principal por máximo nivel de estudios alcanzado") +
  labs(caption = "Fuente: Elaboración propia en base a EPH-INDEC")


base <- base %>% 
  mutate(CH04 = factor(CH04,
                       levels = c(1, 2),
                       labels = c("Varón", "Mujer")))
table(base$CH04)


## ----g5, eval = F, echo = F----------------------------------------------------------
ggplot(data = base) +
  aes(x = P21) +
  geom_density() +
  aes(group = CH04) +
  aes(color = CH04) +
  theme_minimal() +
  labs(x = "Ingreso de la ocupación principal") +
  labs(title = "Ingreso de la Ocupación Principal por Nivel educativo") +
  labs(caption = "Fuente: Elaboración propia en base a EPH-INDEC") +
  facet_wrap(~ NIVEL_ED) +
  scale_x_continuous(limits = c(0, 50000))


## ----echo=TRUE-----------------------------------------------------------------------
base %>% 
  calculate_tabulates(x = "NIVEL_ED",
                      add.totals = "row",
                      add.percentage = "col",
                      weights = "PONDERA")


## ----echo=TRUE-----------------------------------------------------------------------
base %>% 
  calculate_tabulates(x = "NIVEL_ED",
                      y = "CH04",
                      add.totals = "row",
                      add.percentage = "col",
                      weights = "PONDERA")


## ---- include=FALSE------------------------------------------------------------------
base_graf <- base %>%
  select(NIVEL_ED, CH04, PONDERA) %>% 
  group_by(NIVEL_ED) %>%
  summarise(pob_tot = sum(PONDERA),
            pob_varon   = sum(PONDERA[CH04 == "Varón"]),
            pob_mujer   = sum(PONDERA[CH04 == "Mujer"]),
            varon = pob_varon/pob_tot * 100,
            mujer = pob_mujer/pob_tot * 100) %>%
  select(NIVEL_ED, mujer, varon) %>%
  gather(key = sexo, value = valor, 2:3)


base %>%
  select(NIVEL_ED, CH04, PONDERA) %>%
  group_by(NIVEL_ED) %>%
  summarise(pob_tot = sum(PONDERA),
            pob_varon   = sum(PONDERA[CH04 == "Varón"]),
            pob_mujer   = sum(PONDERA[CH04 == "Mujer"]),
            varon = pob_varon/pob_tot * 100,
            mujer = pob_mujer/pob_tot * 100) %>%
  select(NIVEL_ED, mujer, varon) %>%
  gather(key = sexo, value = valor, 2:3)


## ----echo=TRUE, out.width = '55%', fig.align = 'center'------------------------------
ggplot(data = base_graf) +
  aes(x = NIVEL_ED, y = valor, fill = sexo) +
  geom_bar(stat = "identity")+
  coord_flip()


## ----echo=TRUE, out.width = '55%', fig.align = 'center'------------------------------
ggplot(data = base_graf) +
  aes(x = NIVEL_ED, y = valor, fill = sexo) +
  geom_bar(stat = "identity",
           position = position_dodge())+
  coord_flip()


## ----echo=TRUE, out.width = '55%', fig.align = 'center'------------------------------
ggplot(data = base_graf) +
  aes(x = NIVEL_ED, y = valor, fill = sexo) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           color = "black")+
  coord_flip()


## ----echo = TRUE, out.width = '40%', fig.align = 'center'----------------------------
ggplot(data = base_graf) +
  aes(x = NIVEL_ED, y = valor, fill = sexo) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           color = "black") +
  labs(title = "Máximo nivel de intrucción alcanzado por sexo",
       x = "Máximo nivel de instrucción alcanzado",
       y = "Porcentaje",
       caption = "Fuente: EPH - INDEC. Total Aglomerados, 1 trimestre de 2018.") +
  coord_flip()


## ----base, echo=TRUE, warning=FALSE--------------------------------------------------
bases2018 <- get_microdata(year = 2018,
                      trimester = 1:4,
                      type = "individual") 

 


bases2018.apiladas <- bases2018 %>%
    select(microdata) %>%
    unnest(cols = c(microdata))

nrow(bases2018.apiladas)



base.ingresos.prom <- bases2018.apiladas %>% 
  filter(P21>0) %>% 
  mutate(CH04 = factor(CH04,levels = c(1, 2),labels = c("Varón", "Mujer"))) %>%
  group_by(ANO4,TRIMESTRE,CH04) %>% 
  summarise(ingreso.promedio=weighted.mean(P21,PONDIIO)) 



base.ingresos.prom %>%
ggplot() +
  aes(x = TRIMESTRE,
      y = ingreso.promedio,
      group = CH04,
      color = CH04) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  labs(x = "Trimestre") +
  labs(y = "Ingreso de la ocupación principal") +
  labs(title = "Ingreso de la Ocupación Principal promedio por Sexo. Año 2018") +
  labs(caption = "Fuente: Elaboración propia en base a EPH-INDEC")


base %>%
  select(P21,EDAD = CH06,SEXO = CH04,NIVEL_ED) %>%
ggpairs(mapping = aes(color = SEXO))+
  theme(axis.text.x = element_text(angle = 45))

