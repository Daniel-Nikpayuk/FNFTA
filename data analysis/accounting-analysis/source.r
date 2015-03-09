
consolidated <- read.csv("data_structure-consolidated-15-03-06-0221.csv", colClasses="character")

firm_name <- function(number)
{
	rows <- consolidated[consolidated$Number == number,]
	gsub("_", " ", unique(rows$Auditor[!is.na(rows$Auditor)]))
}
total_firms <- sapply(unique(consolidated$Number), firm_name)
firms <- unique(total_firms)

count <- function(firm) { sum(total_firms == firm) }
counts <- sapply(firms, count)
ordered <- order(counts)

make_bar <- function(filename)
{
	jpeg("accounting firms.jpg", width=768, height=768)

	par(mai=c(1,2,1,1))
	xlab_str=paste("Number of First Nation Accounts (out of", paste(sum(counts), ")", sep=""))
	barplot(counts[ordered], main="FNFTA Independent Reviewers (Accounting Firms)",
		horiz=TRUE, names.arg=firms[ordered], xlab=xlab_str, las=1, cex.names=0.25)

	dev.off()
}

make_bar()

descending <- order(counts, decreasing=TRUE)
frame <- data.frame(I(firms[descending]), counts[descending], row.names=NULL)
write.table(head(frame, n=10), "top_ten_firms.log", quote=FALSE, sep=", ", row.names=FALSE, col.names=FALSE)

