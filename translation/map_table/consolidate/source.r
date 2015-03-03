
header_map <- read.csv("data_structure-header_map.log", header=FALSE, colClasses="character", check.names=FALSE, strip.white=TRUE)
header_map[,1] <- as.numeric(header_map[,1])
max_num <- max(header_map[,1])
header_map[,3]=gsub("*", "", header_map[,3], fixed=TRUE)

raw <- read.csv("data_structure-cleaned_raw-15-03-03-0315.csv", colClasses="character", check.names=FALSE, strip.white=TRUE)
tail_headers <- tail(names(raw), -3)

zeroes <- rep(0, nrow(raw))
nas <- rep(NA, nrow(raw))
consolidated <- data.frame(
	Number=raw$Number,
	Nation=raw$Nation,
	Auditor=raw$Auditor,
	Name_of_Individual=nas,
	Position_Title=nas,
	Number_of_Months=zeroes,
	Remuneration=zeroes,
	Expenses=zeroes
)

weeks <- c("Nombre_de_mois/semaines",
	"Nombre_de_semaines",
	"Nombre_semaines",
	"Number_of_Weeks",
	"Number_of_Weeks_in_office",
	"Number_of_weeks",
	"Weeks"
)

for (col_name in weeks) # 12 months : 52 weeks --> 12/52 months : 1 week
{
	raw[,col_name] <- 12*as.numeric(raw[,col_name])/52
}

for (num in 1:max_num)
{
	header_map_rows <- header_map[,1] == num
	consolidated_rows <- consolidated[,1] == num
	if (any(header_map_rows)) for (col_name in tail_headers)
	{
		map_index <- header_map[header_map_rows, 2] == col_name
		if (any(map_index))
		{
			mapped_name <- header_map[header_map_rows, 3][map_index]
			if (mapped_name == "Name_of_Individual" || mapped_name == "Position_Title")
			{
				raw_rows <- raw[consolidated_rows, col_name]
				if (!all(is.na(raw_rows))) consolidated[consolidated_rows, mapped_name] <- raw_rows
			}
			else if (mapped_name != "Drop")
			{
				consolidated[consolidated_rows, mapped_name] <-
				as.numeric(consolidated[consolidated_rows, mapped_name]) +
				as.numeric(raw[consolidated_rows, col_name])
			}
		}
	}
}

sort_index <- order(consolidated$Number)
write.csv(consolidated[sort_index,], "data_structure-consolidated.csv", row.names=FALSE)

