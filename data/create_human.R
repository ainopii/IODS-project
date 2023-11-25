# Aino-Kaisa Piironen
# Data wrangling for Assignment 4 in the Introduction to Open Data Science Course

library(readr)

# reading two datasets into R
# Human development
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")

# Gender inequality
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Exploring the data structure:

str(hd) # numeric data and countries as characters
dim(hd) # 195 rows, 8 variables
summary_hd <- summary(hd) # saving the summary values in an object
print(summary_hd) # see the summary: Measures of the Human Developmental Index and the key dimensions of it

str(gii) # numeric data and countries as characters
dim(gii) # 195 rows, 10 variables
summary_gii <- summary(gii)
print(summary_gii) # Measures of the Gender Inequality Index and the its key dimensions

# More data available at 
# <https://hdr.undp.org/system/files/documents/technical-notes-calculating-human-development-indices.pdf>
# <https://hdr.undp.org/data-center/human-development-index#/indicies/HDI>

# Rename the variables 

library(tidyverse)
library(dplyr) 

# example: data <- data %>% rename(new_column_name = old_column_name)
# change column names in the original data frame

# Human developmental data
hd <- hd %>% 
  rename("GNI" = "Gross National Income (GNI) per Capita",
         "Life.Exp" = "Life Expectancy at Birth",
         "Edu.Exp" = "Expected Years of Education", 
         "HDI" = "Human Development Index (HDI)",
         "Edu.Mean" = "Mean Years of Education",
         "GNI-HDI" = "GNI per Capita Rank Minus HDI Rank")
view(hd) # check up the data

# Gender inequality data
gii <- gii %>% 
  rename("GII" = "Gender Inequality Index (GII)",
         "Mat.Mor" = "Maternal Mortality Ratio",
         "Ado.Birth" = "Adolescent Birth Rate",
         "Parli.F" = "Percent Representation in Parliament",
         "Edu2.F" = "Population with Secondary Education (Female)",
         "Edu2.M" = "Population with Secondary Education (Male)",
         "Labo.F" = "Labour Force Participation Rate (Female)",
         "Labo.M" = "Labour Force Participation Rate (Male)")
view(gii) # check up the data

# Mutate gii data to add two new variables

gii <- gii %>% 
  mutate("Edu2.FM" = Edu2.F / Edu2.M,
         "Labo.FM" = Labo.F / Labo.M)

head(gii) # check the first (6) rows of the data

# joining the data sets by Country keeping only the countries in both data sets

human <- inner_join(hd, gii, by = "Country")

str(human) # check the data structure
# Data contains 195 observations and 19 variables as it should.

# Saving the data

library(readr)

write_csv(human, "human.csv") # working directory was already set in the IODS data folder.
