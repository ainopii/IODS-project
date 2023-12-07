# Written by Aino-Kaisa Piironen, 5.-7.12.2023
# R scripts for IODs project, assignment 6

# Loading libraries needed
library(readr)
library(tidyverse)
library(tidyr)
library(dplyr)

# PART 1. BPRS data
# 1.1 Reading the (wide format) data

BPRS <- read_table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt")

# 1.2 Saving data to IODS project data folder (already as a working directory)

write_csv(BPRS, "BPRS.csv")

# 1.3. Exploring the data
str(BPRS)
colnames(BPRS)
view(BPRS)
summary(BPRS)

# BPRS data includes 11 variables (in columns) and 40 rows/subject. First two columns are a treatment group (1,2) and subject ID(1-20), 
# and the rest of the columns are longitudinal/repeated observations (results of the brief psychiatric rating scale, BPRS) of each week from baseline (0) to week 8.
# To note, IDs run from 0 to 20 for both treatment groups but there are totally 40 different subjects.  

# 1.4. Converting categorical variables to factors: treatment (1,2), subject (1-20). 

BPRS <- BPRS %>% 
  mutate(treatment = factor(treatment),
         subject = factor(subject)) # overwrite the original variable

# 1.5. Converting data to long form. Adding a week variable to BPRS.
# Need to get each variable is in its own column, and each observation is in its own row.
# Variables: treatment, subject, week, BPRS (points)

BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "BPRS") %>%
  arrange(weeks) #order by weeks variable

# Extract the week number
BPRSL <-  BPRSL %>% 
  mutate(week = as.integer(substr(weeks, 5,5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# Now the data has 4 columns, treatment and week as a factor and other (subject, BPRS) with numerical values.

BPRSL %>% group_by(treatment, week) %>% 
  summarise(mean(BPRS))

# In treatment group 1, the mean BPRS results from baseline to 8 weeks range from 47 to 29.3.
# In the treatment group 2, from 49 to 33.6, respectively.

# Saving long format data
write_csv(BPRSL, "BPRS_tidy.csv")

# PART 2. RATS data

# 2.1 Reading the wide data, the data includes rownames

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", row.names = 1)

# 2.2 Saving the data to IODS project data folder (already as a working directory)
write_csv(RATS, "rats.csv")

# 2.3 Exploring the data
str(RATS)
colnames(RATS)
view(RATS)
summary(RATS)

# rats data includes also longitudinal data from each subjects "ID" (n=16) in three groups.
# There are 11 observations for each rats. Observations are body weights (g) of rats during a 9-week period. 

# Converting categorical variables to factors: Group 1,2,3, and ID (1-16)
RATS <- RATS %>% 
  mutate(Group = factor(Group),
         ID = factor(ID))

RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD, 3, 4))) %>%
  arrange(Time)

# Glimpse the data
glimpse(RATSL)

# Four variables: ID, Group (factors), Time (in days) and Weight (in grams)

RATSL %>% group_by(Group) %>% 
  summarise(mean(Weight))

# Group 1: 264 g, group 2: 485g and group 3: 526 g - Seems to be group differences!

RATSL %>% group_by(Time) %>% 
  summarise(mean(Weight))

# Overall, the body weight seems to increase during the 9-week period as expected.

# Save the long format data
write_csv(RATSL, "rats.tidy.csv")
