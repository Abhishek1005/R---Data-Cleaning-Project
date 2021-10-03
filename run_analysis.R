library(dplyr)

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

#1)
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged <- cbind(subject, Y, X)


#2)
mean_sd_data <- select(merged, subject, code, contains("mean"), contains("std"))


#3)
mean_sd_data$code <- activities[mean_sd_data$code, "activity"]


#4)
names(mean_sd_data)[2] = "activity"
names(mean_sd_data)<-gsub("Acc", "Accelerometer", names(mean_sd_data))
names(mean_sd_data)<-gsub("Gyro", "Gyroscope", names(mean_sd_data))
names(mean_sd_data)<-gsub("BodyBody", "Body", names(mean_sd_data))
names(mean_sd_data)<-gsub("Mag", "Magnitude", names(mean_sd_data))
names(mean_sd_data)<-gsub("^t", "Time", names(mean_sd_data))
names(mean_sd_data)<-gsub("^f", "Frequency", names(mean_sd_data))
names(mean_sd_data)<-gsub("tBody", "TimeBody", names(mean_sd_data))
names(mean_sd_data)<-gsub("-mean()", "Mean", names(mean_sd_data))
names(mean_sd_data)<-gsub("-std()", "STD", names(mean_sd_data))
names(mean_sd_data)<-gsub("-freq()", "Frequency", names(mean_sd_data))
names(mean_sd_data)<-gsub("angle", "Angle", names(mean_sd_data))
names(mean_sd_data)<-gsub("gravity", "Gravity", names(mean_sd_data))


#5)
Final <- mean_sd_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)
write.table(Final, "Final.txt", row.names = F)

head(Final,5)
