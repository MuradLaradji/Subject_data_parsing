library(stats)
library(dplyr)

# the results will have the following structure
# UID, ratID, spout, cluster_cnt, cluster_size, inter_lick_interval, threshold, ....


setwd('C:\\Users\\murad\\PycharmProjects\\Subject_data_parsing') # setting working directory

#Function to assign a number to each lick
lick.label <- function(x){
  y<-stack(setNames(x, seq_along(x)))
  y <- as.vector(y$ind)
  return(y)
}

# This script defines the function that will count the number of clusters
cluster.count <- function(x, threshold){
  x = as.numeric(unlist(x))
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
  
  result3 = replace(result3,result3 == -1, 2)
  result3 = replace(result3,result3 ==1, -1)
  
  number_of_clusters = sum(result3)
  
  if (is.na(number_of_clusters)){
    number_of_clusters= 0
  }
  
  return(number_of_clusters)
}

# This script defines the function that will measure the average interlick interval.
interlick.interval= function(x){
  x = as.numeric(unlist(x))
  x1 = c(x,10^10) # adding 10 to the end of x, so that x2 can be subtracted from it 
  x2 = c(0,x) # adding 0 to the beginning of x, so that x1 can be subtracted from x1
  
  x1 = as.numeric(as.character(unlist(x1))) #converting x1 into a vector
  x2 = as.numeric(as.character(unlist(x2))) #converting x2 into a vector
  
  result1 = (x1-x2) 
  result2 = result1[1:length(result1)-1]
  mean.result = mean(as.numeric(result2)) #check values that are less than the threshold
  
  if (is.na(mean.result)){
    mean.result = 0
  }
  
  return(mean.result)
}

# This script defines the function that will measure the number of licks that are part of clusters
cluster.size = function(x,threshold){
   x = as.numeric(unlist(x))
   x=x+0.5
  
  x1 = c(x,10^10) # adding 10 to the end of x, so that x2 can be subtracted from it 
  x2 = c(0,x) # adding 0 to the beginning of x, so that x1 can be subtracted from x1
  
  x1 = as.numeric(as.character(unlist(x1))) #converting x1 into a vector
  x2 = as.numeric(as.character(unlist(x2))) #converting x2 into a vector
  
  result1 = (x1-x2) 
  result1 = as.numeric(result1 < 0.5)  #check values that are less than the threshold
  
  result2 = c(result1[-1], 10)
  
  result3 = result1 - result2
  
  result3 = c(result3[-(length(result3))])
  
  result5 = replace(result3,result3 == -1,2)
  result5 = replace(result5,result5 ==1, -1)
  
  bc=which(result5==2)
  ec=which(result5==-1)
  
  z=cluster.count(x,0.5)
  
  bc = as.vector(unlist(bc))
  ec = as.vector(unlist(ec))
  
  lbc = length(bc)
  lec = length(ec)
  
  
  if (lbc != lec){
    
    print("THIS FILE IS ABNORMAL", col = "blue")
  }
  
  z = as.numeric(z)
  
  cluster_sizes= ec-bc+z
  cluster_size_mean=mean(cluster_sizes)
  
  if (is.na(cluster_size_mean)){
    cluster_size_mean = 0
  }
  
  return(cluster_size_mean)
}

# Importing data from output.txt 
data <- read.csv('output.csv', sep = '\t', header = F, na.strings =c("","NA"), col.names = c('UID','Rat ID','Spout','Lick Time'))

# These are all the data that is being gathered to be manipulated. They are initialized here and added to later.
number_of_clusters <- c()
avg_cluster_size <- c()
interlick_interval <- c()

# Forming the new_data dataframe which allows for operations on licktimes
data <- aggregate(Lick.Time~UID+Rat.ID+Spout, data, function(x) list(unique(x)))

# Operations on licktimes within data
for (Lick.Time in data$Lick.Time){
  t_number_of_clusters <- cluster.count(Lick.Time, 0.5)
  number_of_clusters <- append(number_of_clusters, t_number_of_clusters)
  #print(number_of_clusters)
  
  t_avg_cluster_size <- cluster.size(Lick.Time, 0.5)
  avg_cluster_size <- append(avg_cluster_size, t_avg_cluster_size)
  print(avg_cluster_size)
  
  t_interlick_interval <- interlick.interval(Lick.Time)
  interlick_interval <- append(interlick_interval, t_interlick_interval)
  print(interlick_interval)
}



# the results will have the following structure
# UID, ratID, spout, cluster_cnt, cluster_size, inter_lick_interval, threshold, ....

# This defines the ultimate dataframe that will encompass all the data gathered and compiled. 

UID <- data$UID
Rat_ID <- data$Rat.ID
Spout <- data$Spout

df <- data.frame(UID, Rat_ID, Spout, number_of_clusters,avg_cluster_size,interlick_interval)
print(df)                  

plot.with.errorbars <- function(x, y, err, ylim=NULL, ...) {
  if (is.null(ylim))
    ylim <- c(min(y-err), max(y+err))
  plot(x, y, ylim=ylim, pch=19, ...)
  arrows(x, y-err, x, y+err, length=0.05, angle=90, code=3)
}

plot(df)








