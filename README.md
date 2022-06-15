# getting_and_cleaning_data_course_project  

### *Purpose *  
Course project for Coursera's Getting and Cleaning Data.  

#### The R script contained here (run_analysis.R) performs the following actions:

1. Creates a `./data/` directory if it doesn't already exist, one level up from working directory. 
2. Downloads and unzips dataset into the `./data/` directory.
3. Reads data into current R session as separated CSV files.
4. Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation
5. Creates tidied data.frames of targeted features and activities and provides readable labels. 
6. Binds the training and test data.
7. Reshape data by Subject and Activity and provide mean value of targeted metrics. 
8, Write the data to new directory that is tidy_df_ followed by a datestamp, indicating date of creation.  For example, `tidy_df_20220614.txt`.
