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

# 1.4. Converting categorical variables to factors: treatment (1,2). 

BPRS <- BPRS %>% 
  mutate(treatment = factor(treatment)) # overwrite the original variable

# 1.5. Converting data to long form. Adding a week variable to BPRS.
# Need to get each variable is in its own column, and each observation is in its own row.
# Variables: treatment, subject, week, BPRS (points)

# changing column names for BPRS points in each week
colnames(BPRS)[3:11] <- c(0:8) # now I will have week data as numbers in the tidy format (instead of "week0" etc.)

# saving the columns with BPRS points
weeks <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")

# not the best and the shortest way to do this :)

BPRS_long <- BPRS %>% 
  pivot_longer(all_of(weeks),
               names_to = "week", 
               values_to = "BPRS")

str(BPRS_long)

# changing week column from character to numeric
BPRS_long$week <- as.numeric(BPRS_long$week)
BPRS_long$subject %>%  as.integer()

# Checking the data

view(BPRS_long)
str(BPRS_long)
# Now the data has 4 columns, treatment and week as a factor and other (subject, BPRS) with numerical values.

BPRS_long %>% group_by(treatment, week) %>% 
  summarise(mean(BPRS))

# In treatment group 1, the mean BPRS results from baseline to 8 weeks range from 47 to 29.3.
# In the treatment group 2, from 49 to 33.6, respectively.

# Saving long format data
write_csv(BPRS_long, "BPRS_tidy.csv")

# PART 2. RATS data

# 2.1 Reading the wide data, the data includes rownames

rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", row.names = 1)

# 2.2 Saving the data to IODS project data folder (already as a working directory)
write_csv(rats, "rats.csv")

# 2.3 Exploring the data
str(rats)
colnames(rats)
view(rats)
summary(rats)

# rats data includes also longitudinal data from each subjects "ID" (n=16) in three groups.
# There are 11 observations for each rats. Observations are body weights (g) of rats during a 9-week period. 

# Converting categorical variables to factors: Group 1,2,3.
rats <- rats %>% 
  mutate(Group = factor(Group))

# Converting data to long form. Adding a Time variable to RATS.

# changing column names using: colnames(df) = gsub("pattern", replacement, x = colnames(df)
colnames(rats) <- gsub("WD+", "", colnames(rats))

Time <- dplyr::select(rats, -ID, -Group)
keep <- colnames(Time)

rats_long <- rats %>% 
  pivot_longer(all_of(keep),
               names_to = "Time",
               values_to = "Weight")

str(rats_long)
# days are characters, otherwise okey. 

rats_long$Time <- as.numeric(rats_long$Time) # not it is numeric

# Checking the data again
str(rats_long)

# Four variables: ID, Group (as a factor), Time (in days, as a factor) and Weight

rats_long %>% group_by(Group) %>% 
  summarise(mean(Weight))

# Group 1: 264 g, group 2: 485g and group 3: 526 g - Seems to be group differences!

rats_long %>% group_by(Time) %>% 
  summarise(mean(Weight))

# Overall, the body weight seems to increase during the 9-week period as expected.

# Save the long format data
write_csv(rats_long, "rats.tidy.csv")
