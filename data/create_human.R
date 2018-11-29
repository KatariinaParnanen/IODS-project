# Merging data from two sources
# Katariina Parnanen, 25.11.2018 
# Dataset 1 is here: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
# Dataset 2 is here: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv
# Metatada is here: http://hdr.undp.org/en/content/human-development-index-hdi
# Techincal data is here: http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

# Load dplyr library

library(dplyr)

# Read in dataset 1

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# Read in dataset 2

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Explore the structure of the datasets

str(hd)
dim(hd)
str(gii)
dim(gii)

summary(hd)
summary(gii)

# There are 8 variables and 195 observations in th hd dataset. There are both string and numeric variables.
# There are 10 variables in the gii dataset and 195 obsetvations. Also in this dataset there are both character and numeric variables.

# Change the variable names to something shorter
colnames(hd)<-c("rank", "country", "HDI", "l_exp", "e_exp", "e_mean", "GNI", "GNI-rank")

colnames(gii)<-c("rank", "country", "GII", "Mat_mort", "Ad_br", "Perc_parl", "Sec_e_f", "Sec_e_m", "Lab_rate_f", "Lab_rate_m")


# Check that everything looks good
hd
gii

gii <- mutate(gii, ed_rat = Sec_e_f/Sec_e_m)
gii <- mutate(gii, lab_rat = Lab_rate_f/Lab_rate_m)

# Join the two datasets using the variable coutry as the identifier

?inner_join

human<-inner_join(gii, hd, by = "country", suffix = c(".gii", ".hd"))

# Check that everything looks like it should be

human
dim(human)

#There are 19 variables and 195 observations, like there should be.

write.table(human, file="data/human.txt", sep="\t")

#Check that everything looks ok
read.table("data/human.txt", sep="\t")

##Loading in the data and needed packages and data wrangling
#We will load the dataset human that we started working on last week. Then we will do additional modifications to it. The data contains information about education and labout rates in males and females, life expectancies, education expectancies, maternal mortalities, adolescent birth rates, education means, gross national index and gender inequality index and human development indeces of different countries.

#We will change the GNI to numeric, since it includes dots as separators for thousands.

#Load needed libraries
library(dplyr)
library(stringr)
library(ggplot2)

# Read in table
human<-read.table("data/human.txt", sep ="\t")

# Explore the structure and dimensions of the data
str(human)

dim(human)

# Mutate the GNI to numeric
human_<-mutate(human, GNI=str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric())

# The data has 195 observations and 19 variables for the different countries.

# Make a vector for columns to keep
keep <- c("country", "ed_rat", "lab_rat", "l_exp", "e_exp", "GNI", "Mat_mort", "Ad_br", "Perc_parl")

# Select the 'keep' columns
human_ <- dplyr::select(human_, one_of(keep))

# Change the names to ones used in the example
colnames(human_)<-c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# Remove all rows containing missing values
human_ <- filter(human_, complete.cases(human_))

# Save the regions
regions<-c("East Asia and the Pacific", 
           "Latin America and the Caribbean", "Sub-Saharan Africa", 
           "World", "Europe and Central Asia",
           "South Asia", "Arab States")

# Remove the regions
human_<-human_[!human_$Country%in%regions,]

# Add country as row name
rownames(human_)<-human_$Country

# Check the file
head(human_)
dim(human_)

# Remove the first column for country
human_<-human_[,2:9]

# Check the number of columns
dim(human_)
# Looks good!

# Save table
write.table(human_, "~/Documents/IODS_course/IODS-project/data/human.txt", sep="\t")

