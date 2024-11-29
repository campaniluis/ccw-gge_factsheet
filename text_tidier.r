library(readr)
library(dplyr)
library(tidyr)
library(stringr)

# Function to process a single CSV file
process_csv_with_session_word_number <- function(file) {
  # Extract the session date and shift from the filename
  filename <- basename(file)
  session_date <- str_extract(filename, "\\d{8}")
  session_date <- as.Date(session_date, format = "%Y%m%d")
  session_shift <- ifelse(str_detect(filename, "M"), "Morning", "Afternoon")
  
  df <- read_csv(file)
  if ("Statement" %in% colnames(df)) {
    words <- df %>%
      select(Statement) %>%
      mutate(Statement = tolower(Statement)) %>%
      mutate(word = strsplit(Statement, "\\s+")) %>%
      unnest(word) %>%
      mutate(word = str_remove_all(word, "[[:punct:]]")) %>%
      filter(nchar(word) > 0) %>%
      mutate(word_number = row_number(),
             session_date = session_date,
             session_shift = session_shift) %>%
      select(word_number, session_date, session_shift, word)
    return(words)
  } else {
    print(paste("'Statement' column not found in", file))
    return(NULL)
  }
}

# Get all CSV files from the srcs folder
csv_files <- list.files(path = "srcs", pattern = "*.csv", full.names = TRUE)

# Process all CSV files with session and word number
all_words_with_session_word_number <- lapply(csv_files, process_csv_with_session_word_number)
all_words_with_session_word_number <- bind_rows(all_words_with_session_word_number)

# Save the combined words dataframe to a CSV file
output_file_with_session_word_number <- "tidied_text.csv"
write_csv(all_words_with_session_word_number, output_file_with_session_word_number)
print(paste("Combined words with session, date, shift, and word number saved to", output_file_with_session_word_number))