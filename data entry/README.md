# Data Entry

This phase is broken down into four parts:

1. Downloading.
2. Image to text.
3. Entry.
4. Validation.

## Downloading:

As per the FNFTA, all nations were required to post their schedules of remuneration and expense reports here:

http://pse5-esd5.ainc-inac.gc.ca/fnp/Main/Search/SearchFF.aspx?lang=eng

The downloading subphase required getting these reports.

### Intuition:

Of all the parts, downloading was the easiest. The files were indexed by AANDC designation numbers as pdfs.
I wrote a script to automate the download process:

+ download

### Dependencies:

The script was written in bash (linux), and in particular made calls to the given non-builtin non-trivial utility:

+ wget (recursive downloader)

The pdfs themselves have not been (will not be) uploaded to GitHub directly, as it breaks the design and intentions
of this medium. Instead, I have uploaded the most up-to-date collection to my onedrive account and linked to it here (137MB):

https://onedrive.live.com/redir?resid=46D8BFF0C86B7646!209&authkey=!AFGVdli1JwYaWQY&ithint=file%2czip

I do not recommend cloud storage for anything confidential as the NSA and other Five Eyes intelligence agencies know
no privacy, but Microsoft's free 15GB is hard to pass up, and frankly perfect for this type of content.

### Limitations:

Notably, the piece of code which doesn't scale is the "end=800" line. I had no idea in advance how many nations
there were (it's actually difficult to navigate and find a reliable number on the government website and activists'
numbers always differ by how they interpret). I knew it was somewhere around 600, so to play it safe I originally
tried downloading from the range 1..1000. I refined this number from 1..800 later on, but strictly speaking it still
doesn't scale. Ideally, a piece of code which would scale would find that upper bound in an automatic way---like
a link on the website, which still has potential problems, but it's easier to debug a broken link down the road
than to debug an arbitrary integer.

