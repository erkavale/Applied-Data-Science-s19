#Data Wrangling notes  (unrelated code separated by ######)

#tidy data - a standard way of mapping the meaning of a dataset to its structure
#3 Fundamental rules
#1) Each variable forms a column
#2) Each observation forms a row
#3) Each type of observational unit forms a table

#load tidyr explicitly or through tidyverse
library(tidyverse)
#code from https://r4ds.had.co.nz/tidy-data.html (R for Data Science Ch12)
#and from week 5 lectures
###########################################################################
#gather() - transforms a wide table into a long table

#from Week5 lecture, column headers are values, not variable names
messy<-data.frame(name=c('Wilbur', 'Petunia', 'Gregory'),a=C(67,80,64), b=c(56,90,50))
#gather values and assign to variables
messy %>%
  gather(drug, heartrate, a:b)

#from R for Data Science Ch12
#these two tables have related variables in two separate tables and must be joined together
# We need 3 things to fix this.
##1)The set of columns that represent values, not variables.
##2)The name of the variable whose values form the column names. That's called the key, and here it is the number of cases.
##3)The name of variable whose values are spread over the cells. That's called the value, and here it's # of cases.
###Note: because 1999 and 2000 don't start witha letter we must use ``.
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)
##########################################################################
#from R for Data Science Ch12
#spread() - transforms a long table into a wide table. 
#Use when an observation is scattered across multiple rows.
#Here we only nee 2 parameters
##1)The column that contains variable names, the key column, here it is type
##2)The column that contains values from multiple variables, value, here it is count.
table2 %>%
  spread(key = type, value = count)
##########################################################################
#from R for Data Science Ch12
#separate()-teases variables apart by using splitting patterns
#We need to split rate into two variables
table3 %>% 
  separate(rate, into = c("cases", "population"))
#To do a specific character
table3 %>%
  separate(rate, into=c('cases', 'population', sep='/'))
#convert=TRUE converts variables to more approriate type. 
table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)
##########################################################################
#from R for Data Science Ch12
#Unite - the opposite of separate
#say we want to unite the separation we just did.
table3 %>%
  unite(new, century, year, sep="")#If we dont do "" it will add a _ between century and year.
#new is the name of the new variable resulting from the union of century and year.
##########################################################################
#from R for Data Science Ch12
#Missing values - can be
#Explicit - flagged with NA, or
#Implicit - not present in the data.
#code from 
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
#two missing values here: the NA and Q1 2016 data.
#If we use spread, the NA value will appear for 2016.
stocks %>% 
  spread(year, return)

#to turn explicit values to implicit (because you may not care if they're just not there (implicit))
#use na.rm=TRUE
stocks %>% 
  spread(year, return) %>% 
  gather(year, return, `2015`:`2016`, na.rm = TRUE)

#complete() takes a set of columns, and finds all unique combinations. It then ensures the original 
#dataset contains all those values, filling in explicit NAs where necessary.
stocks %>% 
  complete(year, qtr)

#Use fill() when the previous value should be carried forward to the missing value.
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment %>% 
  fill(person)
#> # A tibble: 4 x 3
#>   person           treatment response
#>   <chr>                <dbl>    <dbl>
#> 1 Derrick Whitmore         1        7
#> 2 Derrick Whitmore         2       10
#> 3 Derrick Whitmore         3        9
#> 4 Katherine Burke          1        4

###########################################################################

#Load packages
library(gapminder) #dataset
library(tidyverse)
# or you can just use library(dplyr) but its most likely that you will also 
# need ggplot2 and/or tidyr so might as well load all via tidyverse

#dplyr uses VERBS to transform data. Below are examples of the verbs.
########################################################################
#select()- a verb that returns a subset of columns #code self created
#suppose we want to see just continent and life exp
gapminder %>% 
  select(continent, lifeExp)
#or you can use - to drop a column. Suppose we no longer are interested in continent.
gapminder %>%
  select(-continent)
#########################################################################
# filter() - a verb that is used to look only at a subset of observations (rows)
# based on a particular condition. #code from data camp

#filter to see only the year
gapminder %>% #<----you must "pipe" the data to the next step
  filter(year==2007) # when specifying a string don't forget "quotes"

#Can filter multiple conditions at once
gapminder %>%
  filter(year==2007, country=="United States")
########################################################################
# arrange() - a verb that sorts ascending or decending by passing a variable
#Ascending is default
gapminder %>%
  arrange(gdpPercap) 

#Descending
gapminder %>%
  arrange(desc(gdpPercap)) #puts largest amount 1st
########################################################################
# mutate()- a verb that changes or adds variables
#EX1 change a variable . from data camp videos
gapminder %>%
  mutate(pop=pop/1000000)
#replaces pop variable with pop/1000000, but not in the original data

#Ex2 add a new variable 
gapminder %>%
  mutate(gdp=gdpPercap*pop) #total gdp does not exist in original dataset

#Ex3 add a new variable 2
#dataset life from DataCamp. code also from data camp videos
life=read.csv('life_exp_raw.csv')
#save the newly created variable back to the dataset
life<-life %>%
  mutate(west_coast=State %in% c('California', 'Oregon', 'Washington'))
#makes a new logic type variable that shows TRUE if state is one of the listed
#states and FALSE if not. %in% is stating that to be TRUE the value in state
#must be in our combined listed group

# filter(), arrange(), and mutate() does not alter the original data just
# the data frame being returned unless you force it, like above. It still
# does not alter the original data file.
########################################################################
#Combination of 3 above verbs used in conjunction
#find countries with higherst GDP for 2007
gapminder %>%
  mutate(gdp=gdpPercap*pop) %>% #each new step must be piped to the next
  filter(year==2007) %>%
  arrange(desc(gdp))
########################################################################




