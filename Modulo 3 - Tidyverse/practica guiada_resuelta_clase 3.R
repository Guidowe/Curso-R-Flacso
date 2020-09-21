Individual_t117 <-
  read.table("Fuentes/usu_individual_t117.txt",
             sep = ";",
             dec = ",",
             header = TRUE,
             fill = TRUE )

Individual_t416 <-
  read.table("Fuentes/usu_individual_t416.txt",
             sep = ";",
             dec = ",",
             header = TRUE,
             fill = TRUE )

Tasas <- Individual_t117 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            Ocupados_demand   = sum(PONDERA[ESTADO == 1 & PP03J == 1]),
            Suboc_demandante  = sum(PONDERA[ESTADO == 1 & INTENSI == 1 & PP03J == 1]),
            Suboc_no_demand   = sum(PONDERA[ESTADO == 1 & INTENSI == 1 & PP03J %in% c(2, 9)]),
            Subocupados       = Suboc_demandante + Suboc_no_demand,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA,
            'Tasa ocupados demandantes'       = Ocupados_demand/PEA,
            'Tasa Subocupación'               = Subocupados/PEA,
            'Tasa Subocupación demandante'    = Suboc_demandante/PEA,
            'Tasa Subocupación no demandante' = Suboc_no_demand/PEA) %>% 
  select(9:15) %>% 
  pivot_longer(cols = 1:ncol(.),names_to = "Tasa",values_to = "Valor")

Tasas_aglo <- Individual_t117 %>% 
  group_by(AGLOMERADO) %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            Ocupados_demand   = sum(PONDERA[ESTADO == 1 & PP03J == 1]),
            Suboc_demandante  = sum(PONDERA[ESTADO == 1 & INTENSI == 1 & PP03J == 1]),
            Suboc_no_demand   = sum(PONDERA[ESTADO == 1 & INTENSI == 1 & PP03J %in% c(2, 9)]),
            Subocupados       = Suboc_demandante + Suboc_no_demand,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA,
            'Tasa ocupados demandantes'       = Ocupados_demand/PEA,
            'Tasa Subocupación'               = Subocupados/PEA,
            'Tasa Subocupación demandante'    = Suboc_demandante/PEA,
            'Tasa Subocupación no demandante' = Suboc_no_demand/PEA) %>% 
  select(c(1,10:16))


variables_interes <- c("ANO4","TRIMESTRE","ESTADO","PONDERA",
                       "REGION","AGLOMERADO","PP03J","INTENSI")

bases_binded <- bind_rows(Individual_t117 %>% select(variables_interes),
                          Individual_t416 %>% select(variables_interes))

Tasas_aglo_trimestre <- bases_binded %>% 
  group_by(AGLOMERADO,ANO4,TRIMESTRE) %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            Ocupados_demand   = sum(PONDERA[ESTADO == 1 & PP03J == 1]),
            Suboc_demandante  = sum(PONDERA[ESTADO == 1 & INTENSI == 1 & PP03J == 1]),
            Suboc_no_demand   = sum(PONDERA[ESTADO == 1 & INTENSI == 1 & PP03J %in% c(2, 9)]),
            Subocupados       = Suboc_demandante + Suboc_no_demand,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA,
            'Tasa ocupados demandantes'       = Ocupados_demand/PEA,
            'Tasa Subocupación'               = Subocupados/PEA,
            'Tasa Subocupación demandante'    = Suboc_demandante/PEA,
            'Tasa Subocupación no demandante' = Suboc_no_demand/PEA) %>% 
  select(c(1:3,12:ncol(.)))