The comment in the script mentioning the file size of 1988 or 2084 is problematic and not scalable for similar reasons.
For some reason (I haven't figured it out), every once in a while I'd run the download script and the pdfs which weren't
actually up it would still download as unreadable "empty" files. I quote the word 'empty' because their file sizes were
1988 and 2084 Bytes. My hack to getting rid of them.

### Recommendation:

Though overall it is fairly easy and reliable to download the FNFTA content, it is more difficult to maintain a scalable
script---one will need to maintain the code and check the assumptions periodically.

## Image to text:

This subphase took the downloaded pdfs and converted the pdf content into text file content.

### Intuition:

Unfortunately, for whatever reason, the government of Canada posted these reports as image scans, so a simple copy and paste
of the text was impractical. If you asked them, they would likely pass the blame to Chief and Council (as they are so accustomed
to doing), but to be fair---at the time of this project---it's not a big secret the federal government is behind the times on
open data best practices. Needless to say, this part of the data entry phase is the cause of much manual labour which could not
be avoided.

With that said, I still attempted to automate as much as I could. I split it up into three scripts:

+ digitize
+ manual\_digitize
+ manual\_extract

The main script was "digitize", where in particular I used some open source ocular character recognition (ocr) software generously
provided by Google to convert the scanned image pdf text into regular text. It happened sometimes a particular report didn't
digitize properly, and so with "manual\_digitize" I manually entered the designation number of the pdf report; the page of interest
within the pdf; and specified to rotate that pariticular page if needed (often, that was the cause of the first script failing
to digitize properly). Finally with "manual\_extract" I found there were reports which in fact were text based pdfs (copy
and paste did work), meaning the ocr was being applied to a non image file (and so would fail) and so instead of manually
copying and pasting, I actually converted these pdfs to an image based version and reapplied the "digitize" script to those.

### Dependencies:

+ convert (part of the ImageMagick toolset)
+ tesseract (Google's open source ocr)
+ pdftk (pdf toolkit)

### Limitations:

OCRs are machine learning based meaning they don't recognize a given character with 100% accuracy 100% of the time. Even with
all that did work properly, the text file that tesseract spit out was an unformatted jumble of raw text, meaning a lot
of manual cleaning was still required.

### Recommendation:

Only recently have I take an machine learning MOOC (the one offered by Andrew Ng on Coursera). I have the basics, but I am far
from polished, and only after the fact did I realize a best practice here would have been to normalize the pdfs first.

In particular, as an optimization, I recommend for anyone doing something similar, using these pdfs as example: First use
the idea in "manual\_digitize" to go through each pdf, pulling out only the relevant page, and *normalizing* it by using
the "convert" utility to map it from its non-standard (found in the wild) pdf format to the standard provided by the "convert"
utility. By standardizing the pdf specification and rotating the page(s) properly one will have normalized the
initial content. Finally, one can then "digitize" from a single normalized standard. There is some manual labour required,
but even this much can be reduced with simple scripts like the ones provided here.

## Entry:

This subphase consisted of taking the raw text provided by the previous subphase and organizing it into a structured
data entry text file.

### Intuition:

The hardest part here was in figuring out exactly how to organize and structure the data. My strategy was to take a small
sample and try different structures until I figured it out. The strategy that ended up making the most sense was to
structure the text for each pdf *report-as-entry* in such a way that there was as little redundancy as possible.

The reason for privileging the minimizing of redundancy was it would then require less manual effort on the part of a human
being. It's not a matter of laziness, but in fact of *error reduction* as well as health/sustainability of the labourer.
Data entry is repetitive, and so the longer a single person works at it, the more likely she is to make a mistake.
A nice Wired article discussing this being
["What’s Up With That: Why It’s So Hard to Catch Your Own Typos"](http://www.wired.com/2014/08/wuwt-typos/).

As well, one must consider things like repetitive strain injuries (RSI) and their preventative ergonomics---mimizing repetitive
work is part of the solution.

The raw text data though not large in size, is large in number, and given its relative unimportance I have zipped and stored it
here for those still interested (732KB):

https://onedrive.live.com/redir?resid=46D8BFF0C86B7646!210&authkey=!ABr\_wspxR0Enf6s&ithint=file%2czip

With the structuring figured out as a guide, and as an extension of the do-as-little-work-as-possible principle,
I wrote a small script to filter out the lines of raw text that would be of interest:

+ factorize

As such a task requires intricate filters, my script (and filters) were quite simple and limited still leaving some
additional manual labour on my part, but: Anything to save from just that much more repetitive labour is still quite beneficial.
The filtered lines were appended in the file:

+ filtered\_lines.txt

As for this filtered raw data, as with pretty much all the labour in this project, the cleaning up and structuring part was done
as a hybrid between human and machine, trying to make use of what each is able to do best. The machine side is made of the following:

+ cleanup.tmp0
+ cleanup.tmp1
+ cleanup.tmp2
+ cleanup.tmp3

working on the data:

+ data.tmp0
+ data.tmp1
+ data.tmp2
+ data.tmp3
+ data.tmp4

For an example of this, I took new lines of filtered data and saved them as data.tmp0. A few lines of this read as:

> 188 Wilfred King Chief 12 117 476 26 322
> 188 Louis Brizzard Councillor 12 - 240
>
> 317 Dettanikkeaze  Leo Chief 12 46 800 15 000 61 800

With "cleanup.tmp0" the designation number was moved to the top; and a generic header line was added in, saved as "data.tmp1":

> 188,
> Name\_of\_Individual,	Position\_Title,	Number\_of\_Months,	Remuneration,	Expenses
> Wilfred King Chief 12 117 476 26 322
> Louis Brizzard Councillor 12 - 240
>
> 317,
> Name\_of\_Individual,	Position\_Title,	Number\_of\_Months,	Remuneration,	Expenses
> Dettanikkeaze Leo Chief 12 46 800 15 000 61 800

I manually normalized Chief and Council names to be only first and last name, so for example if I found a "Hugh King Sr"
I changed it to "Hugh King\_Sr" (making for only one space character). Running the "cleanup.tmp1" replaces all space characters
within each name and ends the name with a comma. I manually tabbed the alignment of the following columns (for human visual readability).
Again, as each "Position\_Title" entry was usually a single word, I manually replaced spaces with underscores within such strings.

If you'll notice, the pattern is generally: run script; normalize; run script; normalize; run script. As for the human manual normalization,
even that I reduced human labour by using a high end well designed text editor (my own preference and choice is Vim).

Running "cleanup.tmp2" adds a comma after the Position\_Title entries as well as the Number\_of\_Months entries. Spacing alignment
(tabbing) is further corrected for human readability within the Number\_of\_Months columns. I fogot to mention, a bit of character
normalization has also occurred by now: Dash characters '-' are replaced with '0', and similar such things (the details are in the
scripts of course). Finally, before running the last cleanup script ("cleanup.tmp3") I manually remove spaces between financial
numbers---numbers which are all one number (117 476 becomes 117476 for example).

With the final "data.tmp4" I copy that into the data\_structure.csv data entry file.

### Dependencies:

+ mawk (version of awk text editing programming language)
+ Vim\* (text editor; \*any equivalent text editor obviously suffices [no "which editor is better" wars here please])

### Limitations:

The factorize script I used for filtering was based off of manually looking through the raw text files first for patterns
for which the lines of interest had and which all other lines did not have. I used a simple regular expression approach
to match lines which had three or more consecutive numbers. When found, I copied those lines after removing dollar signs
'$', periods '.', and commas ','.

This particular simple script, as noted above, was a course and crude filter actually allowing many other lines---not of
interest---through. As well, there was no fully automated restructuring to save effort on part of the human labourer(s).

### Recommendation:

My recommendation for this particular phase is to use more elaborate machine learning algorithms. Especially now---after the
fact---that there is structured data, it would be easy to come up with a training set. This was impossible the first time around
as I didn't know what to expect overall, and so I didn't know what patterns to match against and thus what style of machine learning
algorithms to apply. With a polished dataset, I now have access to Chief and Council first and last names: Though such things do
change over the years, similar names tend to stay within communities, and so first and last names seperate of each other make
for a good way to recognize lines of interest. A basic logistic regression training model should such suffice. There's 582 reports,
and a good 5-10 lines within the reports of interest, making about 2500-5000 training examples. That's still pretty small data,
but it shouldn't be hard to tweak features to get pretty good accuracy given the context. It is something I plan on trying out
myself in the future (a few months from writing this as I need a break)---I have stated this project makes for a good practice
resource if nothing else (though I'm hoping the statistical analysis really will be of use to as evidence to deconstruct colonial
myths), and this phase demonstrates what other varieties of technical practice it provides and potentially provides. Most importantly,
for me at least, it is not artificial---and does not *feel* artificial in terms of my motivation to work on it.

## Validation:

This subphase required manually validating the content of the data\_structure.csv file making sure it was accurate with respect to the
pdfs.

### Intuition:

Basically, I looked through each text entry and comparing it with the names and numbers of the pdfs, correcting any mistakes I found.
It's pretty self-explanatory, otherwise the only other thing worth noting is the specification I made for myself to adhere to as
I entered the data, as for as much as I attempted to maintain as faithful a reading/writing as possible, I did have to make a few
editor choices:

1. The first line of each modular entry is tagged as follows:

+ &lt;Band Designation Number&gt;,	&lt;First Nation Name&gt;,	&lt;Accounting Firm Name&gt;,	[\*]
+ The optional star means I interpreted (changed) to fit these specifications, in a a way I considered justified.
+ A double star [\*\*] indicates I took the 2014 year instead of the 2013 year in the report (a few reports had both).
+ A triple star [\*\*\*] indicates there are extra special circumstances regarding the report itself, and it's worth flagging.
+ The remainder of the given entry has a row of header tags pulled directly from the remuneration statements. As such it becomes
+ easier to do a semiotic analysis as well as translate/factorize into simpler tables at the user's discretion.

2. If I lacked a proper name, I used "NA" as the given entry.
3. Spaces ' ' within single entries are replaced by underscore '\_'.
4. I did not (intentionally) change any spellings, though I did change all uppercase words to lowercase (except the initial letter).
5. For unspecified &lt;Name&gt; headers I defaulted to "Name\_NA"; for &lt;Title&gt; headers I defaulted to "Title\_NA";
for &lt;Months&gt; "Months\_NA", etc.
6. A comma ',' as content (not part of the csv meta structure) is represented by a double underscore "\_\_".

### Dependencies:

+ Vim\* (text editor; \*any equivalent text editor obviously suffices [no "which editor is better" wars here please])
+ Evince (pdf viewer)

### Limitations:

Notably the main limitation is the OCR as it does not read text 100% correctly 100% of the time, which is why humans have to go
through and look for typos in the first place. Aside from that, the main other limitation is human stamina; human concentration,
having to stare at a computer screen for hours on end with all the psychological limitations that come with that.

Hopefully it doesn't need to be said, but for those doing the manual entry, train them to: take breaks periodically; do light
stretching; go for short walks, etc.

### Recommendation:

This subphase has the strongest human component. One could divide and conquer this subphase to several or many people, but that comes
with its own issues to consider (cost, standardization of expectations [minor education], etc).

The other recommendation is something I learned from all that practical experience: The letters '6' and '8' (especially '8') were more
often than anything else read incorrectly by the ocr (all other things being equal). I recommend before committing to a given ocr,
find or make a reliable profile of what it's known to often get wrong, as it would be a good *heads up* for those having
to manually search for such typos.

## Conclusion:

I have made recommendations in the above, but they were regarding improvements and optimizations to the workflow of those subphases.
Though important, I here intend to make *meta-recommendations*:

### Meta Recommendations:

The data entry phase is no small task, and not to be taken for granted. Ideally open data published by governments would be
standardized; easily accessible; easily translatable; thus freeing up the time of its citizens to provide value where their
input is most needed and desired: As *critical citizens*. An example of this is actually given by a recent
[TEDtalk](http://www.ted.com/talks/ben\_wellington\_how\_we\_found\_the\_worst\_place\_to\_park\_in\_new\_york\_city\_using\_big\_data).

If you are a government reading this: Chief and Council (3rd pillar); Federal; Provincial; Municipal, I recommend (in the good
company of the many who I stand on the shoulders of) the standardization of policy and normalization of open data for citizen
purposes. Please no pdfs.

