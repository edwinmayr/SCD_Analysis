install.packages("janitor")
install.packages("GGally")
install.packages("reshape2")

#from here on i will organize the data
library(tidyverse)
library(janitor)
library(dplyr)
library(GGally)
library(readxl)
library(ggplot2)
library(reshape2)

read_excel("Data/Patient.xlsx")
Patient <- read_excel("Data/Patient.xlsx")

#Here i selected only the parameters i could have any interest in studying in my study
names(Patient)
Patient_alldata <- Patient %>% select (ID, Initials, Registry, Sample_date, Birthdate, Group_pt_HI, Age, Sex, Genotype, `Hb F`, LDH, `Bilirrubina total`, VCM, RDW, VPM, Hb, WBC, Seg, Lymph, Mono, Eos, Plat, Retc, `DD hemostasia (ng/mL)`, `FVW:Ag`, `FVW Activity (%)`, TGT_Lagtime, TGT_ETP, TGT_Peak, TGT_tt_Peak)

#Here i sliced the empty rows to only keep the rows with patients and controls (Alternatively i could have done: Patient1 <- Patient %>% filter(!is.na(Sample_date) & Sample_date != "")) to exclude rows without Sample Date
Patient_alldataclean <- Patient_alldata %>% slice(1:76)

#Here i will remove the row that was empty and used as a space
Patient_alldataclean <- Patient_alldataclean %>% slice(-51)

#Here i selected only the parameters i could have any interest in studying but i removed non numeric values to calculate correlation
names(Patient)
Patient_correl <- Patient_alldataclean %>% select (Age, Genotype, `Hb F`, LDH, `Bilirrubina total`, VCM, RDW, VPM, Hb, WBC, Seg, Lymph, Mono, Eos, Plat, Retc, `DD hemostasia (ng/mL)`, `FVW:Ag`, `FVW Activity (%)`, TGT_Lagtime, TGT_ETP, TGT_Peak, TGT_tt_Peak)

#Here i edited Patient_correl to give it better column names

Patient_correl <- Patient_correl %>%
  rename( Hb_F = `Hb F`,
          Bilirrubina_t = `Bilirrubina total`,
          DD_hemo = `DD hemostasia (ng/mL)`,
          FVW_Ag = `FVW:Ag`,
          FVW_At = `FVW Activity (%)`)

#Here i will do a pearson correlation using the GGally package for visualization
ggpairs(Patient_correl,
        upper = list(continuous = wrap("cor", size = 3)),  # Pearson correlation values
        lower = list(continuous = "smooth"),               # scatterplots with regression line
        diag  = list(continuous = "densityDiag"))          # density plots on the diagonal



#to better visualize possible correlations i will use a heatmap 

ggcorr(Patient_correl, 
       label = TRUE, 
       label_round = 2, 
       hjust = 0.75,
       label_size = 1.8,
       layout.exp = 1)

#Here i will setup a correlation with only patients
SCD_correl <- Patient_correl %>% slice(1:50)

#Here i will do a Pearson correlation with only the patients
ggpairs (SCD_correl,
         upper = list(continuous = wrap("cor", size = 3)),  
         lower = list(continuous = "smooth"),               
         diag  = list(continuous = "densityDiag"))         

#Here i will make a heatmap of this
ggcorr(SCD_correl,
       label = TRUE,
       label_round = 2,
       hjust = 0.75,
       label_size = 1.8,
       layout.exp = 1)
#Here i will setup an object for correlation which includes just controls
Control_correl <- Patient_correl %>% slice(51:75)



#Here i plotted the TGT parameters in SCD VS Controls

# Select only the TGT columns
TGT_data <- Patient_correl[, c("TGT_Lagtime", "TGT_ETP", "TGT_Peak", "TGT_tt_Peak")]

# Add a temporary Group vector (not stored in Patient_correl)
Group <- c(rep("SCD", 50), rep("Control", 25))

# Reshape to long format
TGT_long <- melt(cbind(Group, TGT_data), id.vars="Group")

# Plot
ggplot(TGT_long, aes(x=Group, y=value, fill=Group)) +
  geom_boxplot(alpha=0.6, outlier.shape=NA) +
  geom_jitter(aes(color=Group), width=0.2, size=2, alpha=0.7) +
  facet_wrap(~variable, scales="free_y") +
  theme_minimal(base_size = 14) +
  labs(x="", y="Value", title="TGT Parameters in SCD vs Control") +
  scale_fill_manual(values=c("Control"="lightblue", "SCD"="lightgreen")) +
  scale_color_manual(values=c("Control"="blue", "SCD"="darkgreen"))

#I edited my dataset to make the Genotype a categorical value to make a scatter plot later on

Patient_correl_Gen <- Patient_correl

Patient_correl_Gen$Genotype <- factor(
  Patient_correl_Gen$Genotype,
  levels = c(0, 1, 2, 3),
  labels = c("Control", "SC", "SS", "SB")
)


#Here i plotted the TGT parameters by Genotype

# Select only TGT columns + Genotype
TGT_data <- Patient_correl_Gen[, c("Genotype", "TGT_Lagtime", "TGT_ETP", "TGT_Peak", "TGT_tt_Peak")]

# Reshape to long format
TGT_long <- melt(TGT_data, id.vars = "Genotype")

# Plot
ggplot(TGT_long, aes(x=Genotype, y=value, fill=Genotype)) +
  geom_boxplot(alpha=0.6, outlier.shape=NA) +
  geom_jitter(aes(color=Genotype), width=0.2, size=2, alpha=0.7) +
  facet_wrap(~variable, scales="free_y") +
  theme_minimal(base_size=14) +
  labs(x="", y="Value", title="TGT Parameters by Genotype") +
  scale_fill_manual(values=c("Control"="lightblue", "SC"="lightpink", "SS"="lightgreen", "SB"="orange")) +
  scale_color_manual(values=c("Control"="blue", "SC"="red", "SS"="darkgreen", "SB"="darkorange"))


