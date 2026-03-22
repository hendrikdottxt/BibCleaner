test_that("find_duplicates detects identical files", {
  # Create two identical .bib files
  file1 = tempfile(fileext = ".bib")
  file2 = tempfile(fileext = ".bib")
  writeLines("@article{test, author = {Smith, J.}}", file1)
  writeLines("@article{test, author = {Smith, J.}}", file2)

  result = find_duplicates(c(file1, file2))
  expect_length(result$duplicates, 1)          # one group of duplicates
  expect_equal(lengths(result$duplicates)[[1]], 2)   # drops the name # group has two files

  file.remove(file1, file2)
})

test_that("find_duplicates ignores different files", {
  file1 = tempfile(fileext = ".bib")
  file2 = tempfile(fileext = ".bib")
  writeLines("@article{a, author = {Smith}}", file1)
  writeLines("@article{b, author = {Jones}}", file2)

  result = find_duplicates(c(file1, file2))
  expect_length(result$duplicates, 0)          # no duplicates found

  file.remove(file1, file2)
})

test_that("find_duplicates removes duplicates when asked", {
  file1 = tempfile(fileext = ".bib")
  file2 = tempfile(fileext = ".bib")
  content = "@article{dup, author = {Smith}}"
  writeLines(content, file1)
  writeLines(content, file2)

  result = find_duplicates(c(file1, file2), remove = TRUE)

  expect_length(result$removed, 1)               # one file removed
  expect_true(!file.exists(result$removed))      # removed file is gone
  # At least one of the original files should remain (the kept one)
  remaining = setdiff(c(file1, file2), result$removed)
  expect_true(file.exists(remaining))

  # Clean up
  file.remove(c(file1, file2)[file.exists(c(file1, file2))])
})

test_that("find_duplicates works with a directory", {
  dir = tempfile()
  dir.create(dir)
  file1 = file.path(dir, "a.bib")
  file2 = file.path(dir, "b.bib")
  writeLines("same content", file1)
  writeLines("same content", file2)

  result = find_duplicates(dir)
  expect_length(result$duplicates, 1)

  unlink(dir, recursive = TRUE)
})
