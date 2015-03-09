
#	Number
#	Nation
#	Auditor
#	Name_of_Individual
#	Position_Title
#	Number_of_Months
#	Remuneration
#	Expenses

consolidated <- read.csv("data_structure-consolidated-15-03-06-0221.csv", colClasses="character", check.names=FALSE, strip.white=TRUE)
consolidated[,1] <- as.numeric(consolidated[,1])
consolidated$Number_of_Months <- as.numeric(consolidated$Number_of_Months)
consolidated$Remuneration <- as.numeric(consolidated$Remuneration)
consolidated$Expenses <- as.numeric(consolidated$Expenses)

pull_current <- function()
{
	row_record_na <- c("Auditor", "Name_of_Individual","Position_Title")
	row_record_num <- c("Number_of_Months","Remuneration","Expenses")

	na_rows <- apply(consolidated[,row_record_na], 1, function(row) { all(is.na(row)) })
	twelves <- apply(consolidated[,row_record_num], 1, function(row) { sum(row, na.rm=TRUE) == 12 })

	!(na_rows & twelves)
}

current_rows <- pull_current()
current <- consolidated[current_rows,]

# manually looking it over, I feel there is justification for the following normalization:
current[is.na(current$Position_Title), "Position_Title"] <- "Councillor"

#################################

skim_position_title <- function(regex)
{
	rows <- grep(regex, current$Position_Title)
	unique(current[rows, "Position_Title"])
}

#################################

# Chief:

write.csv(skim_position_title("[Cc]hief|[Cc]hef"), "chiefs_grep.log", quote=FALSE, row.names=FALSE)

# Council:

write.csv(skim_position_title("[Cc]ouncil|[Cc]onseil"), "council_grep.log", quote=FALSE, row.names=FALSE)

