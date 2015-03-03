
# The following are manual notes created when physically looking through the pdfs. They're informal verification
# the pull method here works (or rather counterexamples to prove it doesn't work):

# 34 Twelve.
# 370 " Months".
# 400 " months".
# 455 " months".
# 536 " months".
# 540 " months".
# 574 " months".
# 605 " months".
# 714 " Months".

# 689 "Year"

# 22 Months_NA --- assumed 12
# 458 Months_NA --- assumed 12

# 9 fraction between time spent as chief and time spent as councillor.
# 14 NA months.
# 17 NA months.

# 64 partial drop --- reimbursement should actually be subtracted from travel expense to determine the expense.
# 87 partial drop --- Frais_de_Voyages "Note 1" is NA --> 0 and doesn't add anyway.
# 122 partial drop --- reimbursement should actually be subtracted from travel expense to determine the expense.
# 287 Dropped.
# 358 partial drop.
# 406 partial drop.
# 605 partial drop?

#645 months as fractions: 1/2 (0.5)

default <- read.csv("default_map.log", colClasses="character", header=FALSE, check.names=FALSE, strip.white=TRUE)

raw <- read.csv("data_structure-raw-15-03-03-0009.csv", colClasses="character", check.names=FALSE, strip.white=TRUE)
tail_headers <- tail(names(raw), -3)

get_nas <- function(col_name)
{
	if (is.na(default[default[,1] == col_name, 2])) FALSE
	else any(is.na(as.numeric(raw[,col_name])))
}

na_headers <- tail_headers[sapply(tail_headers, get_nas)]

sapply(raw[, na_headers], unique)

na_headers
