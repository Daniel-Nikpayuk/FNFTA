# Translation

This phase is broken down into four main parts:

1. Validation.
2. Semiotic Analysis.
3. Normalization.
4. Consolidation (factorization).

## Validation:

This part consists of validating the structural specification of the data entry csv file:

+ data\_structure.csv

#### Intuition:

Before any structural analysis or translation can begin, we have to check our assumptions:
Whatever scripts we write to translate the data entry text file into a well formatted csv file
requires assuming certain characteristics about the data entry file, and so we must verify those first.

In particular, I had two varieties of scripts, a "differator" (I make up words that I probably shouldn't all the time),
and several validators, all within the "diagnostics" folder:

diagnostics/differators:

+ report\_differator

Here I simply compared the existing pdf files with the entry designation numbers in the data entry csv file to see if
I was missing anything. As the FNFTA pdfs are slowly released one by one over time on the government website, I would
need a reminder of what had changed whenever I returned to the project.

diagnostics/validators:

+ space\_validator
+ entry\_line\_validator
+ first\_line\_validator
+ comma\_dimension\_validator
+ unique\_entries\_validator
+ count\_validator

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

+ mawk (version of awk text editing programming language)
+ sort (commandline string sorter)
+ diff (compares two files to show where they differ)

#### Limitations:

Script bugs, or just plain wrong coding.

#### Recommendation:

A code audit. The greater number of eyes viewing the code, the more likely it is to find and patch bugs or see code that has no
bugs but doesn't actually do what it's intended. Or even a case where there's just a better way to write the code.

## Semiotic Analysis:

This part consists of analyzing the semiotic space of the header content. It itself is actually broken into two main, parts:

1. Bound header analysis.
2. All header analysis.

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

+ pull\_bound\_headers
+ csv\_bound\_headers

The first, "pull\_bound\_headers" pulls the bound headers from the data entry file, sorts them, and removes duplicates. The
resulting file is informal in the analysis, as no scripts directly depend on it later on, but it is useful to scan, skim,
and gauge the bound header space before moving on---to get an intuitive feel for it, so that the human might pick up something
useful or find an error the machine would not predict.

The second, "csv\_bound\_headers" pulls the bound header list as well, but here it counts them and stores this in a temporary file.
It then calls:

+ source.r

and creates a jpg image of the distribution. With the current version of the data table, the following graphic is the result:

![bound headers](semiotics/bound_headers/bound_headers.jpg)

As you can see, the actual header text is too small to read, but the graphic gives a good visual showing that one bound header list
stands out far more than all the others and is easily the candidate for translating the header space. The R script "source.r" also
provides the actual details as well:

	tail(t[ordered,])
	Expenses, Name, Number_of_Months, Position, Remuneration				 10
	Expenses, Name, Number_of_Months, Position_Title, Remuneration                           10
	Expenses, Name_of_Individual, Number_of_Months, Position, Remuneration                   11
	Expenses, Name_NA, Number_of_Months, Remuneration, Title_NA                              15
	Expenses_NA, Months_NA, Name_NA, Remuneration_NA, Title_NA                               23
	Expenses, Name_of_Individual, Number_of_Months, Position_Title, Remuneration             156

Notably, and I observed this intuitively myself manually entering the data, but the follower headerspace with 156 pdfs matching
it is the clear winner (in its natural order within the pdf reports):

	Name_of_Individual, Position_Title, Number_of_Months, Remuneration, Expenses

#### Dependencies:

+ mawk (version of awk text editing programming language)
+ sort (commandline string sorter)
+ R (statistically oriented programming language; well suited for statistical graphics)
+ convert (part of the ImageMagick toolset)

#### Limitations:

As always, code verification (bug finding, semantic validation). More notably, the exact nature of this analysis, the distribution
is the biggest limit here. It does not provide a universal solution regarding general contexts. It just happens the well behaved
nature of this given context allows for this simple heuristic approach of distribution analysis to pass.

In the broader solution, one would actually need to look at the branches of math called *partition theory* and *lattice theory*.
Such analyses would look at every possible header subspace and the non-linearly ordered lattice of *chains* to determine
maximal/optimal solutions. In this general case a unique solution is out of the question, and choosing from the collection of
maximal solutions is a matter of the politics of interpretation.

Finally it's worth noting with the full out partition theory analysis, looking only at the combinatorics of it, it is easy to see
the computational power required for exact solutions is in fact impractical.  Think of it this way: The headerspace we've decided
upon above is just one possible subset of the whole and existing headspace.  Once chosen, such a subset is now a constraint upon
which to partition the remainder of the headerspace (the chosen subset's compliment); each header would be assigned one of the
representative groups defined by the chosen subset. How many such combinations are there? A lot. The number of ways to partition
a set grows exponentially (greater than actually) and for each given partition, the number of ways to partition the remainder into
'k' subsets is family of numbers called the Stirling numbers of the second kind, and they grow pretty much just as rapidly as well.
Once could simplify a little by constraining (filtering) combinations by chains as well as by known linguistic constraints of a given
language, but there's no consistent approach there for general contexts and the numbers we're looking at are still ridiculously large:
Many given constraints would still leave far too many solutions to for a human to manually look through. At the end of the
day, heuristic solutions would still be required.

#### Recommendation:

The landscape of the strategy space for analyzing semiotics spaces is outlined in the above limitations. As a heuristic approach
regardless of style is generally required, I would recommend not taking this subphase lightly.

Beyond that, when one looks at the actual scripts written, there is much room for optimizations---especially factorizations of
code. This is expected as most code presented here is more prototypical in nature, and this exact recommendation will be given
repetitiously throughout.

### All header analysis:

Here I perform a relatively simple cluster analysis of the individual headers, grouping them together by semantic equivalence.

#### Intuition:

With the headerspace decided upon in the bound header analysis, we know what headers we want all the others to translate to.
The simplest strategy would be to go over the list of all headers, and decide which one from our *terminal* headerspace the given
*initial* header would translate as. What's more, in preparation for a unified csv table with all existing headers, we need to define
defaults as none of the pdf reports will contain all existing headers---if a report provides no values for a given header, we will
need to know to default it as '0' or as 'NA' depending on the type of content that header represents.

Any given analysis and preparation is inevitably doing these, but again going back to the philosophy of do-as-little-work-as-possible
the main goal of this part of the analysis is to reduce human manual labour. This particular analysis has many parts in fact,
so I will break down and explain:

The first part within the "all\_headers" folder is the script:

+ pull\_all\_headers

which pulls all headers (unbound) and stores them with repetition in the "word\_count\_R" folder:

+ all\_headers.log
+ csv\_word\_count
+ source.r
+ word\_count.jpg
+ ordered\_words.log

Here we invoke the "csv\_word\_count" script which counts the number of each header, calls "source.r" and produces the "word\_count.jpg":

![word count](semiotics/all_headers/word_count_R/word_count.jpg)

as well as the "ordered\_words.log" file. Though a minor detour from the main effort, these "ordered words" are useful in the following.
With that said, the "pull\_all\_headers" script also pulls all headers, sorts and stores them uniquely in the "decompose\_headers" folder:

+ unique\_headers.log
+ gauge
+ partition
+ headers.log
+ create\_clusters
+ ordered\_words-15-02-16-0310.log
+ clusters
+ pull\_map
+ pulled\_map.log
+ folded\_map-15-02-16-0310.log
+ pull\_defaults
+ pulled\_defaults.log
+ folded\_default-15-02-16-0310.log
+ unfold\_maps
+ factor\_map.log
+ default\_map.log

The file "unique\_headers.log" contains all headers without any repetition as the starting point.
It is tested with the "gauge" script which not only sifts out words considered *similar* to the input word,
it does it for a range (from 50%-100% similarity [based on the metric]) returning the words sifted.

One manually looks at which percentage as input is preferred: This is necessary as the metric for similarity is syntactic
in measure, not semantic---it will pull syntactically similar words, which as a strategy still saves a lot of time and effort,
but does require some manual effort in choosing which percentage to go by (so as to maximize sifting words of interest but not
sifting semantically unrelated words). If you're familar with machine learning, it's at least intuitively similar to determing
the learning rate, to repeat: It gauges the number of words sifted returning both the words and the numbers; it does this for
a range of parameters from 50%-100%. One then goes through those filters and chooses which one by percent.

Using this information we destructively "partition" the "headers.log" file keeping unrelated words within "headers.log" and moving
related words into the "clusters" directory within their own file.  The choices made in specifying partition have been stored as
a script in "create\_clusters" for transparency. As well, in order to help determine which words to gauge, "ordered\_words.log"
(with a timestampe indicating it may change in the future) is provided as reference. The "clusters" directory grows each time
while "headers.log" shrinks in terms of effect.

The script "pull\_map" creates "pulled\_map.log" which takes the remaining words in "headers.log" and adds back
the "class representatives" (implemented as the filenames) within the "clusters" directory.
At this point pulled\_map.log is manually edited to define the core mapping and is saved under the name: "folded\_map.log"
(with a timestamp indicating here it was manually edited).

+ Note: some of the terminal headers within "folded\_map.log" end in an asterisk '\*' meaning there wasn't absolute certainty
on my part that the interpretation of what should be mapped was correct. Keep in mind any code which interacts with this record
ignores these asterisks---it's more of a comment for transparency.

At this point, we're ready to prepare the defaults. The best way to reduce workload on this and to automate it is to realize
that we will take a given header and translate it into the terminal headerspace---which has only five headers---and to manually
determine the defaults for those five. All initial headers, to determine their defaults, simply check which terminal header
they map to and what default is associated with that: It'll be the same. As such, we pull the terminal headers with "pull\_defaults"
and save them as "pulled\_defaults". This file is manually edited and saved as "folded\_defaults.log" (with a timestamp indicating
here it was manually edited).

The script "unfold\_maps" automates the process of reexpanding the folded maps into their respective
"factor\_map.log" and "default\_map.log". These respective files "factor\_map.log" and "default\_map.log" are what we're interesting
in transferring to the next subphase of our larger analysis.

#### Dependencies:

+ mawk (version of awk text editing programming language)
+ sort (commandline string sorter)
+ R (statistically oriented programming language; well suited for statistical graphics)
+ convert (part of the ImageMagick toolset)
+ longest\_positional\_match (word comparison metric)

#### Limitations:

Code verification in this stage is probably the heaviest. Ancient programs such as "mawk" and even "R" have been thoroughly debugged,
so there's no issue there, but the scripts I wrote should still be semantically verified. What's more, the "longest positional match"
code I used I crafted myself. I have recently started my own personal [C++ template code library](https://github.com/Daniel-Nikpayuk/nik),
which will be gradually expanded, extended, and improved upon, but it is likely the weakest link in any chain of error that exists
within this subphase.

Beyond this, there is an interoperability issue. There are many different languages of code working together, and so code maintainence
is a bit more of an issue, not to mention modularization issues.

Other than that, the manual human mapping choices. The strength of this style is they are documented for transparency
and can be held up to scrutiny, but it's also important to verify they mappings were done as intended.

#### Recommendation:

Factorization of code. As there are several different languages, it would be preferred to reduce this. In the long run I myself intend
to further my C++ template library and rewrite much or most of the needed code in this single language---within reason of course,
I don't know if I'll have the time to be able to tackle a graphics library to produce quality statistical graphics the way R does,
for example.

## Normalization:

In this subphase we create a unified csv file by translating the raw data entry file and normalizing the headerspace.

#### Intuition:

Though the idea has been explained previously, I will again explain here: The data entry table will be translated so
each report entry will match up in using all existing headers (from it and every other pdf report). As such, each
entry will have excess headers, which will default to a predetermined default value. At the end of this
*least common multiple* translation of structure, we will have a raw and unified comma seperated value text file.

This is accomplished with the files in the "translate\_table" folder:

+ data\_structure-entry-15-03-03-0008.csv
+ default\_map.log
+ translate\_table.h
+ main.cpp
+ COPYING

The "data\_structure-entry[...].csv" file is carried over from the data entry phase. The "default\_map.log" file is
carried over from the previous subphase. What's new are the "translate\_table.h" and "main.cpp" C++ files. When compiled
for the command line, this binary takes the following grammatical form:

+ translate\_table \[INPUT FILE\] \[OUTPUT FILE\] \[DEFAULT MAP FILE\]

the "data\_structure-entry[...].csv" file specified as the input file, a "data\_structure-raw[...].csv" file specified
as the output file, and the "default\_map.log" specified as the default map file. Note here that the output file with
all its redundancy (and default values) ends up being about 4.9MB. As such I have not included a copy of it in the
"translate\_table" folder as there will be a copy in a folder mentioned in the next subphase.

I'm not going to detail the C++ code here as I intend to fold it properly into my personal "nik" library. I intend to
create a "filer" class somewhat similar to the *awk* programming language. Why reinvent the wheel? Because sometimes
one needs to do some heavy text processing in which awk is missing one or two key components. At that point it's necesary
to break away with one's own code. Though that is neither here nor there regarding this project.

1. Personal note: The C++ code was hacked together in a hurry, as I didn't want to spend another month of my weekends to
properly clean up the design. It's ugly code, and not representative of my abilities, but it's functional---it got the
job done for this project.

Finally is the "COPYING" file which is the standard GNU open source license.

#### Dependencies:

g++ (part of the open source GNU compiler collection)
nik (part of my personal C++ template library)

#### Limitations:

As always: Code semantic verification; finding bugs. This is especially true as the code is custom crafted from my library
which is in its early stages. It is also hosted here on my GitHub account:

https://github.com/Daniel-Nikpayuk/nik

Next would be interoperability again: In this case, if you do bother to read the C++ code, you might wonder why I've resorted
data which was already sorted. I found this out the hard way, but the sort binary used on the linux commandline sorts the
"comment" character '#' differently: possibly because bash reads it as a comment and ignores that character? I don't know.
As such, I could not rely on an outside sorter and used my own. This is a good example of modularity and interoperability of
code.

#### Recommendation:

Factorization of code. The greater the dependency on frameworks made without regard to each other increases the likelihood
of interoperability issues. The biggest issue is when developers and api coders largely consider modularity of design,
but overlook the subtle semantic bugs like the sorting one mentioned above. In such cases you have the illusion of
interoperability making such bugs that much more difficult to find. Sticking to as few frameworks as possible potentially
reduces this---with the tradeoff of course of greatly increasing development time unfortunately.

## Consolidation (factorization):

#### Intuition:

For as much automation as there was in this section, it was also heavily human oriented. There are four notable parts
with the "map\_table" folder:

+ restructure\_map
+ verify\_map
+ clean\_raw
+ consolidate

### Restructuring the factor map for user-friendly human verification:

Within the "map\_table/restructure\_map" subfolder:

+ map\_table.h
+ main.cpp
+ data\_structure-entry-15-03-03-0008.csv
+ factor\_map.log
+ factor\_map.csv
+ COPYING

### Verifying the factor map:

"map\_table/verify\_map":

+ factor\_map-15-03-03-0210.csv
+ pull\_terminal\_headers
+ terminal\_headers.log
+ make\_header\_map

### Cleaning and converting the raw data table:

"map\_table/clean\_raw":

+ default\_map.log
+ data\_structure-raw-15-03-03-0009.csv
+ pull\_bad\_cols.r
+ pull\_bad\_cols
+ bad\_cols.log
+ clean\_raw.r

### Consolidating the cleaned raw data table:

"map\_table/consolidate":

+ data\_structure-header\_map.log
+ data\_structure-cleaned\_raw-15-03-03-0315.csv
+ source.r

#### Dependencies:
#### Limitations:

numbers in parentheses "(160)" for example seems to be a convention of subtraction,
but I likely removed (inconsistently) from the original data entry table---problem.

"Other" is problematic and will likely skew the final results a little.

Generic Remunerations don't distinguish council and non-council varieties, so the results are skewed anyway.

#### Recommendation:

## Conclusion:

I chose to create a seperate "translation" phase even though it greatly extended the workload as part of the modular design
of the entire project. Even now, knowing this, I have no regrets and feel it is a best practice.

The first reason being transparency.

Secondly is life-span and reusability.

The more I look at how much non-council financial information is required to be posted, the more I think the intent
is for the feds to use this information to size up their opponent: Legal battle with a First Nation? Legal and political
strategy is determined by knowing how much infrastructure and resources they have; what connections (networks, social support)
they have to obtain additional funding for their legal battles, etc.

Like the NSA "it's just metadata" argument, you can determine a surprising amount with even this "meta" information
(and it's not even that meta).

