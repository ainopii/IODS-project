# Aino-Kaisa Piironen, 9.11.2023
# Created in the Introduction to Open Data Science -PhD course for data wrangling of the learning2014 data: <https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-meta.txt>.

# Step 1. Importing the data into R and exploring the structure and dimensions of the data.

lrn14_full <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                           sep="\t", header=TRUE)
dim(lrn14_full)
str(lrn14_full)

# There are 183 rows (observations) and 60 columns (variables) in the dataframe. All but the "gender" variable are numerical (integers). Gender is a character with values "M" (male) or "F" (female). Column names exists.

# Step 2. Create an analysis datase including: gender, age, attitude, deep, stra, surf and points.

library(dplyr)
library(tidyverse)

# 2.1 Questions related to deep, surface and strategic learning
# Deep = Seeking Meaning, Relating Ideas, Use of Evidence
# Surf = Lack of Purpose, Unrelated Memorising, Syllabus-boundness
# Stra = Organized Studying, Time Management   

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
deep_columns <- select(lrn14_full, one_of(deep_questions))
# create column 'deep' by averaging
lrn14_full$deep <- rowMeans(deep_columns)

# select the columns related to surface learning 
surface_columns <- select(lrn14_full, one_of(surface_questions))
# create column 'surf' by averaging
lrn14_full$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning 
strategic_columns <- select(lrn14_full, one_of(strategic_questions))
# create column 'stra' by averaging
lrn14_full$stra <- rowMeans(strategic_columns)

# 2.2 Selecting columns: gender, age, attitude, deep, stra, surf and points.
learning2014 <- select(lrn14_full, c("gender","Age","Attitude", "deep", "stra", "surf", "Points"))

# check the structure of the new dataset
str(learning2014)

# renaming columns
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"

# checking again: str(learning2014)

# include only rows with points > 0 using filter(), overwriting the learning2014 data
learning2014 <- filter(learning2014, points > 0)

# Step 3. Set the working directory and save the analysis dataset.
setwd("C:/Users/ainopii/Documents/IODS/IODS-project/data")  ## this comes from the R base

# and saving the data

write.csv(learning2014, "C:/Users/ainopii/Documents/IODS/IODS-project/data//learning2014_tidy.csv", row.names = FALSE)

# importing the data and check up:
lrn14_tidy <- read.csv("C:/Users/ainopii/Documents/IODS/IODS-project/data//learning2014_tidy.csv", sep = ",", header = TRUE)

str(lrn14_tidy)
head(lrn14_tidy)
