Instructions for project
------------------------

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
> 
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
> 
> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
> 
> Here are the data for the project: 
> 
> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
> 
> You should create one R script called run_analysis.R that does the following. 
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set.
> 4. Appropriately labels the data set with descriptive activity names.
> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##load libraries
```r
library(data.table)
library(dplyr)
library(reshape2)
```

## start of combining features

### Assume all the data files are stored in the folder named "UCI HAR Dataset" which can be downloaded from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
### read the feature and activity names

#### store folderpath to variables and read feature and activity contents from the files

```r
mainfolder<-"./UCI HAR Dataset/"

feature_label_file<-"features.txt"
activity_label_file<-"activity_labels.txt"



feature_filepath<-paste(mainfolder,feature_label_file,sep="",collapse = "")
activity_filepath<-paste(mainfolder,activity_label_file,sep="",collapse = "")

feature_names_table<-fread(feature_filepath)
activity_names_table<-fread(activity_filepath)
names(feature_names_table)<-c("Feature_ID","Feature_name")
names(activity_names_table)<-c("Activity_ID","Activity_name")
```

### read "test" data and store the datasets into sub_test_con, x_test_con and y_test_con, x_**_con is the measured feature, y_**_con is the activity id sub_**con is the subject ID 

```r
datafolder<-"test/"

sub_filename<-"subject_test.txt"
x_file<-"X_test.txt"
y_file<-"y_test.txt"

subject_filepath<-paste(mainfolder,datafolder,sub_filename,sep="",collapse = "")
x_filepath<-paste(mainfolder,datafolder,x_file,sep="",collapse = "")
y_filepath<-paste(mainfolder,datafolder,y_file,sep="",collapse = "")


sub_test_con<-fread(subject_filepath) #1-30 vulunteer for test
x_test_con<-fread(x_filepath)# for each vulunteer with each gesture, there are 561 variable calcuated for test
y_test_con<-fread(y_filepath) # position for test
```


### read "train" data and store the datasets into sub_train_con, x_train_con and y_train_con
```r
datafolder<-"train/"
sub_filename<-"subject_train.txt"
x_file<-"X_train.txt"
y_file<-"y_train.txt"


subject_filepath<-paste(mainfolder,datafolder,sub_filename,sep="",collapse = "")
x_filepath<-paste(mainfolder,datafolder,x_file,sep="",collapse = "")
y_filepath<-paste(mainfolder,datafolder,y_file,sep="",collapse = "")



sub_train_con<-fread(subject_filepath) #1-30 vulunteer for test
x_train_con<-fread(x_filepath)# for each volunteer with each gesture, there are 561 variable calcuated for test
y_train_con<-fread(y_filepath) # activity for test

```



### combine train and test variable into x_con, y_con, sub_con
```r
x_con<-rbind(x_test_con,x_train_con);
y_con<-rbind(y_test_con,y_train_con);
sub_con<-rbind(sub_test_con,sub_train_con);
```
### set the new column names and add the two column "Subject_ID" and "Activitivity_ID to the data set"
```r
subject_column_name<-"Subject_ID"
activity_column_name<-"Activity_ID"

```
#### rearrange the data frame by first "Volunteer_ID" 1-30, then "Activity_ID" 1-6, replace "Activity_ID" 
#### with "Activity_name", and add both "Volunteer_ID" and "Activity_name" to the data.table x_con

```r
label_con<-cbind(sub_con,y_con)
colnames(label_con)<-c(subject_column_name,activity_column_name)
reorder_index_con<-order(label_con[[subject_column_name]],label_con[[activity_column_name]])

x_con<-x_con[reorder_index_con,]
y_con<-y_con[reorder_index_con,]
```

#### make a table that store the activity_IDs and its corresponding activity_names
```r
y_con<-merge(y_con,activity_names_table,by.x="V1",by.y=activity_column_name,all=FALSE)
sub_con<-sub_con[reorder_index_con,]


x_con$Volunteer_ID<-sub_con$V1
x_con$Acttivity_ID<-y_con$Activity_name

names(x_con)<-c(feature_names_table$Feature_name,c(subject_column_name,activity_column_name))
```

### save the combined files, x_con is the data.table that stores all the combined features
```r
fwrite(x_con, "./combined_feature.csv")
```


## end of combining features

