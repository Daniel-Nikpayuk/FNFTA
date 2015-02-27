
t <- read.csv("word_count.csv", colClasses="character")
names(t) <- c("Words", "Count")
t[,2] <- as.numeric(t[,2])

make_bar <- function()
{
	pdf("word_count.pdf")

	names <- gsub("_", " ", t[,1])
	counts <- t[,2]
	ordered <- order(counts, decreasing=TRUE)
	write.table(t[ordered,], file="ordered_words.log", quote=FALSE, sep=",\t\t\t", row.names=FALSE, col.names=FALSE)

	par(mai=c(1,2,1,1))
	barplot(counts[ordered], main="FNFTA Semiotic Space (Word Count)",
		horiz=TRUE, names.arg=names[ordered], xlab="Number of Occurences of Word", las=1, cex.names=0.12)

	dev.off()
}

make_bar()

