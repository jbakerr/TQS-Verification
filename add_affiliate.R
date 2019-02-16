### Add affiliate names to student CM list

library(openxlsx)

setwd("/Users/baker/Code/consulting/CISNC/tqs_check/")


file_with_affiliate_names <- read.xlsx('student_cm_old.xlsx')

file_with_affiliate_names <- file_with_affiliate_names[,c(1,2)]


student_cm <- read.xlsx('student_cm.xlsx')


student_cm$Affiliate.Name <- NA

student_cm <- student_cm[,c(ncol(student_cm),1:(ncol(student_cm)-1))] # move last columm (affiliate name) to first position


# Sets Affiliate Name in the Student CM file equal to the Affiliate Name in the afifliate file if the schools match. 
student_cm$Affiliate.Name<-file_with_affiliate_names[match(student_cm$Home.School, file_with_affiliate_names$Home.School),1]



# Manual affiliates b/c data wasn't in original file

student_cm[student_cm$Home.School == '407 Uwharrie Ridge School',]$Affiliate.Name <- "CIS of Randolph County" 

student_cm[student_cm$Home.School == "Carroll Middle School",]$Affiliate.Name <- "CIS of Robeson County"

student_cm[student_cm$Home.School == "Exploris School",]$Affiliate.Name <- "CIS of Wake County" 

student_cm[student_cm$Home.School == "Lumberton Junior High",]$Affiliate.Name <- "CIS of Robeson County"

student_cm[student_cm$Home.School == "PLThomasboro Academy",]$Affiliate.Name <- "CIS of Charlotte-Mecklenburg" 

student_cm[student_cm$Home.School == "Red Oak Middle",]$Affiliate.Name <- "CIS of Rocky Mount Region"

student_cm[student_cm$Home.School == "507  Donna Lee Loflin Elementary",]$Affiliate.Name <- "CIS of Randolph County" 

student_cm[student_cm$Home.School == "CIS Academy",]$Affiliate.Name <- "CIS of Robeson County"

student_cm[student_cm$Home.School == "Fairmont Middle",]$Affiliate.Name <- "CIS of Robeson County"

student_cm[student_cm$Home.School == "Magnolia Elementary" ,]$Affiliate.Name <- "CIS of Robeson County"

student_cm[student_cm$Home.School == "Prospect Elementary",]$Affiliate.Name <- "CIS of Robeson County"

student_cm[student_cm$Home.School == "Red Springs Middle"  ,]$Affiliate.Name <- "CIS of Robeson County"

student_cm[student_cm$Home.School == "Cape Fear Middle",]$Affiliate.Name <- "CIS of Cape Fear" 

student_cm[student_cm$Home.School == "East Middle School",]$Affiliate.Name <- "CIS of Montgomery County"

student_cm[student_cm$Home.School == "Holly Shelter Middle School",]$Affiliate.Name <- "CIS of Cape Fear" 

student_cm[student_cm$Home.School == "Pender High School",]$Affiliate.Name <- "CIS of Cape Fear"

student_cm[student_cm$Home.School == "Purnell Swett",]$Affiliate.Name <- "CIS of Robeson County"



