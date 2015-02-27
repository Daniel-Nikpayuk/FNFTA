# Translation

This phase is broken down into four main parts:

1) Validation.

2) Semiotic Analysis.

3) Normalization.

4) Consolidation (factorization).

## Validation:

This part consists of validating the structural specification of the data entry csv file:

data\_structure.csv

#### Intuition:

Before any structural analysis or translation can begin, we have to check our assumptions:
Whatever scripts we write to translate the data entry text file into a well formatted csv file
requires assuming certain characteristics about the data entry file, and so we must verify those first.

In particular, I had two varieties of scripts, a "differator" (I make up words that I probably shouldn't all the time),
and several validators, all within the "diagnostics" folder:

diagnostics/differators:

report\_differator

Here I simply compared the existing pdf files with the entry designation numbers in the data entry csv file to see if
I was missing anything. As the FNFTA pdfs are slowly released one by one over time on the government website, I would
need a reminder of what had changed whenever I returned to the project.

diagnostics/validators:

space\_validator
entry\_line\_validator
first\_line\_validator
comma\_dimension\_validator
unique\_entries\_validator
count\_validator

All the validators read in the data entry csv file. The "space" validator simply made sure each entry was seperated by no more
than one empty line. The "entry line" validator looked at each entry line and made sure it conformed to a regular structure,
notably that each entry ended with a comma (except the final entry of the line) and that each entry was seperated by one or more
tabs (no other whitespace was allowed). Next, the "first line" of an entry being a little different, was additionally independently
validated. The "comma dimension" validator made sure that the number of commas (and thus entry lines of a single entry) matched.
If they didn't match (not including the first line), it would be an indicator of an entry error. The "unique entries" validator
made sure I didn't enter the same data more than once, or rather I didn't mistakenly assign two different entries with the same
designation number. Finally, the "count" validator gave the total count of current entries (to compare with the number of pdf reports)
to make sure I wasn't missing anything. It's a bit redundant with the differator script, but it doesn't hurt to be thorough.

#### Dependencies:

mawk (version of awk text editing programming language)
sort (commandline string sorter)
diff (compares two files to show where they differ)

#### Limitations:

Script bugs, or just plain wrong coding.

#### Recommendation:

A code audit. The greater number of eyes viewing the code, the more likely it is to find and patch bugs or see code that has no
bugs but doesn't actually do what it's intended. Or even a case where there's just a better way to write the code.

## Semiotic Analysis:

This part consists of analyzing the semiotic space of the header content. It itself is actually broken into two main, parts:

a) Bound header analysis.

b) All header analysis.

Conceptually, one has a list of headers for each pdf-report-as-entry, and that list of headers which belong together are
referred to as *bound headers*. On the other hand, each individual header regardless of which entry it belongs is the collection
of *all headers*.

Though broken into parts, the main intuition for a semitioc analysis is that the *headerspace* for the various pdf entries are not
normalized.  Different Nations use different headers, which makes unifying all Nations' data into a single well-formed csv table
problematic. The semiotic analysis looks at the natural orders within the existing headerspace as way forward to solving this
normalization process.

### Bound header analysis:

Here I compare bound headers looking for patterns with which to orient a standardized header subspace---allowing for a end goal
in translating the remaining headers and thus normalizing them.

#### Intuition:

Though far from a thorough/proper solution, one relatively simple approach is to look at the distribution of each list of bound
headers. I have written two simple scripts for this purpose:

pull\_bound\_headers
csv\_bound\_headers

The first, "pull\_bound\_headers" pulls the bound headers from the data entry file, sorts them, and removes duplicates. The
resulting file is informal in the analysis, as no scripts directly depend on it later on, but it is useful to scan, skim,
and gauge the bound header space before moving on---to get an intuitive feel for it, so that the human might pick up something
useful or find an error the machine would not predict.

The second, "csv\_bound\_headers" pulls the bound header list as well, but here it counts them and stores this in a temporary file.
It then calls:

source.r

and creates a jpg image of the distribution. With the current version of the data table, the following graphic is the result:

![bound headers](semiotics/bound_headers/bound_headers.jpg)

As you can see, the actual header text is too small to read, but the graphic gives a good visual showing that one bound header list
stands out far more than all the others and is easily the candidate for translating the header space. The R script "source.r" also
provides the actual details as well:

tail(t[ordered,])
Expenses, Name, Number\_of\_Months, Position, Remuneration					10
Expenses, Name, Number\_of\_Months, Position\_Title, Remuneration				10
Expenses, Name\_of\_Individual, Number\_of\_Months, Position, Remuneration			11
Expenses, Name\_NA, Number\_of\_Months, Remuneration, Title\_NA					15
Expenses\_NA, Months\_NA, Name\_NA, Remuneration\_NA, Title\_NA					23
Expenses, Name\_of\_Individual, Number\_of\_Months, Position\_Title, Remuneration		156

Notably, and I observed this intuitively myself manually entering the data, but the follower headerspace with 156 pdfs matching
it is the clear winner:

Name\_of\_Individual, Position\_Title, Number\_of\_Months, Remuneration, Expenses

#### Dependencies:

mawk (version of awk text editing programming language)
sort (commandline string sorter)
R (statistically oriented programming language; well suited for statistical graphics)
convert (part of the ImageMagick toolset)

#### Limitations:
#### Recommendation:

### All header analysis:

#### Intuition:
#### Dependencies:
#### Limitations:
#### Recommendation:

## Normalization:

###

#### Intuition:
#### Dependencies:
#### Limitations:
#### Recommendation:

## Consolidation (factorization):

###

#### Intuition:
#### Dependencies:
#### Limitations:
#### Recommendation:

## Conclusion:

I chose to create a seperate "translation" phase even though it greatly extended the workload as part of the modular design
of the entire project. Even now, knowing this, I have no regrets and feel it is a best practice.

The first reason being transparency.

Secondly is life-span and reusability.
