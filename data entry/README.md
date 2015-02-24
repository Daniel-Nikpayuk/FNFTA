# Data Entry

This phase is broken down into four parts:

1) Downloading.

2) Image to text.

3) Entry.

4) Validation.

## Downloading:

As per the FNFTA, all nations were required to post their schedules of remuneration and expense reports here:

http://pse5-esd5.ainc-inac.gc.ca/fnp/Main/Search/SearchFF.aspx?lang=eng

The downloading subphase required getting these reports.

### Intuition:

Of all the parts, downloading was the easiest. The files were indexed by AANDC designation numbers as pdfs.
I wrote a script to automate the download process:

"download"

### Dependencies:

The script was written in bash (linux), and in particular made calls to the given non-builtin non-trivial utility:

wget (recursive downloader)

The pdfs themselves have not been (will not be) uploaded to GitHub directly, as it breaks the design and intentions
of this medium. Instead, I have uploaded the most up-to-date collection to my onedrive account and linked to it here:

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

digitize
manual\_digitize
manual\_extract

The main script was "digitize", where in particular I used some open source ocular character recognition (ocr) software generously
provided by Google to convert the scanned image pdf text into regular text. It happened sometimes a particular report didn't
digitize properly, and so with "manual\_digitize" I manually entered the designation number of the pdf report; the page of interest
within the pdf; and specified to rotate that pariticular page if needed (often, that was the cause of the first script failing
to digitize properly). Finally with "manual\_extract" I found there were reports which in fact were text based pdfs (copy
and paste did work), meaning the ocr was being applied to a non image file (and so would fail) and so instead of manually
copying and pasting, I actually converted these pdfs to an image based version and reapplied the "digitize" script to those.

### Dependencies:

convert (part of the ImageMagick toolset)
tesseract (Google's open source ocr)
pdftk (pdf toolkit)

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
structure the text for each pdf report as *entry* in such a way that there was as little redundancy as possible.

The reason for privileging the minimizing of redundancy was it would then require less manual effort on the part of a human
being. It's not a matter of laziness, but in fact of *error reduction* as well as health/sustainability. Data entry is
repetitive, and so the longer a single person works at it, the more likely she is to make a mistake. A nice Wired article
discussing this being "What’s Up With That: Why It’s So Hard to Catch Your Own Typos":

http://www.wired.com/2014/08/wuwt-typos/

As well, one must consider things like repetitive strain injuries (RSI) and ergonomics---mimizing repetitive work is part
of the solution.

As an extension of this, I wrote some small scripts to filter out the lines of raw text that would be of interest. As such
a task requires intricate filters, my scripts (and filters) were quite simple and limited still leaving some additional
manual labour on my part, but: Anything to save from just that much more repetitive labour is still quite beneficial.

### Dependencies:
### Limitations:
### Recommendation:

## Validation:

### Intuition:
### Dependencies:
### Limitations:
### Recommendation:

## Conclusion:

