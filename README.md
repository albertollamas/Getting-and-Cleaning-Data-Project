# Getting and Cleaning Data Project README

The project has been carried out in the context of the Data Science Specialization courses. 

This project has been carried out using RStudio Version  0.99.892, R version 3.2.3 and Windows 8.
Text is encoded in UTF-8. The proyect consist in tyding a given data set. dplyr Package has been used.

## Downloading and processing the data

The data have been downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and its content has been downloaded and unzipped in different folders under the working directory. All of the code writen in run_analysis.R permits to work in the working directory as stated in the project goals. 

Code permits to acces the meta data files to get an idea about what's in the test and train folders.

Some of the features provided in the data ser have exactly the same name, this could lead to errors when further processing the data, therefore, they have been treated. Features with same name are the  ones including the expression "-bandsEnergy()", these feature names have been modified.

## Tidying the data

The first aim of this project is obtaining a tidy data set that complies with these rules.

__1__ Merges the training and the test sets to create one data set.
__2__ Extracts only the measurements on the mean and standard deviation for each measurement.
__3__ Uses descriptive activity names to name the activities in the data set
__4__ Appropriately labels the data set with descriptive variable names.

In order to achive this goal, the following steps have been followed.

Variables in  X\_text and X_train have been labeled using the feature names. However they have been renamed later to avoid camel writing and non alphanumeric characters. 
        
y\_test has been modified to asign the activity label to its value on y\_test and a similar procedure has been carried out with the train set. y\_test, X\_test and subject_test have been binded, and the same has been done with the train set.

Test and train sets have been merged to obtain de complete dataset, and two new variavles indicating which set the data comes from and an id have been created, these variables are superfluous, however they permit to reconstruc the original data (other than the Bands... features names) from Datasettemp 2, otherwise impossible.

Using dplyr the needed columns, thos containing the expressions "mean()" and "std()" have been selected.The variable names have been changed to lower case and including alpha numeric characters only.

Datasettemp3 meets the required specifications up to point 4, however the dataset has been arranged by subject  as it was in the original data. I consider the stemps 1 to 4 completed in the Dataset1to4 data frame.

Finaly, to achieve the fifth goal of this project:

__5__ From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

aggregate Function renders the work needed for the last dataset. Superfluous columns have been eliminated and the activity label has been restored.
