#' Clean BibTeX files
#'
#' @param input_file Character vector of path to .bib file
#' @param output_dir Directory to save cleaned files (default = same directory)
#'
#' @return Invisibly returns paths to cleaned files
#' @export
#'
#' @examples
#' \dontrun{
#' clean_bib("myrefs.bib")
#' clean_bib(c("file1.bib", "file2.bib"))
#' }
#'
clean_bib = function(input_file, output_dir = NULL) {
  if (!file.exists(input_file)) {
    stop("File not found: ", input_file)
  }

  lines = readLines(input_file, warn = FALSE)

  #Grab first entry, stop if it doesnt exist
  entry_start = grep("^@", lines)[1]
  if (is.na(entry_start)) {
    stop("No BibTeX entries found in file")
  }

  # Get author line
  author_line = grep("\\bauthor\\s*=", lines, value = TRUE, ignore.case = TRUE)[1]

  # Extract just the content between { }
  if (!is.na(author_line)) {
    author_content = gsub(".*\\{(.*)\\}.*", "\\1", author_line)

    # Split by "and" (BibTeX standard) or commas. First "and" and then "," (commas).
    authors = strsplit(author_content, " and ")[[1]]
    if (length(authors) == 1) {
      authors = strsplit(author_content, ",")[[1]]
    }

    # Remove whitespaces from authir string.
    first_author = trimws(authors[1])

    # Remove extra commas and spaces, and replace spaces with _
    first_author = gsub(",", "", first_author)
    first_author = gsub("\\s+", "_", first_author)

    message("First author: ", first_author)
  } else {
    first_author = "Unknown_Author"
    message("No author found")
  }

  # Get year/date line, with condition for when its not available.
  year_line = grep("\\b(?:year|date)\\s*=", lines, value = TRUE, ignore.case = TRUE, perl = TRUE)[1]

  if (!is.na(year_line)) {
    # Extract year (4 digits)
    year_content = gsub(".*\\{?(\\d{4})\\}?.*", "\\1", year_line)
    message("Year: ", year_content)
  } else {
    year_content = "XXXX"
    message("No year found")
  }

  # Renaming file using grabbed first author and journal release year.
  new_filename = paste0(first_author, "_", year_content, ".bib")
  message("\nSuggested filename: ", new_filename)

  # Return list of relevant data for clarity.
  list(
    author = first_author,
    year = year_content,
    suggested_name = new_filename,
    file = input_file
  )

  # Get the directory of the input file
  file_dir = dirname(input_file)

  # Create full path for new file
  new_filepath = file.path(file_dir, new_filename)

  # Copy/rename the file
  file.copy(input_file, new_filepath)

  message("\nFile saved as: ", new_filepath)

  # Return the new file path
  invisible(new_filepath)

}







