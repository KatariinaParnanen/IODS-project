# Data from two sources
# Katariina Parnanen, 4.12.2018 
# Dataset 1 is here: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
# Dataset 2 is here: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

#Load dplyr 
library(dplyr)
library(tidyr)
#Read in data 
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header=TRUE)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header=TRUE)

#Explore the data
str(BPRS)#The data has multiple measures for same individuals, there are 40 observation for 11 variables. Individuals have been treated differently and there are measures from many weeks.
str(RATS)#This data also has several measures for same rats, there are 16 observations for 13 variables. Rats have been in different groups and there are measures from different weekdays.

summary(BPRS)
summary(RATS)

glimpse(BPRS)
glimpse(RATS)

#Change the categorical variables to factors
BPRS$subject <- factor(BPRS$subject)
BPRS$treatment <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject) %>% 
mutate(week = as.integer(substr(BPRSL$weeks, 5,5)))

RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3, 4))) 


#Take a glimpse at the BPRSL and RATSL data
glimpse(BPRSL)
glimpse(RATSL)

str(BPRSL)
str(BPRS)
str(RATS)
str(RATSL)

#In the long format each obsevation is on their own row, whereas in the long format the observations are in their own columns.
#The wide format is more human readable, but the long format is easier to use in ggplot and is more machine readable.
write.table(BPRSL, "~/Documents/IODS_course/IODS-project/data/BPRSL.txt",  sep="\t")
write.table(RATSL,"~/Documents/IODS_course/IODS-project/data/RATSL.txt", sep="\t")
