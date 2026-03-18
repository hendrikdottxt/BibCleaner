test_that("powerwash_bib works on multiple files (current behavior)", {
  # Two temp files with different authors/years
  temp1 = tempfile(fileext = ".bib")
  writeLines(
    c("@article{a,",
      "  author = {Smith, John},",
      "  year = {2024}",
      "}"),
    temp1
  )
  temp2 = tempfile(fileext = ".bib")
  writeLines(
    c("@article{b,",
      "  author = {Jones, Mary},",
      "  date = {2023}",
      "}"),
    temp2
  )

  result = powerwash_bib(c(temp1, temp2))

  # Expect two output paths
  expect_length(result, 2)
  expect_true(all(file.exists(result)))

  #Lastname_journalYear pattern
  expect_true(grepl("Smith_2024", basename(result[1])))
  expect_true(grepl("Jones_2023", basename(result[2])))

})

test_that("powerwash_bib works with a single file", {
  temp = tempfile(fileext = ".bib")
  writeLines(
    c("@article{test,",
      "  author = {Smith, John},",
      "  year = {2024}",
      "}"),
    temp
  )

  result = powerwash_bib(temp)

  expect_length(result, 1)
  expect_true(file.exists(result))
  expect_true(grepl("Smith_2024", basename(result)))

  file.remove(result)
})
