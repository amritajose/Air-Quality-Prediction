#Installing or importing all packages
library(ggplot2)
library(expss)
library(VIF)
library(forecast)
library(Metrics)
library(DMwR)

#Read the airquality dataset obtained from AQS Data Mart
air.data<-read.csv(file='ProjectDataset.csv')
#Remove all missing values
airqualitys.data<-na.omit(air.data)
#Create a subset of the dataset by selecting only the required columns for analysis
myvar<-c(1,4,5,9,11,14,16,19,20,21,22,23,24,30,31,32,33,34,35,42,51)
airqualitysubset.data<-airqualitys.data[myvar]

#Summary Statistics for Average Pollution
summary(airqualitysubset.data$X1st.Max.Value)
#Summary Statistics for % of observations
summary(airqualitysubset.data$Observation.Percent)
#Summary Statistics for Primary Exceedance Count
summary(airqualitysubset.data$Primary.Exceedance.Count)

#Extracting month number from DateTime field - The 1st Max DateTime field gives the date when the highest value of pollutant is recorded
myDate = as.POSIXct(air.data$X1st.Max.DateTime)
maxmonthnumber<-format(myDate,"%m")
airqualitysubset.data<-transform(air.data, Month =maxmonthnumber)


#######################---------Scatter Plots--------------#########################
#*********************************************************************************#

#Scatterplot for Average Pollution vs Month
ggplot(airqualitysubset.data, aes(x = airqualitysubset.data$Arithmetic.Mean , y = Month)) +
  geom_point(aes(color=Month))+
  geom_smooth(method="loess",se=TRUE,fullrange=FALSE,level=0.95) + 
  scale_color_manual(values=c("red","blue","orange","green","brown","purple","white","black","pink","yellow","white","black"))+
  xlab("Average Pollution")+ylab("Month")+
  labs(title="Scatterplot for Average Pollution vs Month ")

#Scatterplot for Average Pollution vs 99th Percentile value of Pollutant
ggplot(airqualitysubset.data, aes(x = airqualitysubset.data$Arithmetic.Mean , y = airqualitysubset.data$X1st.Max.Value)) +
  geom_point()+
  geom_smooth(method="loess",se=TRUE,fullrange=FALSE,level=0.95) + 
  xlab("Average Pollution")+ylab("Month")+
  labs(title="Scatterplot for Average Pollution vs 99th Percentile Pollution")


##########################---------Boxplots--------------#############################
#***********************************************************************************#

#Boxplot for highest pollutant value vs Events Occured
boxplot(airqualitysubset.data$X1st.Max.Value~airqualitysubset.data$Events.Occurred,xlab="Events Occured",ylab="Highest Pollutant Value",main="Boxplot for Events Occured vs Highest Pollutant Value")
#Boxplot for Average pollution vs Certified Pollution Data
boxplot(airqualitysubset.data$Arithmetic.Mean~airqualitysubset.data$Certified,xlab="Certified Data",ylab="Average Pollution",main="Boxplot for Certified Data vs Average Pollution")

#Boxplot for Month vs Major Pollutants
airqualitymonth.data<-subset(airqualitysubset.data, Parameter.Name %in% c("Ozone","Carbon monoxide","Nitrogen dioxide (NO2)","Lead PM10 LC","Sulfur dioxide","PM2.5 Total Atmospheric"))
ggplot(airqualitymonth.data, aes(x=Month, y=Parameter.Name)) +
  geom_boxplot(fill="white")+
  geom_jitter(aes(color=Month),
              position=position_jitter(w=0.05, h=0))+
  scale_color_manual(values = c("red","blue","orange","green","brown","purple","white","black","pink","yellow","white","black"))+
  xlab("Month")+ylab("Major Pollutants")+
  labs(title="Boxplots for Month vs Major Pollutants")

####################---------Correlation Analysis--------------######################
#***********************************************************************************#

#Correlation analysis between average pollution and highest pollutant value
cor.test(airqualitysubset.data$Arithmetic.Mean, airqualitysubset.data$X1st.Max.Value,  method = "pearson", use = "complete.obs")
#Correlation analysis between 99th percentile value of pollutant and highest pollutant value
cor.test(airqualitysubset.data$X99th.Percentile, airqualitysubset.data$X1st.Max.Value,  method = "pearson", use = "complete.obs")
#Correlation analysis between the number of days daily monitoring criteria were met(Valid Day Count) and number of samples that exceeded the air quality standard(Primary Exceedence Count)
cor(airqualitysubset.data$Valid.Day.Count, airqualitysubset.data$Primary.Exceedance.Count, method = "pearson", use = "complete.obs")
#Correlation analysis between Longitude and number of samples that exceeded the air quality standard(Primary Exceedence Count)
cor.test(airqualitysubset.data$Longitude, airqualitysubset.data$Primary.Exceedance.Count, method = "pearson", use = "complete.obs")

#Identify relationships between Primary Exceedance Count, Arithmetic Mean, 1st Max Value, 99th Percentile
myvar<-c(24,28,30,42)
airqualitypairs.data<-airqualitysubset.data[myvar]
pairs(airqualitypairs.data)


######################---------Regression Analysis--------------######################
#************************************************************************************#


