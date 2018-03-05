#Week 4 Assignment

#The submitted data set is tidy.
#The Github repo contains the required scripts.
#GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
#The README that explains the analysis files is clear and understandable.
#The work submitted for this project is the work of the student who submitted it.
#Getting and Cleaning Data Course Projectless 
#The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

#One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
  
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Here are the data for the project:
  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#--------------------------------------------

#set directory
setwd("C:/Users/wypwo/Documents/R Studio/Courses/Coursera Johns Hopkins Specialization in Data/Data")

## Read Data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")  



#--------------------------------------------
#1. Merges the training and the test sets to create one data set.

FullData <- rbind(x_train, x_test)
names(FullData) <- features[,2]
head(FullData)

#--------------------------------------------
#2. Extracts only the measurements on the mean and standard deviation for each measurement.

Mean_Std <- grep("mean|std", features[,2])
Data_Mean_Std <- FullData[, Mean_Std]

#--------------------------------------------
#3. Uses descriptive activity names to name the activities in the data set

# combine test and train of subject data and activity data, give descriptive lables
subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'

#Create column name for activity labels
names(activity_labels) <- c("activity", "activity_desc")


# combine subject, activity, and mean and std only data set to create final data set.
NewData <- cbind(subject, activity, Data_Mean_Std)

Merged <- merge(x=NewData, y=activity_labels, by="activity")


#--------------------------------------------
#4. Appropriately labels the data set with descriptive variable names.
#get rid of ()
names(Merged) <- gsub("[()]", "", names(Merged))

#add descriptive names
names(Merged) <- gsub("^t", "Time", names(Merged))
names(Merged) <- gsub("^f", "Freq", names(Merged))

str(Merged)

#--------------------------------------------
#5. From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.


tidy <- as.data.frame(Merged)

#group the data by subject and activity
tidy_group <- group_by(tidy, subject, activity_desc)
head(tidy_group)


# calculate all the means
tidy_mean <- summarise_all(tidy_group, funs(mean))
head(tidy_mean)
 
                            