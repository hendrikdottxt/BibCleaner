#' Power‑wash one or more BibTeX files
#'
#' Reads one or more `.bib` files, extracts the first author and year,
#' renames the file to `Author_Year.bib`, and saves it (optionally in a
#' different folder). The original file is deleted after successful renaming.
#'
#' @param input_files Character vector of paths to `.bib` files.
#' @param output_dir Optional directory where cleaned files will be saved.
#'   If `NULL` (default), files are saved in the same folder as the original.
#'
#' @return Invisibly returns a character vector of paths to the cleaned files.
#' @export
#'
#' @examples
#' \dontrun{
#' # Clean a single file
#' powerwash_bib("myrefs.bib")
#'
#' # Clean multiple files
#' powerwash_bib(c("paper1.bib", "paper2.bib"))
#'
#' # Save all cleaned files in a separate folder
#' powerwash_bib(list.files(pattern = "\\.bib$"), output_dir = "cleaned")
#' }
#'
powerwash_bib = function(input_files, output_dir = NULL) {

  # If single file, wrap it in a list
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
