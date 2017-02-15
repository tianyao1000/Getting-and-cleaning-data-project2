
###The "run_analysis.R" script combine the datasets from the "train" and "test" and extract the "mean" and "std" features, then averages those features reshapes the data frame based on "Subject_ID" and "Activity_ID". Finally a data file called "mean_feature_over_all_measurements.txt" is generated. For the details, please refer to codebook.md which explain the script line by line.

## Details of the "mean_feature_over_all_measurements.txt" file

###The dimension of the file is 35 by 68. 
### the features names are listed below, in which column 35 to 68 are the "mean" and "std" feature
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



### Subject_ID can take from 1 to 30
### Activity_ID can take 6 values as "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS" "SITTING"           "STANDING"           "LAYING" 

### Although there are 30 subjects and 6 activities, there are only 35 types of combination of the two

## The naming convention is as follows: the starting letter "t" ("f") represents time (frequency) domain  respectively. The next phrase "Body" and "Gravity" tell that the feature is from body acceleration or gravity. "Acc" alone means acceleration along X,Y,Z axis depending on the last letter following "-" if any. "AccJerk" is the derivative of the acceleration. "Gyro" is the Gyro accleration. "Mag" stands for magnitude of the measured feature. 
##end