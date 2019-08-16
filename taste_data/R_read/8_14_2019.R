---
title: "R Notebook"
output: html_notebook
---

This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. When you execute code within the notebook, the results appear beneath the code. 

Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Ctrl+Shift+Enter*. 

```{r}
plot(cars)
```

Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Ctrl+Alt+I*.

When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Ctrl+Shift+K* to preview the HTML file).

The preview shows you a rendered HTML copy of the contents of the editor. Consequently, unlike *Knit*, *Preview* does not run any R code chunks. Instead, the output of the chunk when it was last run in the editor is displayed.
```{r}
cluster.size = function(x,threshold){
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
  z = as.numeric(z)
  
  cluster_sizes= ec-bc+z
  cluster_size_mean=mean(cluster_sizes)
  
  return(cluster_sizes)
}

y = c(1,2.2,2.3,2.4,2.5,8,10)

cluster.size(y,0.5)
```
```{r}
setwd("C:\\Users\\murad\\PycharmProjects\\Subject_data_parsing\\that_one_file")

active_data_files <- list.files(pattern = '_active.csv')  # finding all files for active lick data
inactive_data_files <- list.files(pattern = '_inactive.csv') 

cluster.size = function(x,threshold){
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
  
  print(result5)
  
  bc=which(result5==2)
  ec=which(result5==-1)
  
  z=cluster.count(x,0.5)
  
  bc = as.vector(unlist(bc))
  ec = as.vector(unlist(ec))
  z = as.numeric(z)
  
  print(length(bc))
  print(length(ec))
  
  cluster_sizes= ec-bc+z
  cluster_size_mean=mean(cluster_sizes)
  
  return(cluster_sizes)
}


for (fileName in active_data_files){  
  active_data <- read.csv(fileName,    
                          header = FALSE, 
                          col.names = c(1:(length(file)))
                          )
  
  
  x <- cluster.size(active_data,threshold= 0.5)
  avg_act_cluster_size <- c(avg_act_cluster_size,x)
}

```


