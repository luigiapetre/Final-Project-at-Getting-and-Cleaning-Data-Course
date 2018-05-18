#This is the codebook for this project. In it I explain how I arrived at the results, starting from the instructions in the course webpage.

* Step 1:  I downloaded the zip files at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. These I unzipped normally on my laptop. 
* Step 2: In R I set my working directory to"./UCI HAR Dataset" and there read the required files in R. The following dataframes resulted: **act_labels**, **features**, **sub_test**, **Xtest**, **ytest**, **sub_train**, **Xtrain**, **ytrain**. I column-binded the train and test data separately, obtaining dataframes **train** and **test** respectively. Then, I row-binded **train** and **test** dataframes together to obtain my initial data frame, that I named **my_data**.
