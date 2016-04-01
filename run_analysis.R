#This proyect has been carried out using RStudio Version  0.99.892 and R version 3.2.3 and Windows 8.
#Text is encoded in UTF-8. The proyect consist in tyding a given data set. No other package than base
#has been loaded by now.

#First I check if i'm on my default Working Directory, clear my workspace and create a new directory to 
#download the zip file to, and downloaded the zipfile into it.

getwd()
rm(list=ls())

    if (!file.exists("zipdir")){
      dir.create("zipdir")
    }
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="zipdir/zipfile.zip")

#If I were to extract the files using default values, their contents would be extracted into the proyect 
#directory, since there's a folder containing them that would be no problem, however to make things tydier
#I decided to create a new folder to store the data.

    if (!file.exists("data")){
        dir.create("data")
    }
unzip("zipdir/zipfile.zip",exdir="data")

#I now take look at the meta data files to get an idea about what's in the test and train folders.

file.edit("data/UCI HAR Dataset/README.txt")
file.edit("data/UCI HAR Dataset/features_info.txt")
file.edit("data/UCI HAR Dataset/features.txt")
file.edit("data/UCI HAR Dataset/activity_labels.txt")

#I read the needed files into R, create coppies of them to work with and lable them (except for:features
#y/X_test and y/X_train)

original_activity_labels<-read.table("data/UCI HAR Dataset/activity_labels.txt")
original_features<-read.table("data/UCI HAR Dataset/features.txt")
original_subject_test<-read.table("data/UCI HAR Dataset/test/subject_test.txt")
original_X_test<-read.table("data/UCI HAR Dataset/test/X_test.txt")
original_y_test<-read.table("data/UCI HAR Dataset/test/y_test.txt")
original_subject_train<-read.table("data/UCI HAR Dataset/train/subject_train.txt")
original_X_train<-read.table("data/UCI HAR Dataset/train/X_train.txt")
original_y_train<-read.table("data/UCI HAR Dataset/train/y_train.txt")

activity_labels<-original_activity_labels
colnames(activity_labels)<-c("activityindex","activitylabel")
subject_test<-original_subject_test
colnames(subject_test)<-"subject"
subject_train<-original_subject_train
colnames(subject_train)<-"subject"

y_test<-original_y_test
y_train<-original_y_train
features<-original_features
X_test<-original_X_test
X_train<-original_X_train


#Some of the features have exactly the same name, this could lead to errors when further processing the 
#data, therefore, they will be treated here. You can check this with:
length(unique(features[,2]))==dim(features)[1]


#I ignore why the names are repeated but I think is due to overlapping. Features with same name are the 
#ones including the expression "-bandsEnergy()", since no further instructions were given e.g. to join them. 
#I will simply modify their names attaching the number on the features list, i.e. the one on the first 
#column to them, in order to do that I created two extra column vectors in the features table, first 
#identifying the troublesome features and a second one with the final names.


features[,3]<-grepl("bandsEnergy",features[,2])
features[,2]<-as.character(features[,2])
    for (i in 1:dim(features)[1]){
        id.ch=as.character(seq(1:dim(features)[1])) #A character label to be pasted to the feature name.
            if (features[i,3]=="FALSE"){
            features[i,4]<-as.character(features[i,2])
            }
            else {
            features[i,4]<-as.character(paste(features[i,2],id.ch[i], sep=""))
            }
    }

#Now I can label the feature variables and I asign the featurenames as column (variable) names for X_text
#and X_train later I will  modify the strings so I only take lower case alphanumeric values

colnames(features)<-c("featureindex","features","featurelogical","featurenames")
colnames(X_test)<-as.character(features[,4])  
colnames(X_train)<-as.character(features[,4])
        
#I add a column vector  y_test to asign the activity label to its value on y_test and I proceed similarly
#with the train set

colnames(y_test)<-"activity"
y_test$activitylabel<-activity_labels[y_test[,1],2]

colnames(y_train)<-"activity"
y_train$activitylabel<-activity_labels[y_train[,1],2]

# I column-bind y_test, X_test and subject_test and do the same with the train set

testdf<-cbind(subject_test,y_test,X_test)
traindf<-cbind(subject_train,y_train,X_train)

#I row-bind test and train sets to obtain de complete dataset, and two new variavles indicating which set
#the data comes from and an id, these variables are superfluous, however they permit to reconstruc the 
#original data (other than the Bands... features names) from Datasettemp 2, otherwise impossible

Datasettemp1<-rbind(testdf,traindf)
id<-c(seq(1:dim(y_test)[1]),seq(1:dim(y_train)[1]))
originalset<-c(rep("test",dim(y_test)[1]),rep("train",dim(y_train)[1]))
Datasettemp2<-cbind(originalset,id,Datasettemp1)

#I now load dplyr for the usefull functions it contains, select the needed columns 

library("dplyr", lib.loc="~/R/win-library/3.2")
Datasettemp3<-select(Datasettemp2,originalset:activitylabel,contains("mean()"),contains("std()"))

#And change the variable names to lower case and including alpha numeric characters only

names(Datasettemp3)<-tolower(gsub("[^[:alnum:]]", "", names(Datasettemp3))) #the regular expression 
                                                                            #[^[:alnum:]] identifies
                                                                            # non alphanumeric characters.

#Datasettemp3 meets now the required specifications, however i prefer to arrange "Dataset" by subject as 
#it was in the original data. I consider the stemps 1 to 4 completed in the Dataset1to4 data frame

Dataset1to4<-arrange(Datasettemp3,activity,subject,originalset,id)

#aggregate function renders the work needed for the last dataset I apply it to the later data set as 
#requested, i eliminate superfluous columns and i remake the activity label 

tidyDatasettemp1<-select(Dataset1to4,-(originalset:id)) 
tidyDatasettemp2<-aggregate(. ~subject + activity, tidyDatasettemp1, mean)

tidyDatasettemp2$activitylabel = activity_labels[tidyDatasettemp2$activity,2]



write.table(tidyDatasettemp2,"tidyDataset.txt",row.name=FALSE)
