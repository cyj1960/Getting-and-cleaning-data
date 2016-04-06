

## load data
if(!file.exists("./data")) {dir.create("./data")}

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile = "./data/dataset.zip")

unzip("./data/dataset.zip", exdir = "./data")

path <- "./data/UCI HAR Dataset"

## merge training and testing datasets
testActivity <- read.table(file.path(path, "test", "y_test.txt"), header=F)
trainActivity <- read.table(file.path(path, "train", "y_train.txt"), header = F)
Activity <- rbind(testActivity,trainActivity)

testFeature <- read.table(file.path(path, "test", "X_test.txt"), header=F)
trainFeature <- read.table(file.path(path, "train", "X_train.txt"), header=F)
Feature <- rbind(testFeature, trainFeature)

testSubject <- read.table(file.path(path, "test", "subject_test.txt"), header=F)
trainSubject <- read.table(file.path(path, "train", "subject_train.txt"), header = F)
Subject <- rbind(testSubject, trainSubject)

## assign variable names

names(Activity) <- "Activity"
names(Subject) <- "Subject"
featureNames <- read.table(file.path(path,"features.txt"), header=F)
names(Feature) <- featureNames[,2]

## extracts only the measurements on the mean and standard deviation

subFeature <- Feature[,grep(("mean|std"), featureNames[,2])]

## use descriptive activity names to name the activities

activityLabels <- read.table(file.path(path, "activity_labels.txt"), header=F)

Activity$Activity <- factor(Activity$Activity, labels=activityLabels[,2])

## merge datasets into one

dat <- cbind(Subject, Activity, subFeature)

## Appropriately labels the data set with descriptive variable names

names(dat) <- gsub("^t", "time", names(dat))
names(dat) <- gsub("^f", "frequency", names(dat))
names(dat) <- gsub("Acc", "Accelerometer", names(dat))
names(dat) <- gsub("Gyro", "Gyroscope", names(dat))
names(dat) <- gsub("Mag", "Magnitude", names(dat))
names(dat) <- gsub("BodyBody", "Body", names(dat))


## create a second, independent tidy data set 

dat2 <- aggregate(.~Subject + Activity, dat, mean)
write.table(dat2, file="tidydata.txt", row.names = F)

