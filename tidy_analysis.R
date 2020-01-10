library(stats)
library(dplyr)

# the results will have the following structure
# UID, ratID, spout, cluster_cnt, cluster_size, inter_lick_interval, threshold, ....


setwd('C:\\Users\\murad\\PycharmProjects\\Subject_data_parsing') # setting working directory

#Importing data from output.txt 
data <- read.csv('output.csv', sep = '\t', header = F, na.strings =c("","NA"), col.names = c('UID','Rat ID','Spout','Lick Time'))

# These are all the data that is being gathered to be manipulated. They are initialized here and added to later.
active_clusters <- list()
inactive_clusters <- list()
avg_act_cluster_size <- list()
avg_inact_cluster_size <- list()
global_threshold <- 0.5
act_lick_interval <- list()
inact_lick_interval <- list()


new_data<- data %>% select(UID, Spout, Lick.Time) %>% 
group_by(UID, Spout) %>% 
mutate(paste(as.character(Lick.Time), collapse=",")) %>% 
select(-Lick.Time) %>% distinct()



u#Function to assign a number to each lick
lick.label <- function(x){
  y<-stack(setNames(x, seq_along(x)))
  y <- as.vector(y$ind)
  return(y)
}

li# This script defines the function that will count the number of clusters
cluster.count <- function(x, threshold){
    x=x+0.5  
  
    x1 = c(x,threshold,10^10) # adding 10 to the end of x, so that x2 can be subtracted from it 
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


# I am unlisting every list that was initialized here. This is necessary because of some issues with the mathematical processes. 
active_clusters = unlist(active_clusters)
inactive_clusters = unlist(inactive_clusters)
uid_data <- unlist(uid_data)
avg_act_cluster_size <- unlist(avg_act_cluster_size)
avg_inact_cluster_size <- unlist(avg_inact_cluster_size)
threshold <- unlist(global_threshold)
act_lick_interval <- unlist(act_lick_interval)
inact_lick_interval <- unlist(inact_lick_interval)


# This defines the ultimate dataframe that will encompass all the data gathered and compiled. 

colnames(df) <-c("UID",
                 "Rat ID",
                 "Lick Times",
                 "Active or Inactive",
                 "Time Threshold for Lick Cluster",
                 "Number of Lick Clusters",
                 "Mean Lick Cluster Size",
                 "Mean  Interlick Interval"
                  )

plot.with.errorbars <- function(x, y, err, ylim=NULL, ...) {
  if (is.null(ylim))
    ylim <- c(min(y-err), max(y+err))
  plot(x, y, ylim=ylim, pch=19, ...)
  arrows(x, y-err, x, y+err, length=0.05, angle=90, code=3)
}

x = active_clusters
xmax = max(active_clusters)

y = avg_act_cluster_size
ymax = max(avg_act_cluster_size)
ylog= 50
ysdev = sd(y)

length(ysdev)

barplot(x, ylab="Avg Active Cluster Size", xlab="Number of Active Clusters", main="Number of Active Clusters vs. Mean Active Cluster Size", ylim=c(1, ymax), pch=19, xlim=c(1,xmax),cex.axis=1,col="blue", cex=1.5, cex.main=1.5)
arrows(xy,x,y+ylog,length=0.05,angle = 90, code=3)              
              

# Plotting all variables against one another to find correlations
plot(df0)







