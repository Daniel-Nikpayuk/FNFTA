FNFTA
=====

This is an independent analysis of the First Nations Financial Transparency Act (FNFTA) dataset.

## Abstract:

The [FNFTA](http://www.aadnc-aandc.gc.ca/eng/1322056355024/1322060287419?utm\_source=transparency&utm\_medium=url)
was passed into law March 27, 2013, requiring all 582 AANDC designated Nations to publish the *schedule of remuneration and expenses*
as well as *audited consolidated financial statements* reports for their Chief and Council to the
federal government of Canada's online website.

This independent analysis of the FNFTA is broken into three parts:

1. It takes the schedule of remuneration and expenses reports posted online and unifies them into several relevant
comma seperated value (csv) open dataset files.
2. It performs a semiotic analysis on the wordspace given by the filtered csv files.
3. It performs a statistical analysis on the financial and other relevant data oriented around median and mean
earnings of Chief and Council amongst the given Nations.

## How to read this analysis:

The workload was modularized into the following parts:

1. Data entry phase.
2. Translation phase.
3. Data analysis phase.

The source code/documentation is organized along this division as well. Within each of the appropriately named folders
you will find another "README.md" providing the relevant details of that phase. To an extent, due to the modular
nature, each part can be read independently of the others. Thus, for example if you're interested only in the
Chief's median salary, you can skip straight to the data analysis phase.

Within these modularized "README.md" files, I have also posted project recommendations and conclusions. The recommendations
largely are "optimizations" in regards to that particular phase (how to improve efficiency, etc.), but in the data analysis
phase you will find the first sections to provide recommendations of a more sociopolitical nature. The conclusions on
the other hand (for now) are somewhat less formal, and simply provide a personal summary of my thoughts.

## Motivation:

I here give full disclosure (political and other) so there is no confusion about misrepresentation and motivation.

### Political:

I am Inuvialuit, and although the FNFTA does **not** effect me or my people directly in any way, I am part of the indigenous
activist community who seek equal and fair relationships with Canadian settlers and the Canadian government.
*I support* the [UN Declaration on the Rights of Indigenous Peoples](http://www.un.org/esa/socdev/unpfii/documents/DRIPS\_en.pdf)
including the right to self-determination. As such, with the privileges in life I have been given, and as a form of
reciprocity to those of Treaty 6 territory (the terrority in which I reside and benefit---as an outsider) I aim
to help in the education and deconstruction of harmful colonial myths, social constructs, stereotypes. If you need
a well written rundown of such myths, the Chelsea Vowel's blogsite is an an excellent resource:

http://apihtawikosisan.com

especially relevant is the post: [Canada, it’s time. We need to fix this in our generation.](http://apihtawikosisan.com/2012/12/canada-its-time-we-need-to-fix-this-in-our-generation/)

As for my part, my motivation in particular is in the "Corrupt Indian Chief" myth, which is arguably the basis of the
FNFTA legislation. By performing an independent analysis we have additional evidence to counter such racist colonial claims.

### Personal:

You might say adding "personal motivation" (along with personal pronouns) for such a report is unprofessional and will degrade
the quality and maturity of the whole project.  Part of the reason for this project is to get away from the "expert" mindset:

This "apprentice system" within the west is problematic in the context of colonization. Because the only recognized experts
are westerners, we have to apprentice under westerners to become experts ourselves. Though unintentional, these experts aren't
trained to *not* interfere with their apprentice's culture and worldview, and so in order to properly train, any such apprentice
must assimilate in order to be taken seriously. This is part of the reason I hold the Do-It-Yourself mentality. Keep in mind,
for any given academic/technical field that is now mature, at one point it was in its infancy and at the time those specialists
considered experts didn't know what they were doing---they couldn't have. We can very much make it up as we go instead of
relying on the patriarchy of apprenticeship. It might take a bit longer, but if Canadian settlers won't compromise,
we might have to take this path anyway as the alternative is no different than death.

With that said, to push this point further: There is no such thing as objectivity; everything is subjective. In math this can be
restated as: There is no such thing as truth, only consistency. With the exceptions of the limitations stated below, I did due
diligence in keeping things as accurate and consistent as possible within all phases of this project. I have presented this data
on GitHub in an open source way as part of this design. In the industry of computing, you have the best and brightest minds creating
software---experts you might say---and even they end up with software with unforseen bugs. It's patronizing to assume only *experts*
can and should make these reports. Having an open project like this means we can all contribute, and develop results and constructs
together, rather than have some "expert" telling us what to believe and how to interact with the world.

Extending this way of thinking, another part of the reason for this project is we need indigenous content made by indigenous
peoples for indigenous peoples. If you look at the statistics, *education* is an issue for indigenous peoples in Canada.
There are many historical and political reasons for that, but one thing I do know from my own experiences going through
school is I would have been much more motivated to do a homework assignment for example if I was working on indigenous data.
Currently there are far more women graduating with degrees, and due to complex social factors (sexism...), there are far more
humanist, law, and native studies graduates than math or engineering or statistics. For as much as we need our lawyers, artists,
writers, musicians, media makers, we also need physicists, engineers, mathematicians, statisticians, computing scientists.
Part of this, not to be overstated or understated, is in providing safe environments, resources, and infrastructure for
our people to grow. This includes actual indigenous content, by indigneous peoples for indigenous peoples. As I've said,
with my own privileges in life, as I recognize my own limits as an individual (I can't do everything), I will do my best to
leave behind as many tools and resources as I can for the next generation to inherit. Let that be my legacy if nothing else.

## Limitations of this project:

Within each phase, I will try to list the respective limitations in greater detail, but I will generalize here:

First are the *recommendations*. Obviously you need not take them seriously, but at least take a look: I frequently
joke that I'm a one-person indigenous think-tank, but I am legitimately pushing for the idea that we need such things
(whether or not I'm part of that). More than one would be better. If we just do it, initially there might be a bit
of a learning curve, but people get better, and its needed. Am I wrong? is it a colonial idea that can't be decolonized?

The greatest limitation in the analysis is the *translation phase*, which does effect the results of the final statistical
analysis. The end effect is the median and mean results are skewed to be a bit higher than they probably in fact are.
Much of this has to do with the fact that I chose to not delve into the audited consolidated reports. I stuck to the
schedules of remuneration and expenses, and because of that there were some financial categories I likely misclassified.

As well, as you will see, I took the role of "engineer" for this project, adhering to a modular design while strongly
relying on automation. In itself I view this as a strength, but as this was a first time effort, I have not yet gone
back and optimized the workflow---there's still are reasonable amount of messy prototyping. As such, I don't guarantee
there are no bugs in the code. The limit in particular is that it has been up until now the eyes of a single individual
(me) in finding the bugs and whatnot within this project.

## Final note:

All of the content here is under copyright 2015 of Daniel Nikpayuk. If you are using it for academic and non-profit purposes,
I give permission to use the full of it for society's benefit. Those who wish to use it for-profit (frankly I don't know
why you would, but if you exist) you do not have permission to use this at all (beyond anything permitted in fair use).

If you're indigenous and you find this useful, I am grateful. I do this for you. This is the best-case-scenario anyway.
For me, the worst-case-scenario is this project is used as a case study analyzing what was done well and what has room for
improvement---but that's just fine as it still serves a purpose. At the very least I learned much myself in the process.

Thank you.

---Daniel Nikpayuk
