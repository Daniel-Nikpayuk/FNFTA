
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

restrict <- function(consolidated)
{
	consolidated$Number <- as.numeric(consolidated$Number)
	consolidated$Number_of_Months <- as.numeric(consolidated$Number_of_Months)
	consolidated$Remuneration <- as.numeric(consolidated$Remuneration)
	consolidated$Expenses <- as.numeric(consolidated$Expenses)

	consolidated[is.na(consolidated$Number_of_Months), "Number_of_Months"] <- 12
	consolidated[consolidated$Number_of_Months == 0, "Number_of_Months"] <- 12

	consolidated[consolidated$Number_of_Months == 12,]
}

write.csv(restrict(chiefs), "data_structure-restricted-chiefs.csv", row.names=FALSE)
write.csv(restrict(council), "data_structure-restricted-council.csv", row.names=FALSE)

