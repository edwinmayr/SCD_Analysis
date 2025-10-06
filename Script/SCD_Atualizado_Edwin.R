library(tidyverse)
library(janitor)
library(dplyr)
library(GGally)
library(readxl)
library(ggplot2)
library(reshape2)
library(ggpubr)

Dados_Atualizados <- read_excel("Data/Dados_falciforme_atualizados.xlsx")

Da_selec <- Dados_Atualizados %>% select (ID, Initials, Registry, Sample_date, Birthdate, Group_pt_HI, Age, Sex, Genotype, `Hb F`, LDH, `Bilirrubina total`, VCM, RDW, VPM, Hb, WBC, Seg, Lymph, Mono, Eos, Plat, Retc, `DD hemostasia (ng/mL)`, `FVW:Ag`, `FVW Activity (%)`, TGT_Lagtime, TGT_ETP, TGT_Peak, TGT_tt_Peak, C5, C5a, C9, MBL,`sC5-b9`)

#Here i removed 10 patietns that were collected after and will not be included in the analysis due to lack of data
Da_selec <- Da_selec %>% slice(-(51:61))

#Here i removed empty Values
Da_selec <- Da_selec %>% slice (1:76)

#Just Numeric Values
Da_correl <- Da_selec %>% select(Age, Sex, Genotype, `Hb F`, LDH, `Bilirrubina total`, VCM, RDW, VPM, Hb, WBC, Seg, Lymph, Mono, Eos, Plat, Retc, `DD hemostasia (ng/mL)`, `FVW:Ag`, `FVW Activity (%)`, TGT_Lagtime, TGT_ETP, TGT_Peak, TGT_tt_Peak, C5, C5a, C9, MBL,`sC5-b9`)

Da_correl <- Da_correl %>%
  rename( Hb_F = `Hb F`,
          Bilirrubina_t = `Bilirrubina total`,
          DD_hemo = `DD hemostasia (ng/mL)`,
          FVW_Ag = `FVW:Ag`,
          FVW_At = `FVW Activity (%)`,
          sc5b9 = `sC5-b9`)

#Here i will do a pearson correlation using the GGally package for visualization
