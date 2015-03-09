
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

adjust <- function(consolidated)
{
	consolidated$Number <- as.numeric(consolidated$Number)
	consolidated$Number_of_Months <- as.numeric(consolidated$Number_of_Months)
	consolidated$Remuneration <- as.numeric(consolidated$Remuneration)
	consolidated$Expenses <- as.numeric(consolidated$Expenses)

	consolidated[is.na(consolidated$Number_of_Months), "Number_of_Months"] <- 12
	consolidated[consolidated$Number_of_Months == 0, "Number_of_Months"] <- 12

	quotient <- consolidated[consolidated$Number_of_Months == 12,]
	remainder <- consolidated[consolidated$Number_of_Months != 12,]

		# not at all efficient (rbind)
	for (num in unique(remainder$Number))
	{
		rows <- remainder$Number == num
		len <- nrow(remainder[rows,])
		if (len == 1) quotient <- rbind(quotient, remainder[rows,])
		else
		{
			month_order <- order(remainder[rows,"Number_of_Months"])
			quotient <- rbind(quotient, remainder[rows,][tail(month_order, as.integer((len+1)/2)),])
		}
	}

	scalar <- 12/quotient$Number_of_Months
	quotient$Number_of_Months <- scalar*quotient$Number_of_Months
	quotient$Remuneration <- scalar*quotient$Remuneration
	quotient$Expenses <- scalar*quotient$Expenses

	quotient
}

write.csv(adjust(chiefs), "data_structure-adjusted-chiefs.csv", row.names=FALSE)
write.csv(adjust(council), "data_structure-adjusted-council.csv", row.names=FALSE)

