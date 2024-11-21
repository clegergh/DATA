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

``` r
library(tidyverse) 
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(polite) 

library(rvest) 
```

    ## 
    ## Attaching package: 'rvest'
    ## 
    ## The following object is masked from 'package:readr':
    ## 
    ##     guess_encoding

Task 1: Check if *Theory and Applications of Categories (TAC)* index
page can be scraped.

``` r
bow("http://www.tac.mta.ca/tac/") 
```

    ## <polite session> http://www.tac.mta.ca/tac/
    ##     User-agent: polite R package
    ##     robots.txt: 1 rules are defined for 1 bots
    ##    Crawl delay: 5 sec
    ##   The path is scrapable for this user-agent

Task 2: Check a site like Instagram.

``` r
bow("https://www.instagram.com/") 
```

    ## <polite session> https://www.instagram.com/
    ##     User-agent: polite R package
    ##     robots.txt: 188 rules are defined for 32 bots
    ##    Crawl delay: 5 sec
    ##   The path is not scrapable for this user-agent

Task 3: Scrape one article using read_html() function from rvest

``` r
article_42_1 <- read_html("http://www.tac.mta.ca/tac/volumes/42/1/42-01abs.html") 
```

## Choosing What to Scrape

### Function: html_elements()

``` r
article_42_1 |> html_elements("h2") 
```

    ## {xml_nodeset (1)}
    ## [1] <h2>\nStephen Lack and Adrian Miranda\n</h2>

What we found so far:

- html_elements(“h1”) selects the article title

- html_elements(“h2”) selects the authors

- html_elements(“p”) selects multiple paragraphs

### Function: html_element()

html_element() retrieves the first match.

Test with p

``` r
article_42_1 |> html_element("p") 
```

    ## {html_node}
    ## <p>

### Function: html_text2()

html_text2() retrieves the text only.

``` r
article_42_1 |> html_element("h1") |> 
  html_text2() 
```

    ## [1] "What is the universal property of the 2-category of monads?"

### Function: html_attr()

html_attr() retrieves the value in an attribute. An example of an
element with an attribute is the tag “a” and the attribute “href”

``` r
article_42_1 |> html_elements("a") |>  
  html_attr("href") 
```

    ## [1] "http://www.tac.mta.ca/tac/volumes/42/1/42-01.pdf"
    ## [2] "../../../index.html"

Combine some of these fields to create a tibble:

``` r
tibble( 
  authors = article_42_1 |>  
    html_element("h2") |>  
    html_text2(), 
  articleTitle = article_42_1 |>  
    html_element("h1") |>  
    html_text2(), 
  articleAbstract = article_42_1 |>  
    html_element("p") |>  
    html_text2() 
) 
```

    ## # A tibble: 1 × 3
    ##   authors                         articleTitle                   articleAbstract
    ##   <chr>                           <chr>                          <chr>          
    ## 1 Stephen Lack and Adrian Miranda What is the universal propert… "For a 2-categ…

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

``` r
tac_index_html <- "http://www.tac.mta.ca/tac/" |>  
  read_html() 
```

Task: Identify the links to the abstract pages.

``` r
tac_links <- tac_index_html |>  
  html_elements("a") |>  
  html_attr("href") |>  
  str_subset("41-..abs") |>  
  str_unique() 
```

``` r
tac_links <- str_glue("http://www.tac.mta.ca/tac/{tac_links}") 
```

Scrape all pages for vol 41:

