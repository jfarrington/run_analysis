run_analysis.R
==============================================
DESCRIPTION:

This function extracts the training and test datasets from the "Human Activity Recognition Using 
Smartphones Dataset Version 1.0" producing a tidy dataset with the mean and std measurements. 
This dataset is then used to form an independent dataset with the averages of all the values.
NOTE:Requires dplyr and plyr libraries

==============================================
INSTALLATION:

Copy the "analysis" folder under "UCI HAR Dataset" (i.e.UCI HAR Dataset/analysis)

==============================================
OPERATION:

1) Load dplyr and plyr libraries
2) Set "UCI HAR Dataset" to be your working directory.
3) source "run_analysis.R" and run.
4) The script will generate two datasets on the work environment and save them in CSV format in the "analysis" folder
The dataset and file names are:
	-data_tidy: Tidy dataset with the mean and standard deviation for each measurement.
	-data_tidy_average: Independent tidy data set with the average of each variable for each activity and each subject.
