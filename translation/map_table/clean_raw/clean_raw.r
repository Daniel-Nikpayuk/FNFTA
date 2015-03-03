
# The following is the list of headers whose columns contain NAs:

# na_headers
# [1] "#_of_Months"                                
# [2] "Expenses_NA"                                
# [3] "Expenses_Reimbursed"                        
# [4] "Frais_de_Voyages"                           
# [5] "Honoraria_Reimbursement"                    
# [6] "Length_of_Employment"                       
# [7] "Length_of_Service"                          
# [8] "Months"                                     
# [9] "Months_Covered"                             
#[10] "Months_NA"                                  
#[11] "Nombre_de_mois/semaines"                    
#[12] "Nombre_de_mois_en_poste"                    
#[13] "Number_of_Months"                           
#[14] "Number_of_Months_on_the_Board"              
#[15] "Other_Remuneration"                         
#[16] "Period"                                     
#[17] "Program_Expenses"                           
#[18] "Remuneration_NA"                            
#[19] "Term"                                       
#[20] "Time_in_Office_during_2013-2014_fiscal_year"
#[21] "Travel_Expenses"                            

# codified as:

bad_cols <- c("#_of_Months",
	"Expenses_NA",
	"Expenses_Reimbursed",
	"Frais_de_Voyages",
	"Honoraria_Reimbursement",
	"Length_of_Employment",
	"Length_of_Service",
	"Months",
	"Months_Covered",
	"Months_NA",
	"Nombre_de_mois/semaines",
	"Nombre_de_mois_en_poste",
	"Number_of_Months",
	"Number_of_Months_on_the_Board",
	"Other_Remuneration",
	"Period",
	"Program_Expenses",
	"Remuneration_NA",
	"Term",
	"Time_in_Office_during_2013-2014_fiscal_year",
	"Travel_Expenses"
)

##########################

raw <- read.csv("data_structure-raw-15-03-03-0009.csv", colClasses="character", check.names=FALSE, strip.white=TRUE)

##########################
sub_pars <- function (col_name)
{
	numeric_regex <- "[0-9]+(\\.[0-9]+)?"
	pars_regex <- paste("\\((", numeric_regex, ")\\)", sep="")
	gsub(pars_regex, "-\\1", raw[,col_name])
}

clear <- function (col_name, str)
{
	gsub(str, "", raw[,col_name], fixed=TRUE)
}

# Begin:

col_name <- "#_of_Months"
	raw[is.na(raw[,col_name]),col_name] <- "12"

col_name <- "Expenses_NA"
	raw[is.na(raw[,col_name]),col_name] <- "0"

col_name <- "Expenses_Reimbursed"
	raw[,col_name] <- sub_pars(col_name)

col_name <- "Frais_de_Voyages"
	raw[is.na(raw[,col_name]),col_name] <- "0"

col_name <- "Honoraria_Reimbursement"
	raw[,col_name] <- sub_pars(col_name)

col_name <- "Length_of_Employment"
	raw[,col_name] <- clear(col_name, "_Months")

col_name <- "Length_of_Service"
	raw[,col_name] <- clear(col_name, "_Months")

col_name <- "Months"
	raw[is.na(raw[,col_name]),col_name] <- "12"
	raw[,col_name] <- gsub("12/7", "12", raw[,col_name]) # the "/7" is CEO duration.

col_name <- "Months_Covered"
	raw[,col_name] <- clear(col_name, "_months")
	raw[,col_name] <- clear(col_name, "_month")

col_name <- "Months_NA"
	raw[is.na(raw[,col_name]),col_name] <- "12"

col_name <- "Nombre_de_mois/semaines" # semaines (weeks) was chosen because it seems more accurate.
	raw[,col_name] <- gsub("12/52", "52", raw[,col_name])
	raw[,col_name] <- gsub("5__5/22", "22", raw[,col_name])
	raw[,col_name] <- gsub("4/16", "16", raw[,col_name])
	raw[,col_name] <- gsub("6/26", "26", raw[,col_name])
	raw[,col_name] <- gsub("9/40", "40", raw[,col_name])

col_name <- "Nombre_de_mois_en_poste"
	raw[is.na(raw[,col_name]),col_name] <- "12"

col_name <- "Number_of_Months"
	raw[is.na(raw[,col_name]),col_name] <- "12"
	raw[,col_name] <- clear(col_name, "_months")
	raw[,col_name] <- gsub("3_weeks", as.character(3*12/52), raw[,col_name], fixed=TRUE) # 12 months : 52 weeks
	raw[,col_name] <- gsub("Twelve", "12", raw[,col_name], fixed=TRUE)
	raw[,col_name] <- gsub("4/8(12)", "12", raw[,col_name], fixed=TRUE) # problematic as 4 is chief and 8 is council (vice versa).
	raw[,col_name] <- gsub("1/52", as.character(1*12/52), raw[,col_name], fixed=TRUE) # 12 months : 52 weeks
	raw[,col_name] <- gsub("12/02", "12", raw[,col_name], fixed=TRUE) # 12 for Council.
	raw[,col_name] <- gsub("12/09", "12", raw[,col_name], fixed=TRUE) # 12 for Council.
	raw[,col_name] <- gsub("12/3.5", "12", raw[,col_name], fixed=TRUE) # 12 for Council.
	raw[,col_name] <- gsub("1/2", "0.5", raw[,col_name], fixed=TRUE)

col_name <- "Number_of_Months_on_the_Board"
	raw[,col_name] <- clear(col_name, "_months")

col_name <- "Other_Remuneration"
	raw[,col_name] <- gsub("718/1117", as.character(718+1117), raw[,col_name], fixed=TRUE)

col_name <- "Period"
	raw[,col_name] <- gsub("Year", "12", raw[,col_name], fixed=TRUE)

col_name <- "Program_Expenses"
	raw[,col_name] <- gsub("Long_Plain_First_Nation_Tribal_Council", "0", raw[,col_name], fixed=TRUE)

col_name <- "Remuneration_NA"
	raw[is.na(raw[,col_name]),col_name] <- "0"

col_name <- "Term"
	raw[,col_name] <- clear(col_name, "_months")
	raw[,col_name] <- gsub("Dec'13-Mar'14", "4", raw[,col_name], fixed=TRUE)
	raw[,col_name] <- gsub("Apr'13-Mar'14", "12", raw[,col_name], fixed=TRUE)
	raw[,col_name] <- gsub("Apr'13-Nov'13", "8", raw[,col_name], fixed=TRUE)

col_name <- "Time_in_Office_during_2013-2014_fiscal_year"
	raw[,col_name] <- clear(col_name, "_months")

col_name <- "Travel_Expenses"
	raw[,col_name] <- sub_pars(col_name)

write.csv(raw, "data_structure-cleaned_raw.csv", row.names=FALSE)

