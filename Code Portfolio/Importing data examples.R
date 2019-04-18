#This file is full of methods to use to import data into R

#How to import data using scan() 
#code from Intro to Stats
#data located in data folder
#reminder - set working directory (use session button above)
nerve=scan('nerve.txt')
head(nerve)

#Load data from set in r library
#code from applied data science
data("mtcars")


#How to load data from a built in data set from
#a library loaded into R
#code from applied data science midterm
library(tidyverse)
data(who) #data from the World Health Organization. Data set contained in tidyverse

#different data (from applied data science)
library(nycflights13)
data(flights)

#How to preview the data just brought into R (from applied data science)
head(who)
head(flights)

#Alternate preview to better view variables and their types (from applied data science)
glimpse(who)

#how to use read.table() with a file that has a header (from intro to stats)
singer<-read.table("singer.txt", header=TRUE)

#how to read in a csv file (code from intro to stats)
income<- read.csv('income.csv')

#how to read in a csv as a dataframe. code from Applied Data Science Midterm
q1<-as.data.frame(read.csv("US EPA data 2017.csv"))

#Loading and previewing data from the web: Earthquake magnitudes
earthquake.data=read.table("http://service.scedc.caltech.edu/ftp/catalogs/SCEC_DC/2014.catalog")
head(earthquake.data)

#or (From Stats assignment 10 question1 part2)
data_1.2=scan("http://mypage.iu.edu/~mtrosset/StatInfeR/Data/cholesterol.dat")

#how to manually enter data to analyze (from stats midterm 2)
old=c(.89,.49,.91,.80,.56,.79,.47,.50,1.08,1.65,1.94)
new=c(2.13,1.16,2.6,1.58,1.53,1.70,2.67,2.64,2.19,2.54,4.46)
data.frame(old,new)

