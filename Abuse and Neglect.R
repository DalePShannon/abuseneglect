library(plyr)
library(dplyr)
library(reshape2)

rm(list = ls())

setwd ("D:/Data/GitHub/abuseneglect")
# get file for abused and get subset for just 2013 not suppressed
abusekids <- read.csv("abuse-and-negelect.csv",header=TRUE,stringsAsFactors=FALSE,skip=0,strip.white=TRUE)
abusekids13 <- abusekids[abusekids$Year == "2013",]
abusekids13 <- abusekids13[abusekids13$Value > 0,]

# get all kids for denominator
allkids10 <- read.csv("kids2010_2_agegrps.csv",header=TRUE,stringsAsFactors=FALSE,skip=0,strip.white=TRUE)

# join dfs
abusecalc13 <- join(abusekids13,allkids10, by = c("Town", "Age.Range"))

# calc rate per (1000)
abusecalc13$"Rate per 1000" <- round(abusecalc13$Value/abusecalc13$Population *1000,digits=2)

abusecalc13.col <- abusecalc13[c(1,2,3,4,5,6,8,12)]
names(abusecalc13.col)[8]<-"Value"
abusecalc13.col$"Measure.Type" <- "Rate per 1000"
abusecalc13.final <- abusecalc13.col[c(1,2,3,4,5,6,9,7,8)]

abuse.final <- rbind(abusekids,abusecalc13.col)
names(abuse.final)[c(4,5,6,7)] <-
  c("Age Range",
    "Allegation Type",
    "Report Status",
    "Measure Type")

abuse.final <- abuse.final[!abuse.final$FIPS=="0NA",]

write.csv(abuse.final,"abuse neglect mod.csv",row.names=FALSE, quote=FALSE)
