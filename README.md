ReadMe for Getting and Cleaning Data Course Project
========================================================

This document describes how the script run_analysis.R produces the tidy data files described in CodeBook.md.

The maketidy() function in run_analysis.R controls the overall process to perform the steps to transform the source data into tidydata.txt.  
  
#### Step 0.1 - Download zip file containing data  
* This step is performed by a call to the getzip() function.  

* The data was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip into a file with name getdata\_projectfiles\_UCI HAR Dataset.zip into the current working directory.  

#### Step 0.2 - Unzip the data file.  
* This step is performed by a call to the dounzip() function.  

* The zip file is extracted into the current working directory and allowed to expand the original directory structure which is known by this script.  

#### Step 1 - Load and merge the training and test sets to create one data set.  
* For step 1.x processing maketidy() invokes the mergetesttraining() function.  

#### Step 1.1 - Load features list (features.txt) to use as column names.  
* Processed in the mergetesttraining() function.  

#### Step 1.2 - Adjust feature names to valid column names.  
* Processed in the mergetesttraining() function.  

#### Step 1.3 - Load test data set using features as column names.  
* For step 1.3 the mergetesttraining() function calls the loaddataset() function passing "test" to request that the test data set be loaded. All steps 1.3.x are all performed in loaddataset() function.  

#### Step 1.3.1 - Load the test data file (X_test.txt).  
* read.table is used to read X_test.txt into a data frame specifying the colnames using the column of feature names in the data set loaded from features.txt.  

#### Step 1.3.2 - Load the test subject data file (subject_test.txt).  
* read.table is used to read subject_test.txt into a data frame.  

#### Step 1.3.3 - Load the test activity code data file (y_test.txt).  
* read.table is used to read y_test.txt into a data frame.  

#### Step 1.3.4 - Add the subject and activity columns to the test data file.  
* cbind is used to concatenate the pieces of the data set since all 3 data sets have the same record order.  

#### Step 1.4 - Load training data set using features as column names.  
* For step 1.4 the mergetesttraining() function calls the loaddataset() function passing "train" to request that the train data set be loaded. All steps 1.4.x are all performed in loaddataset() function.  

#### Step 1.4.1 - Load the train data file (X_train.txt).  
* read.table is used to read X_train.txt into a data frame specifying the colnames using the column of feature names in the data set loaded from features.txt.  

#### Step 1.4.2 - Load the train subject data file (subject_train.txt).  
* read.table is used to read subject_train.txt into a data frame.  

#### Step 1.4.3 - Load the train activity code data file (y_train.txt).  
* read.table is used to read y_train.txt into a data frame.  

#### Step 1.4.4 - Add the subject and activity columns to the train data file.  
* cbind is used to concatenate the pieces of the data set since all 3 data sets have the same record order.  

#### Step 1.5 - Merge test and training data sets into a single set.  
* mergetesttraining() combines the test and training data sets into a single data set using rbind().  

#### Step 2 - Extract only the mean and standard deviation for each measurement.  
* maketidy() invokes the meanandstddev() function for this step.

#### Step 2.1 - Get complete set of column names.  
* meanandstddev() uses colnames to get the set of column names.

#### Step 2.2 - Select column names of measurement means. Excludes the averages of signal window samples.  
* meanandstddev() uses grep to select from the set of column names the names of the columns for mean() variables.

#### Step 2.3 - Select column names of measurement standard deviations.  
* meanandstddev() uses grep to select from the set of column names the names of the columns for std() variables.

#### Step 2.4 - Select only mean, std dev, activity, and subject columns.  
* A revised set of column names including the 2 sets produced by grep plus the columns "Subject", and "Activity" are used to select the subset of columns of the dataset to retain.

#### Step 3 - Use descriptive activity names to name the activities in the data set.  
* maketidy() invokes the actnames() function for this step.

#### Step 3.1 - Load Activity names file (activity_labels.txt) into a data frame.  
* actnames() loads activity_labels.txt into a data frame.

#### Step 3.2 - Replace activity codes with activity names in data set.  
* actnames merges the measurement data data frame and activity names data frames by the activity code column.

#### Step 3.3 - Drop the unneeded actcode column.  
* actnames drops the activity code (actcode) columns since it is no longer needed.

#### Step 4 - Appropriately label the data set with descriptive variable names.  
* maketidy() invokes the adjustnames() function for this step.

#### Step 4.1 - Column names are already descriptive names from features.txt.  
* The existing column names from features.txt are the basis for these column names.  Earlier processing had to make changes for characters not allowed in column names.  Therefore "()" was converted to "__" and "-" was converted to "_"/

#### Step 4.2 - Remove '__' left from forced conversion of '()'.  
* The "__" from the "()" is unnecessary in the column names so it is removed using gsub().

#### Step 5 - Create a second, independent tidy data set with the average of each variable for each activity and each  subject.  
* maketidy() invokes the avgvars() function for this step.

#### Step 5.1 - Split the data set by Subject and Activity.  
* avgvars() uses the split function to split the data set by Subject and Activity.

#### Step 5.2 - Calculate means of each variable per Subject and Activity.  
* avgvars() uses sapply() with colmeans() on the split data set to calculate the mean of each variable by Subject and Activity.

#### Step 6 - Save tidy data set tidydata.txt.  
* maketidy() uses write.csv to save tidydata.txt.

#### Step 7 - Save tidy data set averages tidyavgs.txt.  
* maketidy() uses write.csv to save tidyavgs.txt.
