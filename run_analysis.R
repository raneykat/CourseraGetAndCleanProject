# Katherine Raney
# Getting and Cleaning Data Course Project
# November 2014
#setwd("C:\\raneykat_git\\CourseraGetAndCleanProject")

# libraries needed
library(reshape2) 
library(tidyr)
library(dplyr)


# First, load the files

# APPLIES FOR BOTH TEST AND TRAIN DATA

# activity_labels
# this is a lookup dataset 
cols <- c("activityId","activity")
activity_labels <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt",sep=" ",
            col.names = cols)
# specify that activityId is a factor, not a measure
activity_labels$activityId <-as.factor(activity_labels$activityId)

# features 
# this file has the column names for the x files
cols2 <- c("featureId","feature")
features <-read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt",sep="",
                    col.names=cols2)

# TEST DATASET 

# this file has the row labels for the test data set
# they are the surrogate key values related to the activity_labels
y_test <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt",
                   col.names=c("activityId"))
# activityId is a factor, not a measure
y_test$activityId <- as.factor(y_test$activityId)

# subject_test 
# this file has surrogate keys that relate to the subjects of the test dataset
subject_test <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt",
                         col.names=c("subjectId"))

# subjectId is a factor not a measure
subject_test$subjectId <- as.factor(subject_test$subjectId)

#this file has the measures data for the test data set
x_test <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\x_test.txt",sep = "",
                   quote = "")

#features$feature has the column names for this dataset
cols3 <- features[,2]
names(x_test) <- cols3

#y_test$activityId has the activity labels for this dataset, so we'll add that column
x_test$activityId <- y_test$activityId

#add subjectId to associate the subjects with the measures
x_test$subjectId <- subject_test$subjectId

#add dataset column to indicate this is test
x_test$dataset <- "test"



# TRAIN DATASET

#this file has the row labels for the train data set
# they are the surrogate key values related to the activity_labels
y_train <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt",
                   col.names=c("activityId"))

# activityId is a factor, not a measure
y_train$activityId <- as.factor(y_train$activityId)

# subject_train 
subject_train <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt",
                         col.names=c("subjectId"))
# subjectId is a factor not a measure
subject_train$subjectId <- as.factor(subject_train$subjectId)

#this file has the measures data for the train data set
x_train <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\x_train.txt",sep = "",
                   quote = "")

# cols3 (aka features$feature) has the column names for this dataset
names(x_train) <- cols3

#y_train$activityId has the activity labels for this dataset, so we'll add that column
x_train$activityId <- y_train$activityId

#add subjectId 
x_train$subjectId <- subject_train$subjectId

#add dataset column to indicate this is train
x_train$dataset <- "train"


# Combined dataset
# bind x_test and x_train to form one dataset
x <- rbind_list(x_test,x_train)

# lets melt these measures into rows
# could use gather but melt seems faster
x <- melt(x,na.rm=TRUE,variable.name="feature",value.name="measure")

# keep only the rows where the feature contains mean or std
x <- x[grep("mean|std",x$feature),]

# chain some operations together here
x_tidy <- x %>%
  #The measures were averaged by activity, subject, and feature
  group_by(activityId,feature,subjectId) %>%
  summarise(avg=mean(measure)) %>% 
  # The name of the activity was added as a new column, joining to the activity_labels lookup on activityId
  inner_join(activity_labels,by = c("activityId")) %>%
  select(activity,feature,subjectId,avg)


#The final aggregated dataset was output as tidy_output.txt
write.csv(x_tidy,file="x_tidy.txt")

