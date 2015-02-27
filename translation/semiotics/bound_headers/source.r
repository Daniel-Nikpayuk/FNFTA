
t <- read.csv("bound_headers.csv", colClasses="character")
t[,2] <- as.numeric(t[,2])

pdf("bound_headers.pdf")

names <- gsub("__", ", ", t[,1])
names <- gsub("_", " ", names)
counts <- t[,2]
ordered <- order(counts)

par(mai=c(1,3,1,1))
barplot(counts[ordered], main="FNFTA Header Signifiers (Semiotic Spaces)",
	horiz=TRUE, names.arg=names[ordered], xlab="Number of Bound Headers", las=1, cex.names=0.1)

dev.off()

tail(t[ordered,])

