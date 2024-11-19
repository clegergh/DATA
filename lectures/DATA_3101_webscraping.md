Web scraping with rvest
================

Webscraping in R is done with a library called
[rvest](https://rvest.tidyverse.org/) (like harvest, hahaha, good pun).
It is inspired by Python libraries like Beautiful Soup. It is included
in the tidyverse but the library still needs to be loaded. The function
in rvest help us work with HTML.

We can also use [polite](https://dmi3kno.github.io/polite/) to seek
permission to scrape, take slowly, and never ask twice. Polite includes
two functions: bow and scrape.

We’re going to dip into [Chapters 15 Regular
expressions](https://r4ds.hadley.nz/regexps) and [Chapter 26
Iteration](https://r4ds.hadley.nz/iteration) so that we can use *Theory
and Applications of Categories (TAC)* as our example. An additional
resource I used is [Web Scraping using
R.](https://jakobtures.github.io/web-scraping/index.html)

## Getting Started

Task 1: Check if *Theory and Applications of Categories (TAC)* index
page can be scraped.

Task 2: Check a site like Instagram.

Task 3: Scrape one article using read_html() function from rvest

## Choosing What to Scrape

Function: html_elements()

Function: html_element()

html_element() retrieves the first match.

Test with
<p>

Text and attributes

Function: html_text2()

Function: html_attr()

Combine some of these fields to create a tibble:

## CEWIL Project

Ok, so now we’ll get into the problems we’d have to solve to get this
into an XML file that we could import into OJS. Luckily we can build off
existing work done by [University of Alberta
Libraries](https://github.com/ualbertalib/ojsxml).

In their workflow, they transformed a CSV file into XML. We can use
webscraping in R to create a CSV file for each volume and then use their
application to generate the XML file we need for Open Journal Systems.

The CSV must be in the format of:
issueTitle,sectionTitle,sectionAbbrev,authors,affiliation,DOI,articleTitle,year,datePublished,volume,issue,startPage,endPage,articleAbstract,galleyLabel,authorEmail,fileName,keywords,citations,cover_image_filename,cover_image_alt_text,licenseUrl,copyrightHolder,copyrightYear,locale_2,issueTitle_2,sectionTitle_2,articleTitle_2,articleAbstract_2 

### Problems to solve

Extracting values from strings like: Vol. 42, 2024, No. 1, pp 2-8.

How? [Chapter 15: Regular expressions](https://r4ds.hadley.nz/regexps)

Scraping the HTML for each article and then moving on to the next one.

How? Programming! [Chapter 26:
Iteration](https://r4ds.hadley.nz/iteration)

### Scraping of multi-page websites

We can use the *TAC* homepage to identify the links we want to scrape.

Task: Identify the links to the abstract pages.

Scrape all pages for vol 41:

I referred to [Web Scraping using R by Jakob
Tures](https://jakobtures.github.io/web-scraping/rvest3.html) to find
out how to read multiple pages. This is accomplished using the map()
function, which is covered in the Iteration chapter of R4DS.

The map function applies a function to each element of a vector.

We have a list of links saved as a character vector. In this case the
function we want to use is read_html.

The output, pages, is a list. Each item in the list includes the HTML
for one article.

We can now use map for each of the HTML elements we used as selectors
earlier.

And now we can start building a tibble, working towards the
specifications for the University of Alberta CSV file:

issueTitle,sectionTitle,sectionAbbrev,authors,affiliation,DOI,articleTitle,year,datePublished,volume,issue,startPage,endPage,articleAbstract,galleyLabel,authorEmail,fileName,keywords,citations,cover_image_filename,cover_image_alt_text,licenseUrl,copyrightHolder,copyrightYear,locale_2,issueTitle_2,sectionTitle_2,articleTitle_2,articleAbstract_2 
