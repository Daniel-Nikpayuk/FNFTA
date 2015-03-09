
#	Number
#	Nation
#	Auditor
#	Name_of_Individual
#	Position_Title
#	Number_of_Months
#	Remuneration
#	Expenses

read <- function(name)
{
	frame <- read.csv(name, colClasses="character", check.names=FALSE, strip.white=TRUE)
	frame$Number_of_Months <- as.numeric(frame$Number_of_Months)
	frame$Remuneration <- as.numeric(frame$Remuneration)
	frame$Expenses <- as.numeric(frame$Expenses)

	frame
}

#################################

# Apply meas to frame[,col] except name.
apply_except <- function(meas, frame, col, name) { meas(frame[frame$Name_of_Individual != name, col], na.rm=TRUE) }

# Apply meas to frame[,col] except the top num.
apply_by_tail <- function(meas, frame, col, num) { meas(head(frame[,col][order(frame[,col])], n=-num), na.rm=TRUE) }

# Apply meas to frame[,col] except any equal-above num.
apply_by_amount <- function(meas, frame, col, num) { meas(frame[,col][frame[,col] < num], na.rm=TRUE) }

#################################

# For each name, meas_except that name; take the difference from frame_meas and return it as the vector of all such values.

pull_deviation <- function(meas, frame, col)
{
	frame_meas <- meas(frame[,col], na.rm=TRUE)
	meas_except <- function(name) { frame_meas-meas(frame[frame$Name_of_Individual != name, col], na.rm=TRUE) }

	sapply(frame$Name_of_Individual, meas_except)
}

#################################

# Remove NAs from frame[,col] and sorts; pops lower and upper; takes the difference of the median from the mean:

diff <- function(frame, col, lower, upper)
{
	cleaned <- frame[,col][!is.na(frame[,col])]
	ordered_cleaned <- cleaned[order(cleaned)]

	bounded_cleaned <-
	if (lower > 0 && upper > 0) head(tail(ordered_cleaned, -lower), -upper)
	else if (lower > 0) tail(ordered_cleaned, -lower)
	else if (upper > 0) head(ordered_cleaned, -upper)
	else ordered_cleaned

	mean(bounded_cleaned)-median(bounded_cleaned)
}

#################################

# As lower is irrelevant, finds "zero" points for various upper diffs.

diff_zeroes <- function(frame, col)
{
	n <- nrow(frame)
	diff_plot <- rep(0, n)
	diff_plot[1] <- diff(frame, col, 0, 1)

	count <- -1
	range <- 2:n
	for (i in range)
	{
		diff_plot[i] <- diff(frame, col, 0, i)
		if (!is.na(diff_plot[i]) && ((diff_plot[i-1] >= 0 && diff_plot[i] < 0) || (diff_plot[i-1] <= 0 && diff_plot[i] > 0)))
			count <- count+1
	}

	clusters <- rep(0, count)

	pos <- 1
	for (i in range)
	{
		if (!is.na(diff_plot[i]) && ((diff_plot[i-1] >= 0 && diff_plot[i] < 0) || (diff_plot[i-1] <= 0 && diff_plot[i] > 0)))
		{
			clusters[pos] <- i-1
			pos <- pos+1
		}
	}
	
	clusters
}

#################################

# Pull the deviation and plot it.

plot_deviation <- function(analysis, meas, meas_name, frame, frame_name, col)
{
	meas_deviation <- pull_deviation(meas, frame, col)
	md_order <- order(meas_deviation)

	jpeg(paste(analysis, frame_name, meas_name, col, "Deviation.jpg"), width=768, height=768)

	par(mai=c(1,2,1,1))
	possessive <- paste(analysis, "'", sep="")
	barplot(meas_deviation[md_order], main=paste("FNFTA", possessive, frame_name, meas_name, col, "Deviation"),
		horiz=TRUE, names.arg=frame[md_order, "Name_of_Individual"], xlab="$ : Mean-Median", las=1, cex.names=0.05)

	dev.off()
}

#################################

# Takes the diff for the first i type (lower or upper) of frame[,col]; plots all such partials from 1:n.

plot_diff <- function(analysis, type, frame, frame_name, col, n)
{
	range <- 1:n
	diff_plot <- rep(0, n)
	if (type == "lower") for (i in range) diff_plot[i] <- diff(frame, col, i, 0)
	else for (i in range) diff_plot[i] <- diff(frame, col, 0, i)

	jpeg(paste(analysis, "Difference between", type, frame_name, col, "Mean and Median.jpg"), width=768, height=768)

	par(mai=c(1,2,1,1))
	possessive <- paste(analysis, "'", sep="")
	barplot(diff_plot, main=paste("FNFTA", possessive, "Difference between", type, frame_name, col, "Mean and Median"),
		horiz=TRUE, names.arg=range, xlab="$", ylab=paste("Less the bottom paid", analysis), las=1, cex.names=0.05)

	dev.off()
}

