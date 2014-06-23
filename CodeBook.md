CodeBook for Getting and Cleaning Data Course Project
========================================================

This document describes the following data sets and the process used to create them. 

These data sets were derived from data available at
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip by running the run_analysis.R script.  The script is described in more detail in README.md.

## Data Set Descriptions

### tidydata.txt

This data set a tidy data set derived from the source data and is to be used for later analysis. The internal format is a CSV file created with write.csv(), but with a filetype of txt.

#### Variables Included
* **row number** - created by write.csv - no colname assigned. Use as rowname.
* **Subject** - the Subject ID from subject\_test.txt and subject\_train.txt.
* **Activity** - activity name corresponding to the activity codes in y\_train.txt and y\_test.txt.
* **feature variables**. The following features have mean and standard deviation values included as variables in the data set. Variables ending in "XYZ" are triaxial variables so a total of 6 variables included for each with names in the form feature-stat-A where feature is the feature name without "XYZ", stat is either "mean" or "std" for mean or standard deviation, and A is one axis (X, Y or Z). Non-triaxial features have 2 forms with have "-mean" or "-std" suffix to indicate it is a mean or a standard deviation.  
* tBodyAcc_XYZ  
* tGravityAcc_XYZ  
* tBodyAccJerk_XYZ  
* tBodyGyro_XYZ  
* tBodyGyroJerk_XYZ  
* tBodyAccMag  
* tGravityAccMag  
* tBodyAccJerkMag  
* tBodyGyroMag  
* tBodyGyroJerkMag  
* fBodyAcc_XYZ  
* fBodyAccJerk_XYZ  
* fBodyGyro_XYZ  
* fBodyAccMag  
* fBodyAccJerkMag  
* fBodyGyroMag  
* fBodyGyroJerkMag  

Details regarding the feature variables, data source, measurement techniques, and initial data transformations are available in the README.txt and the features\_info.txt files in the getdata\_projectfiles\_UCI HAR Dataset.zip file.

### tidyavgs.txt

This data set is derived from the tidy data set by calculating the mean for each variable for each Activity and for each Subject. The internal format is a CSV file created with write.csv(), but with a filetype of txt.

#### Variables Included
The column names are as follow
* unnamed first column to use as row names which contains the measurement variable names which match the column names in tidydata.txt.
* a column name for every combination of Subject and Activity from the tidydata.tst file. The format of the column names is S.A where S is the Subject ID from the Subject column of tidydata.txt and A is the activity name from the Activity column in tidydata.txt.

## Data Transformations

### tidydata.txt

The following steps were performed to transform the source data into tidydata.txt:
* Step 0.1 - Download zip file containing data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.  
* Step 0.2 - Unzip the data file.
* Step 1 - Load and merge the training and test sets to create one data set.
* Step 1.1 - Load features list (features.txt) to use as column names.
* Step 1.2 - Adjust feature names to valid column names.
* Step 1.3 - Load test data set using features as column names.
* Step 1.3.1 - Load the test data file (X_test.txt).
* Step 1.3.2 - Load the test subject data file (subject_test.txt).
* Step 1.3.3 - Load the test activity code data file (y_test.txt).
* Step 1.3.4 - Add the subject and activity columns to the test data file.
* Step 1.4 - Load training data set using features as column names.
* Step 1.4.1 - Load the train data file (X_train.txt).
* Step 1.4.2 - Load the train subject data file (subject_train.txt).
* Step 1.4.3 - Load the train activity code data file (y_train.txt).
* Step 1.4.4 - Add the subject and activity columns to the train data file.
* Step 1.5 - Merge test and training data sets into a single set.
* Step 2 - Extract only the mean and standard deviation for each measurement.
* Step 2.1 - Get complete set of column names.
* Step 2.2 - Select column names of measurement means. Excludes the averages of signal window samples.
* Step 2.3 - Select column names of measurement standard deviations.
* Step 2.4 - Select only mean, std dev, activity, and subject columns.
* Step 3 - Use descriptive activity names to name the activities in the data set.
* Step 3.1 - Load Activity names file (activity_labels.txt) into a data frame.
* Step 3.2 - Replace activity codes with activity names in data set.
* Step 3.3 - Drop the unneeded actcode column.
* Step 4 - Appropriately label the data set with descriptive variable names.
* Step 4.1 - Column names are already descriptive names from features.txt.
* Step 4.2 - Remove '..' left from forced conversion of '()'.
* Step 5 - Create a second, independent tidy data set with the average of each variable for each activity and each subject.
* Step 5.1 - Split the data set by Subject and Activity.
* Step 5.2 - Calculate means of each variable per Subject and Activity.
* Step 6 - Save tidy data set tidydata.txt.
* Step 7 - Save tidy data set averages tidyavgs.txt.

