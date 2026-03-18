test_that("clean_bib extracts author and year correctly", {
  temp = tempfile(fileext = ".bib")
  writeLines(
    c("@article{test,",
      "  author = {Smith, John},",
      "  year = {2024}",
      "}"),
    temp
  )

  result_path = clean_bib(temp)

  expect_true(file.exists(result_path))
  expect_true(grepl("Smith.*2024", basename(result_path)))

  file.remove(temp)
  file.remove(result_path)
})

