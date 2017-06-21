library(EBImage)
library(dplyr)
library(pipeR)
library(magrittr)
library(digitize)

Train = ReadAndCal('Train.png') #Load image of the graph and calibrate x and y axis. Click on x1,x2,y1,y2 respectively to load the axes.
growth = DigitData(col='red') #Click on points within the graph that need to converted into a dataset
data = Calibrate(growth, Train, 1.3,5,1.2,8.7) #Select the variable containing the point, axes, x1,x2,y1,y2
plot(data, type='l') #Plot the data to check if it's representative of the image

data$x = as.integer(data$x) #Convert points on x axis into integers
data$y = as.integer(data$y) #Convert points on y axis into integers
View(data) 


data.frame(data)
write.csv(data, file = "data.csv")

##################################################################################################
library(imager)
library(dplyr)
?imager
im <- ?load.example("Train.png")
d <- as.data.frame(im)
##Subsamble, fit a linear model to remove trend in illumination, threshold
px <- sample_n(d,1e4) %>% lm(value ~ x*y,data=.)  %>%
  predict(d) %>% { im - . } %>% threshold

##Clean up
px <- clean(px,3) %>% imager::fill(7) 
plot(im)
highlight(px)

## Split into connected components (individual coins)
pxs <- split_connected(px)
## Compute their respective area
area <- sapply(pxs,sum)
## Highlight largest coin in green
highlight(pxs[[which.max(area)]],col="green",lwd=2)


#FOR BLURRED IMAGES
layout(t(1:2))
plot(birds.noisy,main="Original")
blur_anisotropic(birds.noisy,ampl=1e3,sharp=.3) %>% plot(main="Blurred (anisotropic)")


install.packages("rimage")
