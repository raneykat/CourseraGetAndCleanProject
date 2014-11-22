# Katherine Raney
# Getting and Cleaning Data Course Project
# November 2014

# libraries needed
library(plyr) #?
library(reshape2)

# First, load the files

# activity_labels
cols <- c("activityId","activity")
activity_labels <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt",sep=" ",
            col.names = cols)
# specify that activityId is a factor, not a measure
activity_labels$activityId <-as.factor(activity_labels$activityId)

# features 
cols2 <- c("featureId","feature")
features <-read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt",sep="",
                    col.names=cols2)

#this file has the row labels for the test data set
# they are the surrogate key values related to the activity_labels
y_test <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt",
                   col.names=c("activityId"))
# activityId is a factor
y_test$activityId <- as.factor(y_test$activityId)

# subject_test 
subject_test <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt",
                         col.names=c("subjectId"))
# subjectId is a factor not a measure
subject_test$subjectId <- as.factor(subject_test$subjectId)

#this file has the data for the test data set
x_test <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\x_test.txt",sep = "",
                   quote = "")

#features$feature has the column names for this dataset
cols3 <- features[,2]
names(x_test) <- cols3

#y_test$activityId has the activity labels for this dataset, so we'll add that column
x_test$activityId <- y_test$activityId

#add subjectId 
x_test$subjectId <- subject_test$subjectId

#add dataset column to indicate this is test
x_test$dataset <- "test"

#now we'll repeat for the train dataset 

#this file has the row labels for the train data set
# they are the surrogate key values related to the activity_labels
y_train <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt",
                   col.names=c("activityId"))

# activityId is a factor
y_train$activityId <- as.factor(y_train$activityId)

# subject_train 
subject_train <- read.csv("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt",
                         col.names=c("subjectId"))
# subjectId is a factor not a measure
subject_train$subjectId <- as.factor(subject_train$subjectId)

#this file has the data for the train data set
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

# now we need to "bind" these two together, one on top of the other 
x <- rbind(x_test,x_train)

# we can lookup activity name, joining on activityId
activity_labels$activityId <- as.factor(activity_labels$activityId)

x <- join(x,activity_labels,"activityId")

# lets melt these measures into rows
x <- melt(x,na.rm=TRUE,variable.name="feature",value.name="measure")

# we only want the features that are named like mean or std
x2 <- x[x$feature == "%mean%" | "%std%",] #STUCK HERE
