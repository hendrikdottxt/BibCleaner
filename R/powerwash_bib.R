#' Power‑wash one or more BibTeX files
#'
#' @param input_files Character vector of paths to .bib files.
#' @param output_dir Directory to save cleaned files (default = same as original folder).
#'
#' @return Invisibly returns a character vector of paths to the cleaned files.
#' @export
#'
#' @examples
#' \dontrun{
#' powerwash_bib("myrefs.bib")
#' powerwash_bib(c("paper1.bib", "paper2.bib"))
#' }
#'
powerwash_bib = function(input_files, output_dir = NULL) {

  # If a single file is given as a character string, wrap it in a list
  if (is.character(input_files) && length(input_files) == 1) {
    input_files = list(input_files)
  }

  results = c()

  # Loop over each file
  for (file in input_files) {

    # Using tryCatch so one failure doesnt stop the whole thing
    tryCatch({
      out = clean_bib(file, output_dir)
      results = c(results, out)
      message("Done")
    }, error = function(e) {
      message("Error on ", basename(file), ": ", e$message)
    })
  }

  message("\nProcessed ", length(results), " of ", length(input_files), " files.")
  invisible(results)
}
