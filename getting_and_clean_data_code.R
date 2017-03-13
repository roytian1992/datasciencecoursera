library(dplyr)

#Download files to folder data
if(file.exists("./data")){unlink("./data", recursive = TRUE)}
dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## 1. Merges the training and the test sets to create one data set.

#Get data from files
DataFeaturesTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
DataFeaturesTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
DataActivityTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
DataActivityTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
DataSubjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
DataSubjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#Bind lines
DataFeatures <- rbind(DataFeaturesTrain, DataFeaturesTest)
DataActivity <- rbind(DataActivityTrain, DataActivityTest)
DataSubject <- rbind(DataSubjectTrain, DataSubjectTest)

#Name variables
DataFeaturesNames <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE)
names(DataFeatures) <- DataFeaturesNames$V2
names(DataActivity) <- c("Activity_ID")
names(DataSubject) <- c("Subject_ID")

#Merge training and test set
Dataset <- cbind( DataActivity, DataSubject)
Dataset <- cbind(DataFeatures, Dataset)


## 2. Extracts only the measurements on the mean and standard 
## deviation for each measurement.

#Select only names that have "mean(" or "std("
SelectedNames <- DataFeaturesNames$V2[grep("mean\\(|std\\(",DataFeaturesNames$V2)]

#Add to this list the "Activity_ID column"
SelectedNames <- c(as.character(SelectedNames), "Activity_ID", "Subject_ID")
SubDataset <- subset(Dataset, select=SelectedNames)


## 3. Uses descriptive activity names to name the activities 
## in the data set.

#Load Acitivity Labels
ActivityNames <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(ActivityNames) <- c("Activity_ID", "Activity")

#Merge the original Subdataset with the Activity labels
FinalData <- merge(SubDataset,ActivityNames,by='Activity_ID',all.x=TRUE);

#Remove Activity_ID column
FinalData <- select(FinalData, -Activity_ID);

## 4. Appropriately labels the data set with descriptive variable names.

names(FinalData) <- gsub("^t", "Time", names(FinalData))
names(FinalData) <- gsub("^f", "Frequence", names(FinalData))
names(FinalData) <- gsub("Acc", "Acceleration", names(FinalData))
names(FinalData) <- gsub("Mag", "Magnitude", names(FinalData))
names(FinalData) <- gsub("Gyro", "Gyroscope", names(FinalData))
names(FinalData) <- gsub("BodyBody", "Body", names(FinalData))
names(FinalData) <- gsub("\\()", "", names(FinalData))
names(FinalData) <- gsub("-mean", "Mean", names(FinalData))
names(FinalData) <- gsub("-std", "StdDev", names(FinalData))


## 5. From the data set in step 4, creates a second, independent tidy data 
## set with the average of each variable for each activity and each subject.

TidyData <- aggregate(select(FinalData,-Activity, -Subject_ID),by=list(Activity=FinalData$Activity,Subject_ID = FinalData$Subject_ID),mean);

#Write new dataset to a file
write.table(TidyData, file = "tidy_data.txt",row.name=FALSE)