## start of extracting features(mean and std)
### extract the feature with names as mean() and std()
```r
token<-"mean\\(\\)"
mean_feature_indexes<-grep(token,feature_names_table$Feature_name)
mean_feature_names<-feature_names_table[mean_feature_indexes,2]

token<-"std\\(\\)"
std_feature_indexes<-grep(token,feature_names_table$Feature_name)
std_feature_names<-feature_names_table[std_feature_indexes,2]
```
### store all the features and their column names to a dataset "extracted_feature_con"

```r
len<-ncol(x_con)
Subject_ID_col<-len-1
Activity_name_col<-len

feature_indexes<-c(mean_feature_indexes,std_feature_indexes,Subject_ID_col,Activity_name_col)


extracted_feature_con<-x_con[,..feature_indexes]
fwrite(extracted_feature_con,"extracted_mean_std_feature.csv")
```
## end of extracting features(mean and std)

## create a dataset calculated the mean of the featured extracted above

### reshape the dataset using melt function with ID variable set as Subject_ID and activity_ID , the other as measure
```r
extracted_feature_con$sequence_ID<-1:nrow(extracted_feature_con)
measure_variable<-head(names(extracted_feature_con),-3)
ID_variable<-tail(names(extracted_feature_con),3)
melt_feature_table<-melt(extracted_feature_con,id=ID_variable,measure.vars=measure_variable)
```

### preform a dcast operation to calculate the "mean"s of the features.
### this will generate a dataframe with  35 by 68 dataframe

### the features names are listed below, in which column 3 to 68 are the "mean" and "std" feature
[1] "Subject_ID"                  "Activity_ID"                 "tBodyAcc-mean()-X"          
 [4] "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tGravityAcc-mean()-X"       
 [7] "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"        "tBodyAccJerk-mean()-X"      
[10] "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"       "tBodyGyro-mean()-X"         
[13] "tBodyGyro-mean()-Y"          "tBodyGyro-mean()-Z"          "tBodyGyroJerk-mean()-X"     
[16] "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyAccMag-mean()"         
[19] "tGravityAccMag-mean()"       "tBodyAccJerkMag-mean()"      "tBodyGyroMag-mean()"        
[22] "tBodyGyroJerkMag-mean()"     "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
[25] "fBodyAcc-mean()-Z"           "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
[28] "fBodyAccJerk-mean()-Z"       "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
[31] "fBodyGyro-mean()-Z"          "fBodyAccMag-mean()"          "fBodyBodyAccJerkMag-mean()" 
[34] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroJerkMag-mean()" "tBodyAcc-std()-X"           
[37] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"            "tGravityAcc-std()-X"        
[40] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"         "tBodyAccJerk-std()-X"       
[43] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-std()-X"          
[46] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"           "tBodyGyroJerk-std()-X"      
[49] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"       "tBodyAccMag-std()"          
[52] "tGravityAccMag-std()"        "tBodyAccJerkMag-std()"       "tBodyGyroMag-std()"         
[55] "tBodyGyroJerkMag-std()"      "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
[58] "fBodyAcc-std()-Z"            "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"       
[61] "fBodyAccJerk-std()-Z"        "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"          
[64] "fBodyGyro-std()-Z"           "fBodyAccMag-std()"           "fBodyBodyAccJerkMag-std()"  
[67] "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-std()" 


```r
formula_str<- paste(c(subject_column_name,"+", activity_column_name,"~variable" ), sep="",collapse="")
mean_feature_table_by_subject_activity<-dcast(melt_feature_table,formula=formula_str,mean)
write.table(mean_feature_table_by_subject_activity,"./mean_feature_over_all_measurements.csv")
```


### Subject_ID can take from 1 to 30
### Activity_ID can take 6 values as "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS" "SITTING"           "STANDING"           "LAYING" 

### Although there are 30 subjects and 6 activities, there are only 35 types of combination of the two

## The naming convention is as follows: the starting letter "t" ("f") represents time (frequency) domain  respectively. The next phrase "Body" and "Gravity" tell that the feature is from body acceleration or gravity. "Acc" alone means acceleration along X,Y,Z axis depending on the last letter following "-" if any. "AccJerk" is the derivative of the acceleration. "Gyro" is the Gyro accleration. "Mag" stands for magnitude of the measured feature. 
##end

##end