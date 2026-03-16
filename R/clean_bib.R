clean_bib = function(input_file, output_file = NULL) {
  if (!file.exists(input_file)) {
    stop("File not found: ", input_file)
  }

  lines = readLines(input_file, warn = FALSE)

  # Find the first entry
  entry_start = grep("^@", lines)[1]
  if (is.na(entry_start)) {
    stop("No BibTeX entries found in file")
  }

  # Get author line
  author_line = grep("\\bauthor\\s*=", lines, value = TRUE, ignore.case = TRUE)[1]

  # Extract just the content between { }
  if (!is.na(author_line)) {
    # Extract everything between first { and last }
    author_content = gsub(".*\\{(.*)\\}.*", "\\1", author_line)

    # Split by "and" (BibTeX standard) or commas
    # First try "and" separator
    authors = strsplit(author_content, " and ")[[1]]

    # If no "and", try splitting by comma
    if (length(authors) == 1) {
      authors = strsplit(author_content, ",")[[1]]
    }

    # Take first author and clean it
    first_author = trimws(authors[1])

    # Remove extra commas and spaces
    first_author = gsub(",", "", first_author)
    first_author = gsub("\\s+", "_", first_author)  # Replace spaces with _

    message("First author: ", first_author)
  } else {
    first_author = "Unknown_Author"
    message("No author found")
  }

  # Get year/date line
  year_line = grep("\\b(?:year|date)\\s*=", lines, value = TRUE, ignore.case = TRUE, perl = TRUE)[1]

  if (!is.na(year_line)) {
    # Extract year (4 digits)
    year_content = gsub(".*\\{?(\\d{4})\\}?.*", "\\1", year_line)
    message("Year: ", year_content)
  } else {
    year_content = "XXXX"
    message("No year found")
  }

  # Create new filename
  new_filename = paste0(first_author, "_", year_content, ".bib")
  message("\nSuggested filename: ", new_filename)

  # Return results
  list(
    author = first_author,
    year = year_content,
    suggested_name = new_filename,
    file = input_file
  )

  # Get the directory of the input file
  file_dir <- dirname(input_file)

  # Create full path for new file
  new_filepath <- file.path(file_dir, new_filename)

  # Copy/rename the file
  file.copy(input_file, new_filepath)

  # Optional: Remove original if you want
  # file.remove(input_file)

  message("\nFile saved as: ", new_filepath)

  # Return the new file path
  invisible(new_filepath)

}
