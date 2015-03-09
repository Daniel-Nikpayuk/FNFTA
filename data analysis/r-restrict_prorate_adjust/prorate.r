
#	Number
#	Nation
#	Auditor
#	Name_of_Individual
#	Position_Title
#	Number_of_Months
#	Remuneration
#	Expenses

chiefs <- read.csv("data_structure-chiefs-15-03-06-0405.csv", colClasses="character", check.names=FALSE, strip.white=TRUE)
council <- read.csv("data_structure-council-15-03-06-0405.csv", colClasses="character", check.names=FALSE, strip.white=TRUE)

normalize <- function(consolidated)
{
	consolidated$Number <- as.numeric(consolidated$Number)
	consolidated$Number_of_Months <- as.numeric(consolidated$Number_of_Months)
	consolidated$Remuneration <- as.numeric(consolidated$Remuneration)
	consolidated$Expenses <- as.numeric(consolidated$Expenses)

	consolidated[is.na(consolidated$Number_of_Months), "Number_of_Months"] <- 12
	consolidated[consolidated$Number_of_Months == 0, "Number_of_Months"] <- 12

	scalar <- 12/consolidated$Number_of_Months
	consolidated$Number_of_Months <- scalar*consolidated$Number_of_Months
	consolidated$Remuneration <- scalar*consolidated$Remuneration
	consolidated$Expenses <- scalar*consolidated$Expenses

	consolidated
}

write.csv(normalize(chiefs), "data_structure-prorated-chiefs.csv", row.names=FALSE)
write.csv(normalize(council), "data_structure-prorated-council.csv", row.names=FALSE)

