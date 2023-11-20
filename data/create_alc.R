# Aino-Kaisa Piironen, 16.11.2023, Introduction to Open Data Science 2023 -course
# An R script for the data wrangling task in Assignment 3, using data from <https://www.archive.ics.uci.edu/dataset/320/student+performance>

# Setting a working directory
setwd("C:/Users/ainopii/Documents/IODS/IODS-project/data/")

# reading data into R
library(readr)
library(tidyverse)

math_data <- read_csv2("student-mat.csv", col_names = TRUE) # separator = ;
por_data <- read_csv2("student-por.csv", col_names = TRUE)

# exploring the data
dim(math_data) # 33 columns, 395 rows/observations
str(math_data) # characters and numbers, demographic data, background variables, grades, alcohol use, absences
# OR glimpse(math_data)

dim(por_data) # 33 variables, 649 rows/observations
str(por_data) #same columns as in math_data

# joining data set based on background variables, keep only students present in both data sets.
# keeping these variables separately in both data: "failures", "paid", "absences", "G1", "G2", "G3" 

library(dplyr)


free_cols <- c("failures", "paid", "absences", "G1", "G2","G3") # the columns that vary in the two data sets
join_cols <- setdiff(colnames(por_data), free_cols) #columns for joining
math_por <- inner_join(math_data, por_data, by = join_cols, suffix = c(".math", ".por"))

dim(math_por) # 370 rows, 39 columns
str(math_por) # all free_col variables are doubled, origin from both data sets separately. 

# combining "duplicate" records (for all in free_cols)

alc <- select(math_por, all_of(join_cols)) # new data frame

# selecting every column not used in joining and choosing the first one to check..
for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

dim(alc)
glimpse(alc)

# combining total alcohol use in a week
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# creating high_use column, TRUE if alc_use > 2
alc <- mutate(alc, high_use = alc_use > 2)

# take a look at the data
glimpse(alc) # 370 observations, 35 variables

# saving the data
alc <- as.data.frame(alc) # as the alc is now a tibble
alc %>%  write_csv("student alc.csv", col_names = TRUE)
