
source("../generic-analysis/generic.r")

restricted <- read("data_structure-restricted-chiefs.csv")
prorated <- read("data_structure-prorated-chiefs.csv")
adjusted <- read("data_structure-adjusted-chiefs.csv")

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
		c(
			"number of:",
			length(unique(frame$Number)),
			c_col(frame, "Remuneration", r),
			"",
			c_col(frame, "Expenses", e),
			""
		)
	}

	write.table(
	c(
		"restricted:",
		c_frame(restricted, 29, 338),
		"",
		"prorated:",
		c_frame(prorated, 42, 512),
		"",
		"adjusted:",
		c_frame(adjusted, 37, 416)
	),
	"stats.log", quote=FALSE, sep=", ", row.names=FALSE, col.names=FALSE)
}

plot_stats <- function()
{
	plot_col <- function(frame, frame_name, col)
	{
		plot_deviation("Chiefs", median, "Median", frame, frame_name, col)
		plot_deviation("Chiefs", mean, "Mean", frame, frame_name, col)
		plot_diff("Chiefs", "lower", frame, frame_name, col, nrow(frame))
		plot_diff("Chiefs", "upper", frame, frame_name, col, nrow(frame))
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

