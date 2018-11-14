# Merging data from two sources
# Katariina Parnanen, 14.11.2018 
# Source of data https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Set working directory
setwd("/Users/kparnane/Documents/IODS_course/IODS-project/data/")
# Read both student-mat.csv and student-por.csv into R 

mat<-read.csv("student-mat.csv", header=TRUE, sep=";")

por<-read.csv("student-por.csv", header=TRUE, sep=";")

# Explore their structure

str(mat)

# Mat is a data frame with 395 observations with 33 factor and integer variables

str(por)

dim(por)

# Por is a data frame with 649 observations and 33 variables

# Make a vector for variables to join the datasets by

join_by<-c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# Access the dplyr library

library(dplyr)

# Join the datasets with inner_join command from dplyr and add suffixes for data sets
#This takes only students which answered both questions
math_por <- inner_join(mat, por, by = join_by, suffix =c(".math", ".por"))

# Explore the new dataset 

str(math_por)

dim(math_por)

# Take a glimpse at the data
glimpse(math_por)

# There are 382 observations and 53 variables left

# Print out the column names of 'math_por'
colnames(math_por)

# Create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# The columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Take a glimpse at the new combined data

glimpse(alc)


# We define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Glimpse

glimpse(alc)

# We see that there is a new colum for th combined alcohol use

# Then we create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 

alc <- mutate(alc, high_use = alc_use>2)

# Glimpse

glimpse(alc)

#We see that there is a new logical column 'high_use' and 382 observations and 35 variables as should be

#Write table 

write.table(file = "alc.txt", alc, sep="\t")
