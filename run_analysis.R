#setting the working directory
setwd("~/Desktop/tampa/Coursera/data/UCI HAR Dataset")

#reading the activity_labels.txt and features.txt files
act_labels <- read.table("./activity_labels.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
head(act_labels)
features <- read.table("./features.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
head(features)

#getting the test data

#reading the subject_test.txt file, identifying the volunteers taking the test
sub_test <- read.table("./test/subject_test.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
head(sub_test)
dim(sub_test)

#reading the X_test.txt file, with the 561 variables of interest for each of the 2947 observations for testing
Xtest <- read.table("./test/X_test.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
str(Xtest)

#reading the y_test.txt file, identifying the activity performed in each observation for testing
ytest <- read.table("./test/y_test.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
str(ytest)

#"merging" together the above info: the volunteers' id, the variables for each of them and the activity they were doing while testing
test <- cbind(sub_test, Xtest, ytest)
dim(test)
str(test)

#getting the train data

#reading the subject_train.txt file, identifying the volunteers training the algorithm (assuming there was a later algorithm 
#using this data)
sub_train <- read.table("./train/subject_train.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
dim(sub_train)

#reading the X_train.txt file, with the 561 variables of interest for each of the 7352 observations for training the algorithm
Xtrain <- read.table("./train/X_train.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
str(Xtrain)

#reading the y_train.txt file, identifying the activity performed in each observation for training
ytrain <- read.table("./train/y_train.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
str(ytrain)

#"merging" together the above info: the volunteers' id, the variables for each of them and the activity they were doing while training
train <- cbind(sub_train, Xtrain, ytrain)
dim(train)
str(train)

#"merging" together the training and testing data, into a 10299 x 563 table
my_data <- rbind(train, test)
str(my_data)


#reading the indices of the elements in the second column in the "features" data frame that contain a mean() or a std() measurement
indices <- grep("mean()|std()", features$V2)
str(indices)

# we select only the data with the respective indices from the merged data, keeping the first column of individuals ID and the last 
# of activities
library(dplyr)
my_data_selected <- as_tibble(my_data_selected)
my_data_selected <- select(my_data, c(1, indices+1, 563))
str(my_data_selected)

#we give some names to the columns in the data frame
names(my_data_selected) <- c("Volunteer ID", features$V2[indices], "Activity Performed")
str(my_data_selected)

# We give descriptive names to the activities in the data set, instead of numbers
for (i in seq_len(dim(my_data_selected)[1])){
      lbl <- my_data_selected$Activity_Performed[i]
      my_data_selected$Activity_Performed[i] <- as.character(my_data_selected$Activity_Performed[i])
      my_data_selected$Activity_Performed[i] <- act_labels$V2[as.numeric(lbl)]
   }
str(my_data_selected$Activity_Performed)

#We still remove some variables that had "meanFreq" in their name
my_data_selected_plus <- select(my_data_selected, -contains("meanFreq", ignore.case = FALSE, vars = current_vars()))

#Better names for the variables
names(my_data_selected_plus) <- sub("^t","Time Domain ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("^f","Frequency Domain ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("(Body)*Acc","Body Acceleration ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("GravityAcc","Gravity Acceleration ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("-mean\\(\\)","Signal Average ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("-std\\(\\)","Signal Standard Deviation ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("-X","on the X axis ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("-Y","on the Y axis ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("-Z","on the Z axis ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("Jerk","Jerk Signal ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("(Body)*Gyro","Body Gyroscope ", names(my_data_selected_plus))
names(my_data_selected_plus) <- sub("Mag","Magnitude ", names(my_data_selected_plus))

#create a new data frame that contains the averages per persona and activity for each variable
final_data <- group_by(my_data_selected_plus, my_data_selected_plus$Volunteer_ID, my_data_selected_plus$Activity_Performed)
final <- summarize_at(final_data, vars(2:67), mean, na.rm = TRUE)

#repairing some names
names(final)[1:2] <- c("Volunteer_ID", "Activity_Performed")

#write the result in a file
write.table(final, "./my_submission.csv")