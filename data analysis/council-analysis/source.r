
source("../generic-analysis/generic.r")

restricted <- read("data_structure-restricted-council.csv")
prorated <- read("data_structure-prorated-council.csv")
adjusted <- read("data_structure-adjusted-council.csv")

write_stats <- function()
{
	c_meas <- function(meas, meas_name, frame, col, n)
	{
		c(
			paste(meas_name, ":", sep=""),
			meas(frame[,col], na.rm=TRUE),
			"tail:",
			apply_by_tail(meas, frame, col, n)
		)
	}

	c_col <- function(frame, col, n)
	{
		c(
			paste(col, ":", sep=""),
			c_meas(median, "Median", frame, col, n),
			c_meas(mean, "Mean", frame, col, n),
			"diff:",
			diff(frame, col, 0, n),
			"zeroes:",
			diff_zeroes(frame, col)
		)
	}

	c_frame <- function(frame, r, e)
	{
		on_record <- length(unique(frame$Number))
		c(
			"number of:",
			on_record,
			"average size:",
			nrow(frame)/on_record,
			c_col(frame, "Remuneration", r),
			"",
			c_col(frame, "Expenses", e),
			""
		)
	}

	write.table(
	c(
		"restricted:",
		c_frame(restricted, 55, 2233),
		"",
		"prorated:",
		c_frame(prorated, 132, 2986),
		"",
		"adjusted:",
		c_frame(adjusted, 78, 2704)
	),
	"stats.log", quote=FALSE, sep=", ", row.names=FALSE, col.names=FALSE)
}

plot_stats <- function()
{
	plot_col <- function(frame, frame_name, col)
	{
		plot_deviation("Councils", median, "Median", frame, frame_name, col)
		plot_deviation("Councils", mean, "Mean", frame, frame_name, col)
		plot_diff("Councils", "lower", frame, frame_name, col, nrow(frame))
		plot_diff("Councils", "upper", frame, frame_name, col, nrow(frame))
	}

	plot_frame <- function(frame, frame_name)
	{
		plot_col(frame, frame_name, "Remuneration")
		plot_col(frame, frame_name, "Expenses")
	}

	plot_frame(restricted, "Restricted")
	plot_frame(prorated, "Prorated")
	plot_frame(adjusted, "Adjusted")
}

write_stats()
plot_stats()

