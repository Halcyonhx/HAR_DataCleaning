
####### create testSet ###############
feature <- read.table("./HAR/features.txt", header = FALSE)
activityID <- read.table("./HAR/activity_labels.txt", header = FALSE)

test_feature <- read.table("./HAR/test/X_test.txt", header = FALSE)
activity <- read.table("./HAR/test/y_test.txt", header = FALSE)
colnames(activity) <- "activityID"
subjectID <- read.table("./HAR/test/subject_test.txt", header = FALSE)
colnames(subjectID) <- "subjectID"
colnames(test_feature) <- feature$V2
testSet <- cbind(subjectID, activity, test_feature)
testSet <- merge(testSet, activityID, by.x = "activityID", by.y = "V1")
testSet$type = rep("test", nrow(testSet))

######## creat trainSet ##############
train_feature <- read.table("./HAR/train/X_train.txt", header = FALSE)
activity <- read.table("./HAR/train/y_train.txt", header = FALSE)
colnames(activity) <- "activityID"
subjectID <- read.table("./HAR/train/subject_train.txt", header = FALSE)
colnames(subjectID) <- "subjectID"
colnames(train_feature) <- feature$V2
trainSet <- cbind(subjectID, activity, train_feature)
trainSet <- merge(trainSet, activityID, by.x = "activityID", by.y = "V1")


######### Merge two dataset #############
UniData <- rbind(trainSet,testSet)


########## Extract mean and standard deviation of each measurement ##########
SubData <- UniData[,grepl("mean", colnames(UniData)) | grepl("std", colnames(UniData))]
SubData <- cbind(UniData$subjectID, cbind(as.character(UniData$V2)), SubData)
library(dplyr)
SubData <- rename(SubData, SubjectID = "UniData$subjectID", Activity = "cbind(as.character(UniData$V2))")

############## Calculate mean for each activity of each subject ################
mean <- aggregate(SubData, by = list(SubData$Activity,SubData$SubjectID), mean)

############# Adjusting column order ####################
mean$Group.2 <- NULL
mean$Activity <- as.character(mean$Group.1)
mean$Group.1 <- NULL

write.table(mean, file = "tidyMean.txt", sep = " ")

############## Creating a code book

