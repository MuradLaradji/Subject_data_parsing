library(stats)

setwd('C:\\Users\\murad\\PycharmProjects\\Subject_data_parsing\\taste_data') # setting working directory

active_data_files <- list.files(pattern = '_active.csv')  # finding all files for active lick data
inactive_data_files <- list.files(pattern = '_inactive.csv')  #finding all files for inactive lick data

# This script collects the uid data for each subject
uid_data <- c(read.csv('uid_data.csv',header = FALSE, na.strings =c("","NA")))
uid_data <- as.vector(uid_data)
uid_data <- replace(uid_data, uid_data == '___', "NA")

# These are all the data that is being gathered to be manipulated. They are initialized here and added to later.
active_clusters <- list()
inactive_clusters <- list()
avg_act_cluster_size <- list()
avg_inact_cluster_size <- list()
global_threshold <- list()
lick_interval <- list()

# This script defines the function that will count the number of clusters
cluster.count <- function(x, threshold){
    x=x+0.5  
  
    x1 = c(x,10^10) # adding 10 to the end of x, so that x2 can be subtracted from it 
    x2 = c(0,x) # adding 0 to the beginning of x, so that x1 can be subtracted from x1
    
    x1 = as.numeric(as.character(unlist(x1))) #converting x1 into a vector
    x2 = as.numeric(as.character(unlist(x2))) #converting x2 into a vector
    
    result1 = (x1-x2) 
    result1 = as.numeric(result1 < threshold)  #check values that are less than the threshold
    
    result2 = c(result1[-1], 10)
    
    result3 = result1 - result2
    
    result3 = c(result3[-(length(result3))])
    #print(result3)
    
    result3 = replace(result3,result3 == -1, 2)
    result3 = replace(result3,result3 ==1, -1)
    
    #print(result3)
    
    
    number_of_clusters = sum(result3)
    
    #print(number_of_clusters)
    return(number_of_clusters)
}

# This script defines the function that will measure the average interlick interval.
interlick.interval= function(x){
  x1 = c(x,10^10) # adding 10 to the end of x, so that x2 can be subtracted from it 
  x2 = c(0,x) # adding 0 to the beginning of x, so that x1 can be subtracted from x1
  
  x1 = as.numeric(as.character(unlist(x1))) #converting x1 into a vector
  x2 = as.numeric(as.character(unlist(x2))) #converting x2 into a vector
  
  result1 = (x1-x2) 
  result2 = result1[1:length(result1)-1]
  mean.result = mean(as.numeric(result2)) #check values that are less than the threshold
  
  return(mean.result)
}
  
# This script defines the function that will measure the number of licks that are part of clusters
cluster.size = function(x,threshold){
  x=x+0.5
  
  x1 = c(x,10^10) # adding 10 to the end of x, so that x2 can be subtracted from it 
  x2 = c(0,x) # adding 0 to the beginning of x, so that x1 can be subtracted from x1
  
  x1 = as.numeric(as.character(unlist(x1))) #converting x1 into a vector
  x2 = as.numeric(as.character(unlist(x2))) #converting x2 into a vector
  
  result1 = (x1-x2) 
  result1 = as.numeric(result1 < 0.4)  #check values that are less than the threshold
  
  result2 = c(result1[-1], 10)
  
  result3 = result1 - result2
  
  result3 = c(result3[-(length(result3))])
  
  result5 = replace(result3,result3 == -1,2)
  result5 = replace(result5,result5 ==1, -1)
  
  print(result5)
    
  bc=which(result5==2)
  ec=which(result5==-1)
  
  z=cluster.count(x,0.4)
  
  bc = as.vector(unlist(bc))
  ec = as.vector(unlist(ec))
 
 lbc = length(bc)
 lec = length(ec)
 print(length(bc))
 print(length(ec))
  
  if (lbc != lec){
    
  print("THIS FILE IS ABNORMAL", col = "blue")
  }
 
 print(fileName)
  
 
 z = as.numeric(z)
  
  cluster_sizes= ec-bc+z
  cluster_size_mean=mean(cluster_sizes)
  
  return(cluster_size_mean)
}

# This is the looping script for the inactive data. It gathers important data from each file and adds it to the initialized lists.
for (fileName in active_data_files){  
  active_data <- read.csv(fileName,    
                          header = FALSE, 
                          col.names = c(1:(length(file)))
                          )
  y <- cluster.count(active_data,threshold= 0.4)
  active_clusters <- c(active_clusters, y)
  
  x <- cluster.size(active_data,threshold= 0.4)
  avg_act_cluster_size <- c(avg_act_cluster_size,x)
  
  global_threshold <- c(global_threshold,0.4)
  
  z <- interlick.interval(active_data)
  lick_interval <- c(lick_interval,z)
}

# This is the looping script for the inactive data. It gathers important data from each file and adds it to the initialized lists.
for (fileName in inactive_data_files){  
   inactive_data <- read.csv(fileName,  
                             header = FALSE, 
                             col.names = c(1:(length(file)))
                             )
  y <- cluster.count(inactive_data,threshold= 0.4)
  inactive_clusters = c(inactive_clusters, y)
  
  x <- cluster.size(inactive_data,threshold= 0.4)
  avg_inact_cluster_size <- c(avg_inact_cluster_size, x)
 
  z <- interlick.interval(inactive_data)
  lick_interval <- c(lick_interval,z)
}

# I am unlisting every list that was initialized here. This is necessary because of some issues with the mathematical processes. 
active_clusters = unlist(active_clusters)
inactive_clusters = unlist(inactive_clusters)
uid_data <- unlist(uid_data)
avg_act_cluster_size <- unlist(avg_act_cluster_size)
avg_inact_cluster_size <- unlist(avg_inact_cluster_size)
threshold <- unlist(global_threshold)
lick_interval <- unlist(lick_interval)

# This defines the ultimate dataframe that will encompass all the data gathered and compiled. 
df <- data.frame(uid_data,
                active_clusters,
                avg_act_cluster_size,
                inactive_clusters,
                avg_inact_cluster_size,
                threshold,
                lick_interval
                )

colnames(df) <-c("UID",
                 "Active Lick Clusters",
                 "Mean Active Cluster Size",
                 "Number of Inactive Lick Clusters",
                 "Mean Inactive Lick Cluster Size",
                 "Time Threshold for Lick Cluster",
                 "Mean Interlick Interval"
)











