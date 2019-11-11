## Loading required packages
library(dplyr)


## Download and unzip the dataset
filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}


## Assign all data frames: features, labels, activities, subjects, train and test data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("label", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "label")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "label")


## Step 1: Merges the training and the test sets to create one data set.
Merged_Data <- cbind(rbind(subject_train, subject_test), rbind(y_train, y_test), rbind(x_train, x_test))


## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
Selected_Data <- Merged_Data %>% select(subject, label, contains("mean"), contains("std"))


## Step 3: Uses descriptive activity names to name the activities in the data set.
Selected_Data$label <- activities[Selected_Data$label, 2]


## Step 4: Appropriately labels the data set with descriptive variable names.
names(Selected_Data)[2] <- "activity"
names(Selected_Data)<-gsub("^t", "TimeDomain", names(Selected_Data))
names(Selected_Data)<-gsub("^f", "FrequencyDomain", names(Selected_Data))
names(Selected_Data)<-gsub("Acc", "Accelerometer", names(Selected_Data))
names(Selected_Data)<-gsub("Gyro", "Gyroscope", names(Selected_Data))
names(Selected_Data)<-gsub("BodyBody", "Body", names(Selected_Data)) # correct typo
names(Selected_Data)<-gsub("Mag", "Magnitude", names(Selected_Data))
names(Selected_Data)<-gsub("mean", "Mean", names(Selected_Data), ignore.case = TRUE)
names(Selected_Data)<-gsub("std", "STD", names(Selected_Data), ignore.case = TRUE)
names(Selected_Data)<-gsub("angle", "Angle", names(Selected_Data))
names(Selected_Data)<-gsub("gravity", "Gravity", names(Selected_Data))


## Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# group by subject and activity, summarize using mean
Tidy_Data <- Selected_Data %>%
  group_by(subject, activity) %>%
  summarize_each(funs(mean))
# write final date to .csv file 
write.csv(Tidy_Data, "Final_Tidy_Data.csv")

