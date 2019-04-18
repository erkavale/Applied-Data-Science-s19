#Data visualization notes  (unrelated code separated by ######)

#Built in R visualization examples

###############################################################
#Examples of ecdf, boxplot, qqnorm, and density
#Assignment 6 question  from Intro to Statistics
#Load data
pulse=scan("data7_7_2.txt")

#(a) Graph the empirical cdf of x ⃗.
plot(ecdf(pulse))

#(e) Construct a boxplot. 
boxplot(pulse, main='Boxplot of peruvian pulses', ylab='Pulses') #how to label the plot and its y axis

#(f) Construct a normal probability plot. 
qqnorm(pulse)

#(g) Construct a kernel density estimate. 
plot(density(pulse))

############################################################
#Two density plots on the same graph
#read in data (a distribution comparison from intro to stats)
#The data is game data for Steph Curry of the Golden State Warriors
currydist = read.table("currydist.txt", header=TRUE) #header=TRUE makes 1st row in file your header

#make two vectors one one containing the distances for Curry's shots at home, 
#and one containing the distances for Curry's shots away
curry_home_dist<-currydist$distance[currydist$venue=='Home']
curry_away_dist<-currydist$distance[currydist$venue=='Away']

#distribution comparison
plot(density(curry_home_dist), main="Distribution of Curry shots made 
     at home(black) and away(red)", xlab="distance")
#lines adds to the previous graph command
lines(density(curry_away_dist), col="red") #changes graphed line to red

###########################################################

#scatter plot with regression line
data("cars") #load data
head(cars) #view dats
plot(dist~speed, data=cars, col='grey', pch=20, main="Data from cars") #scatter plot
cars_fit=lm(dist~speed, data=cars) #linear model
abline(cars_fit, col="darkorange", lwd=3) #line of best fit

############################################################
#Side by side boxplots and Q-Q Plots w labels
#From Intro to Stats assignment 11
#read in data for different types of sickle cell disease and 
#their related homoglobin levels
sickle=scan("http://mypage.iu.edu/~mtrosset/StatInfeR/Data/sickle.dat")

#separate types of sickle cell disease
SS=sickle[1:16]
ST=sickle[17:27]
SC=sickle[28:41]

#Inspect assumptions with a side by side boxplot
boxplot(SS,ST,SC, main="Steady state hemoglobin levels", xlab="Sickle cell disease type", names=c("SS", "ST", "SC"), range=0)

## Check Normality with Q-Q plot
qqnorm(SS_1, main="SS Q-Q Plot")
qqnorm(ST_2, main="ST Q-Q Plot")
qqnorm(SC_3, main="SC Q-Q Plot")

##################################################################

#From intro to stats
#how do draw a normal distribution and a t distribution (red)
curve(dnorm, from =-4, to=4)
curve(dt(x, df=5), col='red', add=TRUE) #add=TRUE adds this curve to the above graphed curve

##################################################################
##################################################################

#Plots from ggplot2###############

#load ggplot2
#if you need just ggplot2
library(ggplot2)
#but more likely you will be using it in conjuction with a tidyverse
#package. It's probably best to load tidyverse,
#ggplot2 is contained within it.
library(tidyverse)
#examples from gapminder, so load gapminder set
library(gapminder)
##################################################################
#Simple scatter plot- but not able to see much due to data grouping and amount of data
gapminder %>%
  ggplot(aes(x=gdpPercap, y=lifeExp))+ #this is the data for the graph. 
  geom_point() #this is the type of graph we want. 

#A more complex scatter- but viewable graph, using all 4 scatter aesthetics.
#first filter to one year
gapminder_2007<-gapminder %>%
  filter(year==2007)
#color, changes point colors to match catagorical variable (adds legend automatically)
#size, changes point size to correspond with population size
gapminder_2007 %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, color=continent, size=pop))+
  geom_point()+
  scale_x_log10() #scales data down so we can view it because there is a large range
#####################################################################
#Faceting
#produces multiple graphs dividing by a catagorical variable
#same plot as above but multiple years (one per plot), not just one year
gapminder %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, color=continent, size=pop))+
  geom_point()+
  scale_x_log10()+
  facet_wrap(~year)  #This tells R how to break down the plots. 
####################################################################
#Line plot - useful for showing change over time
#grouping by year and continent
by_year_continent<-gapminder %>%
  group_by(year, continent) %>%
  summarize(meanLifeExp=mean(lifeExp))
#line graph for above grouping
by_year_continent %>%  
  ggplot(aes(x=year, y=meanLifeExp, color=continent))+
  geom_line()
####################################################################  
#Bar plots - useful for comparing values across discrete catagories
##Ave life expectancy within each continent in 2007
by_continent <- gapminder %>%
  filter(year==2007) %>%
  group_by(continent) %>%
  summarize(meanLifeExp=mean(lifeExp))
#Represent above grouping in bar graph
ggplot(by_continent, aes(x=continent, y=meanLifeExp))+ #x is the catagorical value
    geom_col()                    #y is the variable that determines bar height
#####################################################################
#Histograms - describe the distribution of a single numerical variable 
ggplot(gapminder_2007, aes(x=lifeExp))+
  geom_histogram() #to adjust bins use binwidth= as argument to geom_histogram
#there is only one aesthetic, the variable who's distribution we are examining.
#####################################################################
#Box plots- compares the distribution of a numeric variable among several catagories

gapminder_2007 %>%
  ggplot(aes(x=continent, y=lifeExp))+ #x is the category
  geom_boxplot()+                       #y is values we're comparing
  ggtitle('Comparing life expectancy across continents for 2007') #adds a title to the graph

  
  