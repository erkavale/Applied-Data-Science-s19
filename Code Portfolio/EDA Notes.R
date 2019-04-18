#Exploratory Data Analysis notes  (unrelated code separated by ######)

#There are some important verbs from dplyr that were not noted in Data Wrangling
#because they are more for EDA.

#############################################################################
#code from data camp introduction to tidyverse
library(tidyverse) #load tidyverse to access dplyr and its verbs.
library(gapminder) #none of the code works unless you load the dataset
# summarize()- turns many rows into one and provides summary statistics.
#summarizing mean life expectancy
gapminder %>%
  summarize(meanLifeExp=mean(lifeExp))
#summarizing one year and total population
gapminder %>%
  filter(year==2007) %>%
  summarize(meanLifeExp=mean(lifeExp), totalPop=sum(pop))

#Most popular function used in summarize:
#mean(), median(), sum(), min(), max()

##############################################################################    
#What if we wat to summarize, like above, but for all the yeas in the dataset?
#This is where group_by() comes in.
# group_by() - turns groups into one row each. 

gapminder %>% 
  group_by(year) %>%
  summarize(meanLifeExp=mean(lifeExp), totalPop=sum(pop))
#returns a summary of mean(lifeExp) and sum(pop) for each year
  
#what if we wanted to know the ave life expectancy and the total population
#in 2007 within each continent?
gapminder %>%
  filter(year==2007) %>%
  group_by(continent) %>%
  summarize(meanLifeExp=mean(lifeExp), totalPop=sum(pop))

#Summarize by continent and year
gapminder %>%
  group_by(year, continent) %>% #variables will appear in same order in summary tibble
  summarize(totalPop=sum(pop), meanLifeExp=mean(lifeExp))
###########################################################################  
#code from datacamp Exploratory Data Analysis
#data from a file about comics
#Exploring catagorical data
comics=read.csv('comics.csv', header=TRUE)

#remove align level - because there is just not that much data there
comics_filtered<-comics %>%
  filter(align !='Reformed Criminals') %>%
  droplevels() #removes a catagory from catagorical data
#also appears to remove all observations with NA for that variable

#Count vs proportion tables
tab_cnt<-table(comics_filtered$id, comics_filtered$align) #shows counts for IDs and their alignment
tab_cnt #to view table counts

prop.table(tab_cnt) #turns count table into proportions. Whole table sums to 1.
prop.table(tab_cnt, 1) #proportions for rows. rows sum to 1
prop.table(tab_cnt, 2)#proportions for columns. columns sum to 1

#better to view proportions in visual
ggplot(comics_filtered, aes(x=id, fill=align))+ #plot of proportion on align, conditional on id
  geom_bar(position='fill')+ #fill streches the stacked bars so they all add to 1
  ylab('proprtion')

#just switching the x and fill values shows a whole new visual
ggplot(comics_filtered, aes(x=align, fill=id))+
  geom_bar(position = 'fill')+
  ylab('proportion')
#############################################################################
#Exploring numerical data from DataCamp
#using dataset from data camp-cars04
cars<-read.csv('cars04.csv', header=TRUE)

#The distribution on one variable can be viewed in different ways.
#1) Marginal
ggplot(cars, aes(x=hwy_mpg))+ #looks at the numerical variable hwp_mpg
  geom_histogram()

#2a)Conditional - by catagorical variabe
ggplot(cars, aes(x=hwy_mpg))+
  geom_histogram()+
  facet_wrap(~pickup) #produces 2 histograms. condition is pickup, True or False

#2b)Conditional - by numerical variable
#Facets will not work on numerical variable must use filter()
#Car that have engine size 2.0 or less
cars %>%
  filter(eng_size <= 2.0) %>%   #filters cars for 2.0 or less
  ggplot(aes(x=hwy_mpg))+   #then draws histogram
  geom_histogram(binwidth=2) #changed bin width to display better

#another example of 2b
#horsepower for cars under $25k
cars %>%
  filter(msrp<25000) %>%
  ggplot(aes(x=horsepwr))+
  geom_histogram(binwidth=10)+
  xlim(c(70,300))+ #reduces the x axis to specified range to better display histogram
  ggtitle('histogram of horsepower under $25k')

#3) box plot
#normal side by side plot
common_cyl<-filter(cars, ncyl %in% c(4,6,8)) #filters cars that have this # of cylinders
ggplot(common_cyl, aes(x=as.factor(ncyl), y=city_mpg))+
  geom_boxplot() #must use as.factor() because R doesn't know the # should be a catagory

#4) Density plot #A smoothed histogram
common_cyl %>%
  ggplot(aes(x=width, fill=as.factor(ncyl)))+ #fill draws a density plot for each category
  geom_density(alpha=0.3) #aplha adjusts the opacity. 0 to 1 with 0=no fill to 1=solid

#5 Outliers 
#can make your data hard to view so you may want to remove them to better analyze the data
cars<-cars %>%
  mutate(is_outlier=msrp>100000) #adds a True False column for the condition
#plotting without outliers
cars %>%
  filter(!is_outlier) %>% #here ! is the same as !=
  ggplot(aes(x=as.factor(ncyl), y=msrp))+
  geom_boxplot()
#you still have catagorical outliers but not the very large $100k+ ones  