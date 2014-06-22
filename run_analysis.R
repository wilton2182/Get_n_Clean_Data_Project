# Generate the tidy data set from the Samsung data.

## Get the zip file 
getzip <- function(basedir){
        ## Download the data file from the course web site to the working directory.
        ## The working directory is assumed to be where this script resides.
        zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipfn <- "getdata_projectfiles_UCI HAR Dataset.zip"
        localzip <- paste(basedir,"/",zipfn,sep="")
        setInternet2(TRUE)
        download.file(zipURL,destfile=localzip)
        zipfn
}

## Unzip the specified file into the working directory.
dounzip <- function(basedir,zipfn){
        ## extract the files from the zip file.
        unzip(zipfn,exdir = basedir)
        ## What gets returned by this function?
        # There are too many files and a multi-level directory structure.
        zipinfo <- unzip(zipfn,list=TRUE)
        zipinfo
}

loaddataset <- function(datadir,typ,featdf) {
        typnum <- ifelse(typ=="test","3","4")
        print(paste("Step 1.",typnum,".1 - Load the ",typ," data file.",
                    sep=""))
        datafile <- paste(datadir,"/","X_",typ,".txt",sep="")
        datadf <- read.table(
                datafile, header=FALSE, col.names=featdf
        )
        
        print(paste("Step 1.",typnum,".2 - Load the ",typ,
                    " subject data file.",sep=""))
        subfile <- paste(datadir,"/","subject_",typ,".txt",sep="")
        subdf <- read.table(
                subfile, header=FALSE, col.names=c("Subject"),
                colClasses=c("character")
        )
        
        print(paste("Step 1.",typnum,".3 - Load the ",typ,
                    " activity code data file.",sep=""))
        actfile <- paste(datadir,"/","y_",typ,".txt",sep="")
        actdf <- read.table(
                actfile, header=FALSE, col.names=c("actcode"),
                colClasses=c("character")
        )

        print(paste("Step 1.",typnum,".4 - Add the subject and activity",
                    " columns to the ",typ," data file.",sep=""))
        typdf <- cbind(subdf,actdf,datadf)
        typdf
}

## Merge the test and training data sets
mergetesttraining <- function(basedir){
        ## Define constants for location of input files.
        maindatadir <- paste(basedir,"/","UCI HAR Dataset",sep="")
        testdatadir <- paste(maindatadir,"/","test",sep="")
        trainingdatadir <- paste(maindatadir,"/","train",sep="")
        
        print("Step 1.1 - Load features list to use as column names.")
        ## Create a data set of the feature names
        featuresfile <- paste(maindatadir,"/","features.txt",sep="")
        featdf <- read.table(
                featuresfile, header=FALSE, col.names=c("featcode","featname"),
                colClasses=c("character","character")
        )
        
        print("Step 1.2 - Adjust feature names to valid column names.")
        ## Convert "-" to "_".
        featnames <- gsub("-","_",featdf$featname)
        ## Convert "()" to "__" for use in column names.
        featnames <- gsub("\\(\\)","__",featnames)
        
        print("Step 1.3 - Load test data set using features as column names.")
        ## Load the test data set.
        testdata <- loaddataset(testdatadir,"test",featnames)
        
        print("Step 1.4 - Load training data set using features as column names.")
        ## Load the training data set.
        trainingdata <- loaddataset(trainingdatadir,"train",featnames)
        
        print("Step 1.5 - Merge test and training data sets into a single set.")
        ## merge the test and training data sets.
        mergeddata <- rbind(testdata,trainingdata)
        mergeddata
}

meanandstddev <- function(df){
        print("Step 2.1 - Get complete set of column names.")
        ## extract the current column names into an array.
        allcols <- colnames(df)

        ## Force meanFreq to not match search for mean.
        allcols <- gsub("meanFreq","FreqMean",allcols)
        
        print("Step 2.2 - Select column names of measurement means.")
        print("         - Excludes the averages of signal window samples.")
        meancols <- grep(".*_mean__.*",allcols,value=TRUE)
        
        print("Step 2.3 - Select column names of measurement standard deviations.")
        stddevcols <- grep(".*_std__.*",allcols,value=TRUE)
        
        print("Step 2.4 - Select only mean, std dev, activity, and subject columns.")
        othercols <- c("actcode","Subject")
        keepcols <- c(othercols,meancols,stddevcols)
        df <- df[,keepcols]
        df
}

actnames <- function(basedir,df){
        print("Step 3.1 - Load Activity names file into a data frame.")
        maindatadir <- paste(basedir,"/","UCI HAR Dataset",sep="")
        activityfile <- paste(maindatadir,"/","activity_labels.txt",sep="")
        actdf <- read.table(
                activityfile, header=FALSE, col.names=c("actcode","Activity"),
                colClasses=c("character","character")
        )
        
        print("Step 3.2 - Replace activity codes with activity names in data set.")
        df <- merge(df,actdf)
        
        print("Step 3.3 - Drop the unneeded actcode column.")
        df <- df[,!(colnames(df) %in% c("actcode"))]
        df
}

adjustnames <- function(df){
        print("Step 4.1 - Column names are descriptive names from features.txt.")
        allcols <- colnames(df)
        
        print("Step 4.2 - Remove '..' left from forced conversion of '()'.")        ## extract the current column names into an array.
        allcols <- gsub("__","",allcols)
        
        colnames(df) <- allcols
        df                
}


avgvars <- function(df){
        print("Step 5.1 - Split the data set by Subject and Activity.")
        s <- split(df,df[,c("Subject","Activity")])
        avgs <- sapply(s,function(x) colMeans(x[,!(colnames(x) %in% c("Activity","Subject"))]))
        avgs        
}

## This is the main function that generated the tidy data set.
maketidy <- function(){
        # The current working directory will be used as the working directory.
        basedir <- "."
        print("Step 0.1 - Download zip file containing data.")
        zipfile <- getzip(basedir)               # download the zip file
        print("Step 0.2 - Unzip the data file.")
        zipinf <- dounzip(basedir, zipfile)      # extract the data file 
        print("Step 1 - Load and merge the training and test sets to create one data set.")
        mdf <- mergetesttraining(basedir)        # merge test and training data
        print("Step 2 - Extract only the mean and standard deviation for each measurement.")
        mdf <- meanandstddev(mdf)                # keep only mean and std dev measurement data.
        print("Step 3 - Use descriptive activity names to name the activities in the data set.")
        mdf <- actnames(basedir,mdf)             # Load activity names to use in place of codes.
        print("Step 4 - Appropriately label the data set with descriptive variable names.")
        mdf <- adjustnames(mdf)                  # Adjust the variable (column names).

        print("Step 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.")
        avgmdf <- avgvars(mdf)                   # calculate variable averages.
        
        print("Step 6 - Save tidy data set.")
        mdffile <- write.csv(mdf,"tidydata.txt")

        print("Step 7 - Save tidy data set averages.")
        avgfile <- write.csv(avgmdf,"tidyavgs.txt")
        
        "Files tidydata.csv and tidyavgs.csv have been created."
}