#Regression Analysis using single predictor(independent) variable
lmodel1<-lm(airqualitysubset.data$X1st.Max.Value~airqualitysubset.data$X99th.Percentile)
summary(lmodel1)
distPred_lmodel1 <- predict(lmodel1,airqualitysubset.data)
#Root Mean Sqaure Error
rmse(airqualitysubset.data$X1st.Max.Value,predict(lmodel1,airqualitysubset.data))
#Coefficients of the linear model
lmodel1coef=coef(lmodel1)
print(lmodel1coef)
#Equation of the linear regression
eq = paste0("y = ", round(lmodel1coef[2],1), "*x ", round(lmodel1coef[1],1))
#Plotting the graph
plot(airqualitysubset.data$X1st.Max.Value,airqualitysubset.data$X99th.Percentile, main=eq, xlab="Highest Pollutant Value",ylab="99th Percentile")
#Confidence Interval of the model
confint(lmodel1)
#Analysis of Variance
anova(lmodel1)
#Regression Evaluation
actuals_pred_lmodel1 <- data.frame(cbind(lmodel1_actuals=airqualitysubset.data$X1st.Max.Value, lmodel1_predicteds=distPred_lmodel1))
mean(abs((actuals_pred_lmodel1$lmodel1_predicteds - actuals_pred_lmodel1$lmodel1_actuals))/actuals_pred_lmodel1$lmodel1_actuals)  
regr.eval(actuals_pred_lmodel1$lmodel1_actuals, actuals_pred_lmodel1$lmodel1_predicteds)

#Regression Analysis using multiple predictor(independent)variables
lmodel2<-lm(airqualitysubset.data$X1st.Max.Value~airqualitysubset.data$X99th.Percentile+airqualitysubset.data$Arithmetic.Mean+airqualitysubset.data$State.Code+airqualitysubset.data$Observation.Count+airqualitysubset.data$Parameter.Code+airqualitysubset.data$Valid.Day.Count+airqualitysubset.data$Longitude)
summary(lmodel2)
distPred_lmodel2 <- predict(lmodel2,airqualitysubset.data)
#Coefficients of the model
lmodel2coef=coef(lmodel2)
print(lmodel2coef)
#Equation of the linear regression
eq = paste0("y = ", round(lmodel2coef[8],1), "*x7 + ",round(lmodel2coef[7],1), "*x6 + ",round(lmodel2coef[6],2), "*x5 + ",round(lmodel2coef[5],2), "*x4 " ,round(lmodel2coef[4],1), "*x3  " ,round(lmodel2coef[3],1), "*x2 + " ,round(lmodel2coef[2],1), "*x1  ",round(lmodel1coef[1],1))
#Plotting the graph
plot(airqualitysubset.data$X1st.Max.Value,airqualitysubset.data$X99th.Percentile+airqualitysubset.data$Arithmetic.Mean+airqualitysubset.data$State.Code+airqualitysubset.data$Observation.Count+airqualitysubset.data$Parameter.Code+airqualitysubset.data$Valid.Day.Count+airqualitysubset.data$Longitude,main=eq,xlab="Highest Pollutant value",ylab="Predictor Variables")
#Confidence Intervals of the Model
confint(lmodel2)
#Analysis of Variance
anova(lmodel2)
#Regression Evaluation
actuals_pred_lmodel2 <- data.frame(cbind(lmodel2_actuals=airqualitysubset.data$X1st.Max.Value, lmodel2_predicteds=distPred_lmodel2))
mean(abs((actuals_pred_lmodel2$lmodel2_predicteds - actuals_pred_lmodel2$lmodel2_actuals))/actuals_pred_lmodel2$lmodel2_actuals)  
regr.eval(actuals_pred_lmodel2$lmodel2_actuals, actuals_pred_lmodel2$lmodel2_predicteds)

##################---------Hypothesis Test--------------####################
#**************************************************************************#

#Hypothesis Test 1
# H0(Null Hypothesis): Mean of highest pollution when no events occured=Mean of highest pollution when events occured
# H1(Alternative Hypothesis: True difference in means is not equal to 0)
#checking variances of the two groups
var(airqualitysubset.data$X1st.Max.Value[airqualitysubset.data$Events.Occurred=="No"])
var(airqualitysubset.data$X1st.Max.Value[airqualitysubset.data$Events.Occurred=="Yes"])
#The variances are not equal. Hence considering non equal variances
#Hypothesis Testing using Two Sample t-test
t.test(airqualitysubset.data$X1st.Max.Value~airqualitysubset.data$Events.Occurred,mu=0,alt="two.sided",conf=0.95,var.eq=F,paired=F)
#Hypothesis Testing using Wilcox Test
wilcox.test(airqualitysubset.data$X1st.Max.Value~airqualitysubset.data$Events.Occurred,data=airqualitysubset.data)

#Hypothesis Test 2
# H0(Null Hypothesis): Mean of certified pollution data=Mean of uncertified pollution data
# H1(Alternative Hypothesis: True difference in means is not equal to 0)
#checking variances of the two groups
var(airqualitysubset.data$Arithmetic.Mean[airqualitysubset.data$Certified=="No"])
var(airqualitysubset.data$Arithmetic.Mean[airqualitysubset.data$Certified=="Yes"])
#The variances are not equal. Hence considering non equal variances
#Hypothesis Testing using Two Sample t-test
t.test(airqualitysubset.data$Arithmetic.Mean~airqualitysubset.data$Certified,mu=0,alt="two.sided",conf=0.95,var.eq=F,paired=F)
#Hypothesis Testing using Wilcox Test
wilcox.test(airqualitysubset.data$Arithmetic.Mean~airqualitysubset.data$Certified,data=airqualitysubset.data)
