### Week 13 Problem Set
setwd(getwd())

fb.data <- read.csv("FacebookFriends.csv", header = TRUE)
## how well does brain grey matter predict the number of FB friends

plot(fb.data$GMdensity, fb.data$FBfriends, xlab = "Brain Grey Matter", ylab = "Number of FB Friends", 
     main = "Facebook friends vs Grey Matter")

ggplot(fb.data, aes(x= GMdensity, y= FBfriends)) + geom_point(aes(size=4, color= "red"))


## find the correlation coefficient:
cor(fb.data$GMdensity, fb.data$FBfriends)
# == [1] 0.4363354

GM.FB.model <- lm(fb.data$FBfriends ~ fb.data$GMdensity)
summary(GM.FB.model)

plot(fb.data$GMdensity, fb.data$FBfriends, xlim=c(0,2) , xlab = "Brain Grey Matter", ylab = "Number of FB Friends", 
     main = "Facebook friends vs Grey Matter") +
   abline(GM.FB.model)

autoplot(GM.FB.model)
confint(GM.FB.model)