I referred to [Web Scraping using R by Jakob
Tures](https://jakobtures.github.io/web-scraping/rvest3.html) to find
out how to read multiple pages. This is accomplished using the map()
function, which is covered in the Iteration chapter of R4DS.

The map function applies a function to each element of a vector.

We have a list of links saved as a character vector. In this case the
function we want to use is read_html.

``` r
pages <- tac_links |>  
  map(read_html) 
```

The output, pages, is a list. Each item in the list includes the HTML
for one article.

We can now use map for each of the HTML elements we used as selectors
earlier.

``` r
pages |>  
  map(html_elements, "h1") |>  
  map_chr(html_text2) 
```

    ##  [1] "A Gelfand duality for continuous lattices"                                                          
    ##  [2] "A Model for the Higher Category of Higher Categories"                                               
    ##  [3] "The category of necklaces is Reedy monoidal"                                                        
    ##  [4] "Pivotality, twisted centres, and the anti-double of a Hopf monad"                                   
    ##  [5] "Twisted separability for adjoint functors"                                                          
    ##  [6] "Completion under strong homotopy cokernels"                                                         
    ##  [7] "Directed degeneracy maps for precubical sets"                                                       
    ##  [8] "Uniform locales and their constructive aspects"                                                     
    ##  [9] "A Quillen model structure of local homotopy equivalences"                                           
    ## [10] "Formal category theory in augmented virtual double categories"                                      
    ## [11] "Ideally Exact Categories"                                                                           
    ## [12] "On reachability categories, persistence, and commuting algebras of quivers"                         
    ## [13] "Existence of groupoid models for diagrams of groupoid correspondences"                              
    ## [14] "Semisimplicity manifesting as categorical smallness"                                                
    ## [15] "Left adjoint to precomposition in elementary doctrines"                                             
    ## [16] "Lax comma categories: cartesian closedness, extensivity, topologicity, and descent"                 
    ## [17] "Categorical aspects of congruence distributivity"                                                   
    ## [18] "Factorization systems and double categories"                                                        
    ## [19] "Towards a new cohomology theory for strict Lie 2-groups"                                            
    ## [20] "Adjoint functor theorems for lax-idempotent pseudomonads"                                           
    ## [21] "The core groupoid can suffice"                                                                      
    ## [22] "Bicategorical traces and cotraces"                                                                  
    ## [23] "Closed symmetric monoidal structures on the category of graphs"                                     
    ## [24] "Free precategories as presheaf categories"                                                          
    ## [25] "From Specker ℓ-groups to boolean algebras via Γ"                                                    
    ## [26] "Lifting twisted coreflections against delta lenses"                                                 
    ## [27] "Relative ideals in homological categories with an application to MV-algebras"                       
    ## [28] "Indexed Grothendieck construction"                                                                  
    ## [29] "On domain-like objects in the category of unitary rings"                                            
    ## [30] "Pointwise Kan extensions along 2-fibrations and the 2-category of elements"                         
    ## [31] "Weak vertical composition II: totalities"                                                           
    ## [32] "Torsion aspects of varieties of simplicial groups"                                                  
    ## [33] "The category of extensions and idempotent completion"                                               
    ## [34] "Kleisli categories, T-categories and internal categories"                                           
    ## [35] "Some properties of internal locale morphisms externalised"                                          
    ## [36] "Condensation inversion and Witt equivalence via generalised orbifolds"                              
    ## [37] "Categorical generalisations of quantum double models"                                               
    ## [38] "String diagrams for 4-categories and fibrations of mapping 4-groupoids"                             
    ## [39] "The stable category of preordered groups"                                                           
    ## [40] "Towards constructivising the Freyd-Mitchell Embedding Theorem"                                      
    ## [41] "Filtral pretoposes and compact Hausdorff locales"                                                   
    ## [42] "A 2-categorical analysis of context comprehension"                                                  
    ## [43] "From Ramsey degrees to Ramsey expansions via weak amalgamation"                                     
    ## [44] "Monadic functors forgetful of (dis)inhibited actions"                                               
    ## [45] "Comparing 2-crossed modules with Gray 3-groups"                                                     
    ## [46] "Graded braided commutativity in Hochschild cohomology"                                              
    ## [47] "A coherence theorem for pseudo symmetric multifunctors"                                             
    ## [48] "Enriched Morita theory of monoids in a closed symmetric monoidal category"                          
    ## [49] "Yoneda lemma and representation theorem for double categories"                                      
    ## [50] "CP^∞ and beyond: 2-categorical dilation theory"                                                     
    ## [51] "From abelian categories to 2-abelian bicategories"                                                  
    ## [52] "Enriched structure-semantics adjunctions and monad-theory equivalences for subcategories of arities"
    ## [53] "A finitary adjoint functor theorem"

And now we can start building a tibble, working towards the
specifications for the University of Alberta CSV file:

issueTitle,sectionTitle,sectionAbbrev,authors,affiliation,DOI,articleTitle,year,datePublished,volume,issue,startPage,endPage,articleAbstract,galleyLabel,authorEmail,fileName,keywords,citations,cover_image_filename,cover_image_alt_text,licenseUrl,copyrightHolder,copyrightYear,locale_2,issueTitle_2,sectionTitle_2,articleTitle_2,articleAbstract_2 

``` r
tibble( 
  authors = pages |>  
    map(html_elements, "h2") |>  
    map_chr(html_text2), 
  articleTitle = pages |>  
    map(html_element, "h1") |>  
    map_chr(html_text2), 
  articleAbstract = pages |>  
    map(html_element, "p") |>  
    map_chr(html_text2) 
) 
```

    ## # A tibble: 53 × 3
    ##    authors                                 articleTitle          articleAbstract
    ##    <chr>                                   <chr>                 <chr>          
    ##  1 Ruiyuan Chen                            A Gelfand duality fo… "We prove that…
    ##  2 Nima Rasekh                             A Model for the High… "We use fibrat…
    ##  3 Violeta Borges Marques and Arne Mertens The category of neck… "In the first …
    ##  4 Sebastian Halbig and Tony Zorman        Pivotality, twisted … "Finite-dimens…
    ##  5 Julien Bichon                           Twisted separability… "Twisted separ…
    ##  6 Enrico M. Vitale                        Completion under str… "For A a categ…
    ##  7 Philippe Gaucher                        Directed degeneracy … "Symmetric tra…
    ##  8 Graham Manuell                          Uniform locales and … "Much work has…
    ##  9 Guillermo Cortiñas, Devarshi Mukherjee  A Quillen model stru… "In this note,…
    ## 10 Seerp Roald Koudenburg                  Formal category theo… "In this artic…
    ## # ℹ 43 more rows

### Class 2

We’ve succeeded in scraping the 53 abstract pages for vol. 41 of *TAC.*
So far we’ve identified that h2 can be used for authors, h1 can be used
for title, and that the first p is the abstract.

Here are the other pieces of information we need to identify in the
HTML:

- year

- datePublished

- volume

- startPage

- endPage

- fileName

- keywords

Once we do that, we’ll need to further refine the table to match the
expected input format for author names.

We also have some constants that can be entered for the following
columns:

- licenseURL

- copyrightHolder

Let’s go look at the HTML code for article 42_1 again and locate a
couple of approaches to finding this information.

test extracting datePublished, volume, startPage, lastPage

Unresolved problem:

Here is how the University of Alberta CSV file needs the names:

You can have multiple authors in the “authors” field by separating them
with a semi-colon. Also, use a comma to separating first and last names.
Example: Smith, John;Johnson, Jane …

Variations:

1.  One author
2.  Multiple authors, with names separated by either “,” or “and”

What I’d suggest:

Use separate_wider_regex() to split this column into separate authors.

Then split the author names on the last space as the delimiter.

Join the author names with the new delimiter.

Let’s find out how another student approached this webscraping project
in Python.

## Last thoughts

#### Learning objectives

At the end of the course, students are expected to be able to:

- Demonstrate in depth understanding of the principles, motivations and
  goals for reproducible, ethical, and open data

  - RDM lecture, Retraction Watch assignment, Open Science lecture by
    Dr. Vincent Lariviere

- Use Git for communication and reproducible version control

  - Assignment submissions

- Import and tidy diverse data sources across platforms

  - Statistics Canada data, research dataset from Borealis, webscraping
    TAC

- Explore data to identify potential research questions or problems in
  the dataset

  - *TAC* metadata inconsistencies

- Identify best practices for research data management, including data
  organization, storage, security, sharing, and ethical re-use

  - LEGO workshop (documentation), Research Data Management readings,
    Retraction Watch assignment, RDM examples

- Demonstrate what they have learned about data acquisition, data
  organization, and data tools through self-reflection

  - Ungrading conversations

## Last to-dos:

### CEWIL Survey

Dear \[student\]:

Please take the time to fill out this brief survey about your recently
funded experience, TACking Towards the Future, which was funded in part
through the CEWIL iHub grant and the Government of Canada’s Innovative
Work-Integrated Learning Program.

***Your experience is valuable in helping us to improve the
effectiveness of our programming***. The survey is very brief and will
only take about 5 minutes to complete. Please click the link below to go
to the survey web site (or copy and paste the link into your Internet
browser).  You will be asked for the project number.

**Your project number is 2024-R2-E1770**

**Survey link:** [CEWIL iHub Student Exit
Survey](https://forms.office.com/r/Z5ibuUDc8s)

Survey responses will be shared with the Government of Canada. All
individual survey responses are anonymous, and no personally
identifiable information will be associated with your responses to any
reports of these data.

Thank you very much for your time and cooperation. Feedback from
students is very important to CEWIL Canada and the Government of Canada.

2.  Project Number: **2024-R2-E1770**
3.  Community Partner: Theory & Application of Categories Editorial
    Board
4.  Industry / Community Supervisor’s Name: Dr. Geoffrey Cruttwell
5.  Industry / Community Supervisor’s Name: gcruttwell@mta.ca

### Student Experience Survey (Mount Allison / available on Moodle)

### Ungrading Meetings next week (no class!)
