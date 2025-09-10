library(readxl)

read_excel("Data/Patient.xlsx")
Patient <- read_excel("Data/Patient.xlsx")

head(Patient)

#from here on i will organize the data
install.packages("janitor")
library(tidyverse)
library(janitor)
library(dplyr)

#Here i selected only the parameters i could have any interest in studying
names(Patient)
Patient <- Patient %>% select (ID, Initials, Registry, Sample_date, Birthdate, Group_pt_HI, Age, Sex, Genotype, VCM, Plat, `DD hemostasia (ng/mL)`, `P-selectin`, uPAR, TGT_Lagtime, TGT_ETP, TGT_Peak, TGT_tt_Peak)

#Here i sliced the empty rows to only keep the rows with patients and controls (Alternatively i could have done: Patient1 <- Patient %>% filter(!is.na(Sample_date) & Sample_date != "")) to exclude rows without Sample Date
Patient_1 <- Patient %>% slice(1:76)

#Here i will remove the row that was empty and used as a space
Patient_1 <- Patient_1 %>% slice(-51)
