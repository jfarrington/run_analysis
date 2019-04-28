run_analysis<-function(){
    #This function extracts the training and test datasets producing a tidy dataset
    #with the mean and std measurements. This dataset is then used to form an independent 
    #dataset with the averages of all the values.
    #NOTE:Requires dplyr and plyr libraries
    
    #Step 1: Merge the training and the test sets to create one data set
    print("1) Merging training and test sets...")
    ##Load Activity and Feature Labels
    activity_labels<-read.table("activity_labels.txt")
    feature_labels<-read.table("features.txt")
    
    ##Load Training data"
    train_data<-read.table("train/X_train.txt")
    train_labels<-read.table("train/y_train.txt")
    train_subject<-read.table("train/subject_train.txt")
    
    ##"Load test data"
    test_data<-read.table("test/X_test.txt")
    test_labels<-read.table("test/y_test.txt")
    test_subject<-read.table("test/subject_test.txt")
    
    ##Combine Training data (subject,activity and data)
    train_data_combined<-cbind(train_subject,train_labels,train_data)
    
    ##Combine Test data (subject,activity and data)
    test_data_combined<-cbind(test_subject,test_labels,test_data)
    
    ##Add labels to data
    data_column_names<-c("subject","activity",as.character(feature_labels$V2))
    colnames(test_data_combined)<-data_column_names
    colnames(train_data_combined)<-data_column_names
    
    ##Merge the training and the test sets 
    data_combined<-rbind(train_data_combined,test_data_combined)
 
    #Step 2: Extract only the measurements on the mean and standard deviation for each measurement.")
    print("2) Extracting mean and standard deviations for each measurement...")
    data_subset<-data_combined[grepl("std|[Mm]ean|subject|activity",colnames(data_combined))==TRUE]
    
    #Step 3: Use descriptive activity names to name the activities in the data set"
    print("3) Changing activity indexes to descriptive names...")
    ##Create index key
    colnames(activity_labels)<-c("index", "label")
    
    ##Change index key class to character (to avoid weird issues)
    activity_labels$index<-as.character(activity_labels$index)
    activity_labels$label<-as.character(activity_labels$label)
    
    ##Map index key values into the dataset
    data_subset$activity<-mapvalues(data_subset$activity,activity_labels$index,activity_labels$label)
   
    #Step 4:Appropriately label the data set with descriptive variable names
    print("4) Re-labeling data with descriptive variable names.") 
    ##Modify columns names to be more "descriptive"
    colnames(data_subset)<-gsub("BodyBody","Body",names(data_subset)) #Fixes naming error
    colnames(data_subset)<-gsub("\\,gravity","_and_gravity",names(data_subset)) #Elliminates commas
    colnames(data_subset)<-gsub("\\()","",names(data_subset)) #Removes '()'
    
    ##Order data by subject then by activity
    data_subset_tidy<-data_subset[order(data_subset$subject,data_subset$activity),]#Send to workspace
    data_tidy<<-data_subset_tidy
    print("**Tidy dataset 'data_tidy'created")
    
    #Step 5:Create a second, independent tidy data set with the average of each variable for each activity and each subject.
    print("5) Creating data set with the average of each variable for each activity and each subject...")
    data_subset_tidy_avg<-data_subset_tidy %>% group_by(subject,activity)%>%summarise_all(mean)
    ##Rename columns
    colnames(data_subset_tidy_avg)<-paste(names(data_subset_tidy_avg),"AVG",sep="_")
    colnames(data_subset_tidy_avg)[1]<-'subject'
    colnames(data_subset_tidy_avg)[2]<-'activity'
    
    data_tidy_avg<<-data_subset_tidy_avg  #Send to workspace
    print("**Average of 'data_subset_tidy' created as 'data_subset_tidy_avg'")
    #Step 6:Save data
    print("saving 'data_tidy' and 'data_tidy_avg' in CSV format")
    write.csv(data_subset_tidy, file = "analysis/data_tidy.csv",row.names = FALSE)
    write.csv(data_subset_tidy_avg, file = "analysis/data_tidy_avg.csv",row.names = FALSE)
}
    