library(openxlsx)

setwd("/Users/baker/Code/consulting/CISNC/tqs_check/")

student_cm <- read.xlsx('student_cm.xlsx')

affiliates <- unique(student_cm$Affiliate.Name)

colnames(student_cm)[14] <- "metrics_assigned"

colnames(student_cm)[15] <- "progress_entries"

suppressMessages(attach(student_cm))

fields_to_validate <- c(
  "missing_consent", "no_support_plan", "no_metrics", "no_supports",
  "no_check_ins", "no_progress")

work_sheet_names <- c(
  "No Parent Consent", "No Student Support Plan", 
  "No Metrics", "No Tier 2/3", "No Check Ins", 
  "No Progress Monitoring")


### Email Setup

missing_conset_explanation <- "If a student is missing parent or guardian consent they will be populated here. This can be resolved by ensuring the parental consent is on file and then navigating to the student's dashboard and selecting Parent/Guardian Consent.\n\n"

no_support_plan_explanation <- "If a student is enrolled but doesn't have a completed support plan they will be populated here. This can be resolved by navigating to the student's dashboard and selecting Goal Setting and Support Plan and ensuring that everything is completed.\n\n"

no_metrics_explanation <- "If a student doesn't have any metrics assigned they will populate here. To resolve this, first ensure the support plan is completed (see above). If there is a support plan, you can select the gear icon next to the support plan and select edit 'ABC Goals/Targets' to complete the necessary metrics.\n\n"

no_supports_explanation <- "If a student has no Tier 2/3 supports entered thus far they will populate here. To resolve, enter completed supports through the Tier2/3 Support Entry. \n\n"

no_check_ins_explanation <- "If a student hasn't had any check-ins entered they will populate here. To resolve, either enter a specific check-in through the 'Check In Entry' or by adding a check-in to a regular Tier2/3 support. NOTE, National has acknowledged that some students with check-ins will not populate here depending on how the check-in was entered. If you notice a number of students with this flag and believe this is incorrect please contact me.\n\n"

no_progress_explanation <- "If a student hasn't had any progress monitoring entries recorded they will populate here. To resolve, ensure the student has metrics assigned (see above), if so then navigate to 'Progress Monitoring and Goal Achievement' and use the gear to fill in the required data.\n\n"

email_note <- "Please note, just because a student is populated here, doesn't mean you have done anything incorrectly. If you are still waiting to enroll a student, enter progress monitoring data, or if a student hasn't been served yet they will likely populate here. Please just review the data and check for anything that looks suspicious. I'm happy to help any questions or concerns that arise from this report.\n\n"

email_close <- "Thank you for reviewing the data, I understand it can be overwhelming! Please let me know if you have any questions or concerns.\n\nBest, Baker"


for(i in 1:length(affiliates)){
  
  missing_conset_result <- "Number of students missing consent: "
  no_support_plan_result <- "Number of students missing a support plan: "
  no_metrics_result <- "Number of students missing metrics: "
  no_supports_result <- "Number of students with no supports: "
  no_check_ins_results <- "Number of students with no check ins: "
  no_progress_results <- "Number of students with no progress monitoring entries: "
  
  
  
  
  if(grepl('/', affiliates[i])){
    student_cm[Affiliate.Name == affiliates[i], "Affiliate.Name"] <- gsub("/", "", student_cm[Affiliate.Name == affiliates[i], "Affiliate.Name"])
    affiliates[i] <- gsub("/", "", affiliates[i])
    
  }
  

  missing_consent <- subset(
    student_cm, `Parental.Consent.Received?` == "No" & 
      Affiliate.Name == affiliates[i], select = c(Home.School, Student)
    )  
  
  no_support_plan <- subset(
    student_cm, `Student.Support.Plan.Entered?` == "No" & 
      Affiliate.Name == affiliates[i], select = c(Home.School, Student)
  )  

  no_metrics <- subset(
    student_cm, (metrics_assigned == 0 | is.na(metrics_assigned)) &
      Affiliate.Name == affiliates[i], select = c(Home.School, Student)
    )

  no_supports <- subset(
    student_cm, (Tiered.Supports == 0 | is.na(Tiered.Supports)) &
      Affiliate.Name == affiliates[i], select = c(Home.School, Student)
  )
  
  no_check_ins <- subset(
    student_cm, (`Total.#.of.check-ins` == 0 | is.na(`Total.#.of.check-ins`)) & 
      Affiliate.Name == affiliates[i], select = c(Home.School, Student)
  )

  no_progress <- subset(
    student_cm, (progress_entries == 0 | is.na(progress_entries)) & 
      Affiliate.Name == affiliates[i], select = c(Home.School, Student)
  )

  
  list_of_datasets <- list("No Parent Consent" = missing_consent, "No Support Plan" = no_support_plan,
                           "No Metrics" = no_metrics, "No Supports" = no_supports, "No Check Ins" = no_check_ins,
                           "No Progress Monitoring" = no_progress)

  hs <- createStyle(textDecoration = "BOLD", fontColour = "#FFFFFF", fontSize=12,
                    fontName="Arial Narrow", fgFill = "#4F80BD")
  
  
  setwd("/Users/baker/Code/consulting/CISNC/tqs_check/Q1_Review")
  
  write.xlsx(list_of_datasets, file = paste(affiliates[i], 'TQS Review.xlsx', sep = " "), colWidths="auto", headerStyle = hs)
  
  setwd("/Users/baker/Code/consulting/CISNC/tqs_check/Q1_Review/emails")
  
  missing_conset_result <- paste(missing_conset_result, nrow(missing_consent), "\n\n", sep = "")
  no_support_plan_result <- paste(no_support_plan_result, nrow(no_support_plan), "\n\n", sep = "")
  no_metrics_result <- paste(no_metrics_result, nrow(no_metrics), "\n\n", sep = "")
  no_supports_result <- paste(no_supports_result, nrow(no_supports), "\n\n", sep = "")
  no_check_ins_results <- paste(no_check_ins_results, nrow(no_check_ins), "\n\n", sep = "")
  no_progress_results <- paste(no_progress_results, nrow(no_progress), "\n\n", sep = "")
  
  email_intro <- paste("Dear ", affiliates[i], " team,\n\n", "Here is a report outlining your TQS status as of today. Please review the explanations and attached file (in a seperate email) to see a list of students who might need additional support.\n\n", sep = "")
  

  email <- paste(
    email_intro, email_note,
    missing_conset_result, missing_conset_explanation,
    no_support_plan_result, no_support_plan_explanation,
    no_metrics_result, no_metrics_explanation,
    no_supports_result,no_supports_explanation,
    no_check_ins_results, no_check_ins_explanation,
    no_progress_results, no_progress_explanation,
    email_close, sep=""
                 )
  
  sink(paste(affiliates[i], 'email.txt', sep= "_"))
  writeLines(email)
  sink()
  


}





