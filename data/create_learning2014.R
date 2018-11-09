#Katariina Pärnänen, 6.11.2018, data wrangling excercise
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header =TRUE)
#Check dimensions
dim(learning2014)
#The table has 184 rows and 60 rows
#Check structure
str(learning2014)
#There are 184 observations and 60 factor variables with 3 or more levels

# Create vectors with questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

library(dplyr)

#Take variable columns
variables <- c("gender", "Age", "Attitude", "Points")

lrn2014<-select(learning2014, one_of(variables))

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(learning2014, one_of(deep_questions))
lrn2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learning2014, one_of(surface_questions))
lrn2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learning2014, one_of(strategic_questions))
lrn2014$stra <- rowMeans(strategic_columns)

#Check dimensions
dim(lrn2014)

#Remove those which have 0 points
lrn2014 <- filter(lrn2014, Points > 0)

#Check dimensions
dim(lrn2014)

#Change column names

#Change the name of the second column
colnames(lrn2014)[2] <- "age"

#Change the name of "Points" to "points"
colnames(lrn2014)[4] <- "points"

#Change the name of "Attitude" to "attitude"
colnames(lrn2014)[3] <- "attitude"


#Change working directory
setwd("/Users/kparnane/Documents/IODS_course/IODS-project/data/")

write.table(lrn2014, "learning2014.txt", sep="\t")

#Check the file
head(read.table("learning2014.txt", header=TRUE, sep="\t"))
str(read.table("learning2014.txt", header=TRUE, sep="\t"))
