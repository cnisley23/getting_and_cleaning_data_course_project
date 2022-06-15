
# Getting and Cleaning Data - Course Project 
  # cnisley23 

# fetch and unzip raw data
# Wrangle Data into data.frames 
# Fetch mean and Std Dev variables from data.frames 
# provide descriptive labels for features, variables, and columns 
# create tidied dataset with mean of variablse for activities and subjects


# id current working directory and target url of raw data ----
wd <- getwd()
url1 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'


# fetch and unzip raw data ---- 
if (!file.exists("data")) {
  dir.create("data")
}

download.file(url = url1, 
              destfile = "./data/GACD_project.zip")

if (!file.exists("./data/UCI HAR Dataset")) { 
  unzip("./data/GACD_project.zip") 
}


# wrangle data into data.frames ---- 
  # feature and activity labels 
activity_labs <- read.table("UCI HAR Dataset/activity_labels.txt", 
                            col.names = c("label_no", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", 
                       col.names = c("feature_no", "feature"))

  # train data 
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", 
                      col.names = features$feature)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                      col.names = "label_no")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt", 
                            col.names = "subject_label")

  # test data 
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", 
                     col.names = features$feature)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", 
                     col.names = "label_no")
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subject_label")

# bind sets 
x_df <- rbind(x_train, x_test)
y_df <- rbind(y_train, y_test)
s_df <- rbind(subj_train, subj_test)


# Fetch mean and Std Dev variables from data.frames ---- 
  # create indexes for targeted (ie mean and standard deviation features)
target_features <- grep(".*mean.*|.*std.*", 
                        as.character(features[, 2]))
  # tidy names up 
new_names <- features[target_features, 2]
new_names <- gsub("-mean", " Mean", new_names)
new_names <- gsub("-std", " Std", new_names)
new_names <- gsub("[-()]", "", new_names)


  # get targeted x submssions and merge 
x_df <- x_df[, target_features]
proj_df <- cbind(s_df, y_df, x_df)
colnames(proj_df) <- c("subject", 
                       "activity", 
                       new_names)

# tidy activities and subjects 
proj_df$activity <- factor(x = proj_df$activity, 
                           levels = activity_labs$label_no, 
                           labels = activity_labs$activity)
proj_df$subject <- as.factor(proj_df$subject)


# reshape data ---- 

proj_df_rs <- reshape2::melt(proj_df, 
                             id = c("subject", "activity"))
tidy_df <- reshape2::dcast(proj_df_rs, subject + activity ~ variable, mean)


# export with datestamp ---- 
write.table(tidy_df, 
            paste0("./data/tidy_df_", 
                   gsub("-", "", Sys.Date()), 
                   ".txt"),
            row.names = F)
