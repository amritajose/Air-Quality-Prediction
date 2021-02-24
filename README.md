# Air-Quality-Prediction-using-R

The project's objective is to analyze the  air quality for the year 2018  in United States. 
The dataset is about air quality data obtained from The AQS (Air Quality System) Data Mart  on air quality in the United States, summarised on an annual basis.
It is a database containing every value collected or measured by the Environmental Protection Agency (EPA) through the national ambient air monitoring program. 
The selected dataset is a summary on air quality for the year 2018, with 55 columns and 66,000+ rows. 

EPA calculates several types of summary data based on the data reported to it from various data collection agencies such as the tribal, local and state air 
pollution control agencies. All of this collected outdoor air quality data is stored in AQS. Monitoring air quality helps to determine the pollution in the
air and take appropriate steps to prevent or reduce the possibility of various health hazards.

Potential Analysis from the dataset: 

    i.  Major pollutants in various states and the extent of pollution
    ii. Yearly and monthly comparison of pollutants and air quality
    iii. Usage Trends of Methods used for Measuring Air Quality
    iv. Occurrence of special events such as wildfire, bursting of firecrackers and subsequent change in air quality
    v. Cities/Counties/States where daily monitoring criteria are met significantly
    vi. Comparison of required data counts and null data counts for each state/city/county or on
        monthly basis to determine how many pollutant samples were measured out of the required set to determine the air quality;
    vii. Summary Statistics for each pollutant/method/equipment, both monthly and state/city/county wise.
    viii. Calculation of high Ozone days and 24-hour particle pollution
    ix. Ranking of Cities based on pollutants
    

Analysis and Visualizations:

Scatterplots: 
The scatter plot plotted between Month and Arithmetic Mean (Average
Pollution) indicates that the average pollution in United States is highest in the month
of January and lowest in the month of September.
The scatterplot plotted between Arithmetic Mean (Average Pollution) and 99th
Percentile value of the pollutant shows a fairly strong linear relationship between both
the variables.

Boxplots: 
The boxplots plotted between Average pollution and Certified, Month and
Major Pollutants shows the distribution of data for the variables.

Correlation Analysis: 
The correlation analysis between Arithmetic Mean and the
Highest Pollutant value of the year shows a significantly strong positive relationship,
correlation or the association between the two variables with a p-value less than 0.05
and a positive correlation coefficient of 0.89. Hence this positive correlation implies
that an increase in highest pollutant value of the year will increase the average
pollution and a decrease in the value of highest pollution will decrease the average
pollution.

The correlation analysis between Longitude and Primary Exceedance Count is a weak
negative correlation with a correlation coefficient of -0.24 which indicates that there is
an increase in the samples that exceeded the primary air quality standard when the
longitude decreases(towards the East of United States) and there is a decrease in the
samples that exceeded the primary air quality standard when the longitude
increases(towards the West of United States).


Regression Analysis: 
The regression analysis using a single predictor variable shows the
regression analysis between the highest value of a pollutant (dependent variable) and
the 99th percentile value of the pollutant (independent variable). The R-squared or the
variance of the linear model is 94.42% which indicates that the model is significant
with a good proportion of variability. Also, the p value and the significance F value (F
statistic) of the model is less than 0.05 or all the primary levels of significance, thus
indicating that the model is statistically significant. The p value of the predictor
variable (99th Percentile) is less than 2e-16 which implies that it is a significant
predictor of the target variable – 1st Max Value (highest pollutant value). This implies
that an increase or decrease in the 99th percentile value of the pollutant will cause a
corresponding change in the highest pollutant value of the year.
The regression analysis using multiple predictor variables shows the regression
analysis between the highest pollutant value(dependent variable) and multiple
independent variables which include the 99th percentile value, average pollution
(Arithmetic Mean), state code, the number of observations, parameter code, number
of days the monitoring criteria were met (Valid Day Count) and Longitude. The model
is statistically significant with a good variance or adjusted R squared value of 94.59%.
All predictor variables except Longitude have p values less than 0.05 or all primary
levels of significance, which indicates that all the above independent variables except
longitude are good predictors of the dependent variable (highest pollutant value). The
p value of longitude is 0.09, which is greater than 0.05 level of significance and hence
is not a good predictor of the highest pollutant value.


Hypothesis test:
The Hypothesis Test 1 tests for the validity of the null hypothesis. The
null hypothesis is that the mean of the highest pollutant value when there were no
events (such as wildfire, fireworks and so on) is equal to the mean of the highest
pollutant value when there were events impacting the air quality. The alternative
hypothesis is that the true difference between both the means is not equal to zero.
The Hypothesis test was done using both Welch Two Sample t-test and Wilcoxon Sign
Test and the p value came out to be lesser than 2.2e-16, which is less than all levels of
significance. Hence, this implies that the null hypothesis needs to be rejected and it
can be concluded that the two means are not equal, that is, the alternative hypothesis
is true.

The Hypothesis Test 2 tests for the validity of the null hypothesis which states that the
mean of the certified air quality data is equal to the mean of the uncertified data. By
looking at the variances, the alternative hypothesis is that the mean of the certified air
quality data is not equal to the mean of the uncertified data. The p value of the test
was again less than 2.2e-16, thus indicating that the null hypothesis needs to be
rejected and the alternative hypothesis is true. Hence, it can be implied that the mean
of the certified air quality data is not equal to the mean of the uncertified air quality
data.
