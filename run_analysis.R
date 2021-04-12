library(tidyverse)

x_Test  <- read.table("X_test.txt")
x_Train <- read.table("X_train.txt")
names   <- read.table("features.txt")
names <- names[,2]

colnames(x_Test)  <- names
colnames(x_Train) <- names

x_Test_index_mean <- which( grepl("mean" , names(x_Test ))  & !(grepl("Freq" , names(x_Test ))) )
x_Test_sel_mean   <- x_Test[,x_Test_index_mean]

x_Test_index_std <- which( grepl("std" , names(x_Test ))  & !(grepl("Freq" , names(x_Test ))) )
x_Test_sel_std   <- x_Test[,x_Test_index_std]

x_Train_index_mean <- which( grepl("mean" , names(x_Train ))  & !(grepl("Freq" , names(x_Train ))) )
x_Train_sel_mean        <- x_Train[,x_Train_index_mean]

x_Train_index_std <- which( grepl("std" , names(x_Train ))  & !(grepl("Freq" , names(x_Train ))) )
x_Train_sel_std <- x_Train[,x_Train_index_std]




merged_Frame_mean <- rbind(x_Test_sel_mean, x_Train_sel_mean)
merged_Frame_std  <- rbind(x_Test_sel_std, x_Train_sel_std)

mean_Values_mean <- tibble(lapply(merged_Frame_mean, mean))
mean_Values_std  <- tibble(lapply(merged_Frame_std, mean))

names_mean  <- tibble(names(x_Test_sel_mean))
names_std  <- tibble(names(x_Test_sel_std))



final_Dataframe <- cbind(names_mean, mean_Values_mean)
final_Dataframe <- cbind(final_Dataframe, names_std)
final_Dataframe <- cbind(final_Dataframe, mean_Values_std)
colnames(final_Dataframe) <- c("Mean.Measurments" , "Mean.Values", "Std.Measurments" , "Std.Values" ) 

final_Dataframe <- as.matrix(final_Dataframe) 

write.table(final_Dataframe, "table.txt", row.names = FALSE, sep = "\t\t", header = TRUE)
