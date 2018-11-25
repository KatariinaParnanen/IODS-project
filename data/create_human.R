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
