##downloading the file 
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

##unzip dataset 
unzip(zipfile="./data/Dataset.zip",exdir="./data")

##get the list of all the files 
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

##reading trainings tables 
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

##reading testing tables
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

##reading features
features <- read.table('./data/UCI HAR Dataset/features.txt')

##reading activity labels
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

##assigning column names 
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

##merging al data in one set 
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setcombined <- rbind(mrg_train, mrg_test)

##reading column names 
colNames <- colnames(setcombined)

##creating vector for ID, mean, standard deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

##making subset from setcombined
setmean_and_std <- setcombined[ , mean_and_std == TRUE]

##name the activities in data set 
setwithactivitynames <- merge(setmean_and_std, activityLabels,
                              by='activityId',
                              all.x=TRUE)

##second tidy set with the average of each variable for each activity and each subject
sec_tidyset <- aggregate(. ~subjectId + activityId, setwithactivitynames, mean)
sec_tidyset <- sec_tidyset[order(sec_tidyset$subjectId, sec_tidyset$activityId),]

##writing second tidy data set in txt file 
write.table(sec_tidyset, "sec_tidyset.txt", row.name=FALSE)
