#' Find and remove duplicate .bib files in a directory
#'
#' @param path Character string: directory path to search for `.bib` files
#'   (default = current directory), or a character vector of file paths.
#' @param recursive Logical: should the search recurse into subdirectories?
#'   (default = `FALSE`)
#' @param remove Logical: if `TRUE`, duplicate files are removed; if `FALSE`,
#'   only a report is printed.
#'
#' @return Invisibly returns a list with elements:
#'   * `duplicates` – a list of groups of duplicate file paths.
#'   * `removed` – vector of file paths that were removed (if `remove = TRUE`).
#' @export
#'
#' @examples
#' \dontrun{
#' # Check current directory for duplicate .bib files (report only)
#' find_duplicate_files()
#'
#' # Remove duplicates in a subdirectory, including subfolders
#' find_duplicate_files("papers", recursive = TRUE, remove = TRUE)
#' }
find_duplicates = function(path = ".", recursive = FALSE, remove = FALSE) {
  # Get list of .bib files
  if (length(path) == 1 && dir.exists(path)) {
    files = list.files(path, pattern = "\\.bib$", full.names = TRUE,
                        recursive = recursive, ignore.case = TRUE)
  } else {
    files = path[file.exists(path) & grepl("\\.bib$", path, ignore.case = TRUE)]
  }

  if (length(files) < 2) {
    message("Less than two .bib files found; nothing to compare.")
    return(invisible(list(duplicates = list(), removed = character())))
  }

  # Compute MD5 hashes
  hashes = vapply(files, tools::md5sum, FUN.VALUE = character(1), USE.NAMES = FALSE)

  # Group files by hash, keep only groups with >1 file
  dup_groups = split(files, hashes)
  dup_groups = dup_groups[lengths(dup_groups) > 1]

  if (length(dup_groups) == 0) {
    message("No duplicate files found.")
    return(invisible(list(duplicates = list(), removed = character())))
  }

  # Report duplicates
  message("Found duplicate files:")
  for (group in dup_groups) {
    message("  - ", paste(basename(group), collapse = ", "))
  }

  removed = character()
  if (remove) {
    for (group in dup_groups) {
      # Keep the first file, remove the rest
      to_remove = group[-1]
      file.remove(to_remove)
      removed = c(removed, to_remove)
      message("Removed: ", paste(basename(to_remove), collapse = ", "))
    }
  }

  invisible(list(duplicates = dup_groups, removed = removed))
}
