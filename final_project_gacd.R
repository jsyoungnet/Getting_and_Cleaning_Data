##
##
##  Final Project
##  JHU Getting and Cleaning Data
##
##  Jeff Young
##  8 April, 2017
##
##
##  Clean the follwing dataset (and it's a mess)
##
## For each record it is provided:
## ======================================
##  
##  - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
##  - Triaxial Angular velocity from the gyroscope. 
##  - A 561-feature vector with time and frequency domain variables. 
##  - Its activity label. 
##  - An identifier of the subject who carried out the experiment.
##
## The dataset includes the following files:
## =========================================
##  
##  - 'README.txt'
##
##  - 'features_info.txt': Shows information about the variables used on the feature vector.
##
##  - 'features.txt': List of all features.
##
##  - 'activity_labels.txt': Links the class labels with their activity name.
##
##  - 'train/X_train.txt': Training set.
##
##  - 'train/y_train.txt': Training labels.
##
##  - 'test/X_test.txt': Test set.
##
##  - 'test/y_test.txt': Test labels.
##
##

# DEFINITIONS
#
# Where are the files located in my directory structure?
#
FILE_LOC <- "~/Developer/Learning_R/Coursera Class in Getting and Cleaning Data/UCI HAR Dataset/"
TRAINING_LOC <- "train/"
TEST_LOC <- "test/"
TRAINING_FILE <- "X_train.txt"
TEST_FILE <- "X_test.txt"
TEST_PREDICTOR <- "y_test.txt"
TRAINING_PREDICTOR <- "y_train.txt"
SUBJECT_TRAIN <- "subject_train.txt"
SUBJECT_TEST <- "subject_test.txt"
#
# DATA LABELS
#
# pull the data labels from the text files
#
feature_names <- read.table(paste(FILE_LOC, "features.txt", sep = ""), header = FALSE, col.names = c("index", "Measurement"), stringsAsFactors = FALSE)
activity_labels <- read.table(paste(FILE_LOC, "activity_labels.txt", sep=""), header=FALSE, col.names = c("level", "Activity"))
#
# TRAINING DATA
#
# get the training data and use the feature names as column labels from above
#
training_data <- read.table(paste(FILE_LOC, TRAINING_LOC, TRAINING_FILE, sep=""), header=FALSE, col.names=feature_names$Measurement)
#
# the predictors (the activity each subject was performing when the data was captured)
#
training_prediction <- read.table(paste(FILE_LOC, TRAINING_LOC, TRAINING_PREDICTOR, sep = ""), header = FALSE, col.names = "Activity")
#
# make this prediction data into a factor column
#
training_prediction$Activity <- as.factor(training_prediction$Activity)
levels(training_prediction$Activity) <- activity_labels$Activity
#
#combine the training data with activity data
#
training_data <- mutate(training_data,Activity = training_prediction$Activity)
#
# add in the subject identifier
#
training_subjects <- read.table(paste(FILE_LOC, TRAINING_LOC, SUBJECT_TRAIN, sep=""), header = FALSE, col.names = "Subject")
training_data <- cbind(training_data, training_subjects)
#
# TEST DATA
#
# get the test data and use the feature names as column labels from above
#
test_data <- read.table(paste(FILE_LOC, TEST_LOC, TEST_FILE, sep=""), header=FALSE, col.names=feature_names$Measurement)
#
# the predictors (the activity each subject was performing when the data was captured)
#
test_prediction <- read.table(paste(FILE_LOC, TEST_LOC, TEST_PREDICTOR, sep = ""), header = FALSE, col.names = "Activity")
#
# make this prediction data into a factor column
#
test_prediction$Activity <- as.factor(test_prediction$Activity)
levels(test_prediction$Activity) <- activity_labels$Activity
#
#combine the training data with activity data
#
test_data <- mutate(test_data,Activity = test_prediction$Activity)
#
#
# add in the subject identifier
#
test_subjects <- read.table(paste(FILE_LOC, TEST_LOC, SUBJECT_TEST, sep=""), header = FALSE, col.names = "Subject")
test_data <- cbind(test_data, test_subjects)

#
# COMBINE THE DATA
#
total_data <- rbind(test_data, training_data)
#
# SELECT THE MEAN AND STD OF THE DATA
#
#total_mean_data <- as.data.frame(t(sapply(total_data[,1:ncol(total_data)-1], 
#                                                       function(the_func) list(mean=mean(the_func, na.rm=TRUE), 
#                                                                               s_dev=sd(the_func,na.rm=TRUE) ))))

mean_data <- select(total_data, contains("mean"))
sdev_data <- select(total_data, contains("std"))
#
# put the Activities and the Sujects back into the data
#
activity_subject <- c("Activity", "Subject")
activity_subject_data <- select(total_data, one_of(activity_subject))
#
# combine all three
#
mean_sdev_dataset <- cbind(mean_data, sdev_data, activity_subject_data)
#
# summarise the table grouped by Activity and then by Subject
#
summary_dataset <- as.data.frame(mean_sdev_dataset %>% group_by(Activity, Subject) %>% summarise_each(funs(mean)))



