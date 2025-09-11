library(readxl)

read_excel("Data/Patient.xlsx")
Patient <- read_excel("Data/Patient.xlsx")

head(Patient)

#from here on i will organize the data
install.packages("janitor")
install.packages("GGally")
library(tidyverse)
library(janitor)
library(dplyr)
library(GGally)
#Here i selected only the parameters i could have any interest in studying in my study
names(Patient)
Patient_alldata <- Patient %>% select (ID, Initials, Registry, Sample_date, Birthdate, Group_pt_HI, Age, Sex, Genotype, `Hb F`, LDH, `Bilirrubina total`, VCM, RDW, VPM, Hb, WBC, Seg, Lymph, Mono, Eos, Plat, Retc, `DD hemostasia (ng/mL)`, `FVW:Ag`, `FVW Activity (%)`, TGT_Lagtime, TGT_ETP, TGT_Peak, TGT_tt_Peak)

#Here i sliced the empty rows to only keep the rows with patients and controls (Alternatively i could have done: Patient1 <- Patient %>% filter(!is.na(Sample_date) & Sample_date != "")) to exclude rows without Sample Date
Patient_alldataclean <- Patient_alldata %>% slice(1:76)

#Here i will remove the row that was empty and used as a space
Patient_alldataclean <- Patient_alldataclean %>% slice(-51)

#Here i selected only the parameters i could have any interest in studying but i removed non numeric values to calculate correlation
names(Patient)
Patient_correl <- Patient_alldataclean %>% select (Age,`Hb F`, LDH, `Bilirrubina total`, VCM, RDW, VPM, Hb, WBC, Seg, Lymph, Mono, Eos, Plat, Retc, `DD hemostasia (ng/mL)`, `FVW:Ag`, `FVW Activity (%)`, TGT_Lagtime, TGT_ETP, TGT_Peak, TGT_tt_Peak)

#Here i will do a pearson correlation using the GGally package for visualization
ggpairs(Patient_correl,
        upper = list(continuous = wrap("cor", size = 3)),  # Pearson correlation values
        lower = list(continuous = "smooth"),               # scatterplots with regression line
        diag  = list(continuous = "densityDiag"))          # density plots on the diagonal
w

