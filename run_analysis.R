library(tidyverse)

#Reading in the data from text
names        <- read.table("features.txt")
var.names    <- (names$V2)
testSubjects <- rbind( (read.table("subject_test.txt" , header =  FALSE)) , 
                       (read.table("subject_train.txt" , header =  FALSE)))
x_Test  <- read.table("X_test.txt" , header =  FALSE)
y_Test  <- read.table("y_test.txt" , header =  FALSE)
x_Train <- read.table("X_train.txt", header =  FALSE)
y_Train <- read.table("y_train.txt", header =  FALSE)

#Appropriately labels the data set with descriptive variable names. 
colnames(y_Test)   <- "Activity"
colnames(y_Train)  <- "Activity"
colnames(testSubjects) <- "testSubjects"
colnames(x_Test)   <- c(var.names)
colnames(x_Train)  <- c(var.names)

#Merging training and test sets to create one data set. 
merged_sets <- rbind(x_Test, x_Train)
column_Idxs <- which(grepl("(mean()|std())\\(\\)" , names(merged_sets)))

#Giving descriptive activity names the activities in the data set
merged_names <- rbind(y_Test, y_Train)
merged_names$Activity <- recode(merged_names$Activity,
                      "1" = "WALKING",
                      "2" = "WALKING_UPSTAIRS",
                      "3" = "WALKING_DOWNSTAIRS",
                      "4" = "SITTING",
                      "5" = "STANDING",
                      "6" = "LAYING",
)

#Extracting only mean and standard deviation for each measurement
selected_Data <- cbind(merged_names, merged_sets[,column_Idxs])
selected_Data$testSubjects   <- testSubjects$testSubjects

#Creating second, independent tidy data set with the average of each variable for each activity and each subject
selected_Data  <- selected_Data %>% group_by(Activity, testSubjects) %>% summarise(across((1:66), mean), .groups="keep")

#Writing table file 
write.table(selected_Data, "table.txt", row.names = FALSE)
