##
##Download the zip file into the following folder and unzipped the files
##set working directory to the folder that contains the unzipped files

setwd("C:/Users/.../coursera/cleaning data project/UCI HAR Dataset")

##clean up working space and load library
rm(list = ls(all = TRUE))
library(data.table)

##Read the test.txt files and related txt files into data tables
test <- read.table("./test/X_test.txt")
subjecttest <- read.table("./test/subject_test.txt")
activitytest <-read.table("./test/y_test.txt")
##merge the subject and activity tables to the test table
testc1<- cbind(test,subjecttest)
testc2<-cbind(testc1,activitytest)
##read the features.txt into a data table
hx<-read.table("features.txt")
##select the column heading names into a vector
colnames<-hx$V2
##rename the test table columns with the column names 
names(testc2)<-colnames
## Naming the 2 appended columns
names(testc2)[562]<-"participant"
names(testc2)[563]<- "activity"

##Read the train.txt files and related txt files into data tables
train <- read.table("./train/X_train.txt")
subjecttr <- read.table("./train/subject_train.txt")
activitytr <-read.table("./train/y_train.txt")
##merge the subject and activity tables to the test table
trainc1<- cbind(train,subjecttr)
trainc2<-cbind(trainc1,activitytr)
##rename the test table columns with the column names 
names(trainc2)<-colnames
## Naming the 2 appended columns
names(trainc2)[562]<-"participant"
names(trainc2)[563]<- "activity"


##Assignment 1 : Merge the test and train tables
DT<-rbind(testc2,trainc2)

##Assignment 2:Extracts only the measurements on the mean 
#####        and standard deviation for each measurement

MeanDT<-DT[grep("mean()",fixed = TRUE, names(DT))]
StdDT<- DT[grep("std()",names(DT))]

## Assignment 3: Uses descriptive activity names to name the activities in the data set

DT$activity <- as.character(DT$activity)
DT$activity[DT$activity == 1] <- "Walking"
DT$activity[DT$activity == 2] <- "Walking Upstairs"
DT$activity[DT$activity == 3] <- "Walking Downstairs"
DT$activity[DT$activity == 4] <- "Sitting"
DT$activity[DT$activity == 5] <- "Standing"
DT$activity[DT$activity == 6] <- "Laying"
DT$activity <- as.factor(DT$activity)

##Assignment 4:Appropriately labels the data set with descriptive variable names
names(DT) ###survey the names
### replace with descriptive variable names 
names(DT) <- gsub("Acc", "Accelerator", names(DT))
names(DT) <- gsub("Mag", "Magnitude", names(DT))
names(DT) <- gsub("Gyro", "Gyroscope", names(DT))
names(DT) <- gsub("^t", "time", names(DT))
names(DT) <- gsub("^f", "frequency", names(DT))
names(DT) <- gsub("-std$","StdDev",  names(DT))
names(DT) <- gsub("([Gg]ravity)","Gravity", names(DT)) 
names(DT) <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body", names(DT)) 
names(DT) ###survey the names

## Assignment 5 :From the data set in step 4, creates a second,
## independent tidy data set with the average of each variable
## for each activity and each subject

Master.DT <- data.table(DT)

#This takes the mean of every column broken down by participants and activities
TidyData <- Master.DT [, lapply(.SD, mean), by = 'participant,activity']
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)
