---
title: "CodeBook for Getting and Cleaning Data Course Project"
author: "Katherine Raney"
date: "Sunday, November 23, 2014"
output: html_document
---

This code book will describe the variables, data, and transformations performed to prepare the tidy dataset tidy_output.txt.

The tidy_output dataset contains:
* activity - the name of the activity being measured (ex: WALKING)
* subjectId - an integer value surrogate key that relates to the subject being measured
* feature - a variable that categorizes the feature being measured. It encapsolates the signal, type of measurement, and one of 3 directions being measured  . EX:  tBodyAcc-mean()-Y
* average_measure - an average of the measurements taken for the given activity, subjectId, and feature



Transformation Summary
1. The following raw data files were loaded:
  a. Applying to both test and train data
      1. activity_labels.txt - this is a lookup dataset that includes both the activityId surrogate key values and the activity the activityId represents.
      2. features.txt - this file includes the features that were measured and also provides the column names for the x files in order
  b. Test dataset
      1. y_test.txt - This file has the activityId labels that represent the activity being measured for each row of x_test.txt.
      2. subject_test.txt - This file has the subjectId labels that represent the subject being measured for each row of x_test.txt.
      3. x_test.txt - This file has the measures data for the test data set
          test dataset
  c. Train dataset
      1. y_train.txt - This file has the activityId labels that represent the activity being measured for each row of x_train.txt.
      2. subject_train.txt - This file has the subjectId labels that represent the subject being measured for each row of x_train.txt.
      3. x_train.txt - This file has the measures data for the train data set
      
2. The following transformations were performed on the raw data after it was loaded
  a. Test
      1. Applied the features data as column names to x_test
      2. Added y_test as a new column on x_test, activityId
      3. Added subject_test as a new column on x_test, subjectId
      4. Added constant "test" as a new column, dataset, to indicate this was the
  b. Train  
      1. Applied the features data as column names to x_train
      2. Added y_train as a new column on x_train, activityId
      3. Added subject_train as a new column on x_train, subjectId
      4. Added constant "train" as a new column, dataset, to indicate this was the train dataset 
  c. Combined dataset
      1. x_test and x_train were stacked (aka unioned or bound) together to form one dataset
      2. The columns containing the feature measurements were transformed into one row per measurement, transforming the wide dataset into a narrow one
      3. All features but the mean and std features were excluded
      4. The measures were averaged by activity, subject, and feature
	  5. The name of the activity was added as a new column, joining to the activity_labels lookup on activityId
      6. The final aggregated dataset was output as tidy_output.txt
      