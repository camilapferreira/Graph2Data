library(dplyr)
library(pipeR)
library(magrittr)
library(digitize)

#im.convert("Train.pdf", output = "bm.png", extra.opts="-density 150")

Train = ReadAndCal('Train.png') #Load image of the graph and calibrate x and y axis. Click on x1,x2,y1,y2 respectively to load the axes.
growth = DigitData(col='red') #Click on points within the graph that need to converted into a dataset
data = Calibrate(growth, Train, 1.5,5,2,8) #Select the variable containing the point, axes, x1,x2,y1,y2
plot(data, type='l') #Plot the data to check if it's representative of the image

data$x = as.integer(data$x) #Convert points on x axis into integers
data$y = as.integer(data$y) #Convert points on y axis into integers
View(data) 


data.frame(data)
write.csv(data, file = "data.csv")

##################################################################################################
