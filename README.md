#BibCleaner

Helps tidy up .bib files!

Helps maintiain clean .bib files by:

Renaming files to a consistent Author_Year.bib format
Finding duplicates 
Processing multiple .bib files with messy names into Author_Year.bib format. 

--------------------------------------------------------------------------------------------------

#Installation

install.packages("devtools")
devtools::install_github("hendrikdottxt/BibCleaner")

Functions and their uses:

##clean_bib():
clean_bib("refrence.bib")
#returns "Author_Year", and saves it (ex. "Smith_2026.bib")

##powerwash_bib()
powerwash_bib(c("refrence1.bib", refrence2.bib, refrence3.bib"))
#returns Author_Year named files for all input files.

##find_duplicates()
find_duplicates("/directory")
#Ignores file names, and finds .bib files with duplicate internals, and returns them.

--------------------------------------------------------------------------------------------------

How it works
Author extraction: The first author’s last name and first initial are used (e.g., Smith, John → Smith_J).

Year extraction: The four‑digit year is taken from the year or date field. If missing, XXXX is used.

The renamed file is saved in the same folder as the original (or in output_dir if provided).

--------------------------------------------------------------------------------------------------
