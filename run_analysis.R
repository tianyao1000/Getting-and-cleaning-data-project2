library(data.table)
library(dplyr)
library(reshape2)
mainfolder<-"./UCI HAR Dataset/"


## start of combining features

## read the feature and activity names
feature_label_file<-"features.txt"
activity_label_file<-"activity_labels.txt"



feature_filepath<-paste(mainfolder,feature_label_file,sep="",collapse = "")
activity_filepath<-paste(mainfolder,activity_label_file,sep="",collapse = "")

feature_names_table<-fread(feature_filepath)
activity_names_table<-fread(activity_filepath)
names(feature_names_table)<-c("Feature_ID","Feature_name")
names(activity_names_table)<-c("Activity_ID","Activity_name")

##

## read "test" data
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
##

## read "train" data
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

##

## combine train and test table
x_con<-rbind(x_test_con,x_train_con);
y_con<-rbind(y_test_con,y_train_con);
sub_con<-rbind(sub_test_con,sub_train_con);

subject_column_name<-"Subject_ID"
activity_column_name<-"Activity_ID"

## rearrange the data frame by first "Volunteer_ID" 1-30, then "Activity_ID" 1-6, replace "Activity_ID" 
## with "Activity_name", and add both "Volunteer_ID" and "Activity_name" to the data.table x_con
label_con<-cbind(sub_con,y_con)
colnames(label_con)<-c(subject_column_name,activity_column_name)
reorder_index_con<-order(label_con[[subject_column_name]],label_con[[activity_column_name]])

label_con<-label_con[reorder_index_con,]
x_con<-x_con[reorder_index_con,]



## make a table that store the activity_IDs and its corresponding activity_names

label_con<-merge(label_con,activity_names_table,by.x=activity_column_name,by.y=activity_column_name,all=FALSE)


x_con$Volunteer_ID<-label_con[[subject_column_name]]
x_con$Acttivity_ID<-label_con$Activity_name

names(x_con)<-c(feature_names_table$Feature_name,c(subject_column_name,activity_column_name))


## save the combined files, x_con is the data.table that stores all the combined features
fwrite(x_con, "./combined_feature.csv")

##
## end of combining features

## start of extracting features(mean and std)

token<-"mean\\(\\)"
mean_feature_indexes<-grep(token,feature_names_table$Feature_name)
mean_feature_names<-feature_names_table[mean_feature_indexes,2]

token<-"std\\(\\)"
std_feature_indexes<-grep(token,feature_names_table$Feature_name)
std_feature_names<-feature_names_table[std_feature_indexes,2]

len<-ncol(x_con)
Subject_ID_col<-len-1
Activity_name_col<-len

feature_indexes<-c(mean_feature_indexes,std_feature_indexes,Subject_ID_col,Activity_name_col)


extracted_feature_con<-x_con[,..feature_indexes]


fwrite(extracted_feature_con,"extracted_mean_std_feature.csv")

## end of extracting features(mean and std)



extracted_feature_con$sequence_ID<-1:nrow(extracted_feature_con)
measure_variable<-head(names(extracted_feature_con),-3)
ID_variable<-tail(names(extracted_feature_con),3)
melt_feature_table<-melt(extracted_feature_con,id=ID_variable,measure.vars=measure_variable)

formula_str<- paste(c(subject_column_name,"+", activity_column_name,"~variable" ), sep="",collapse="")



mean_feature_table_by_subject_activity<-dcast(melt_feature_table,formula=formula_str,mean)
write.table(mean_feature_table_by_subject_activity,"./mean_feature_over_all_measurements.txt")
