
x <- c(1.2,1.3,1.4,4,10,14.2,14.3,15)
cluster.count <- function(x, threshold){
  
  x1 = c(x,10^10) # adding 10 to the end of x, so that x2 can be subtracted from it 
  x2 = c(0,x) # adding 0 to the beginning of x, so that x1 can be subtracted from x1
  
  x1 = as.numeric(as.character(unlist(x1))) #converting x1 into a vector
  x2 = as.numeric(as.character(unlist(x2))) #converting x2 into a vector
  
  result1 = (x1-x2) 
  result1 = as.numeric(result1 < threshold)  #check values that are less than the threshold
  
  result2 = c(result1[-1], 10)
  
  result3 = result1 - result2
  
  result3 = c(result3[-(length(result3))])
  print(result3)
  
  result3 = replace(result3,result3 == -1, 2)
  result3 = replace(result3,result3 ==1, -1)
  idx=result3==-1
  cs=cumsum(result1)
  print(result3)
  print(cs[idx]+1)
  
  
  number_of_clusters = sum(result3)
  
  print('number_of_clusters:')
  return( number_of_clusters)
}



cluster.count(x, threshold = 0.5)