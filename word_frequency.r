library(dplyr)
library(readr)
library(tidytext)

# Read the CSV file
df <- read_csv("tidied_text.csv")

# Remove stop words and count the frequency of each word
word_counts <- df %>%
  anti_join(stop_words, by = "word") %>%
  count(word, sort = TRUE)

# Calculate the percentage of total words for each word
total_words <- sum(word_counts$n)
word_counts <- word_counts %>%
  mutate(percentage = n / total_words * 100)

# Select the top 50 most common words with percentages
top_50_words <- head(word_counts, 50)

# Save the top 50 words to a CSV file
write_csv(top_50_words, "top_50_words.csv")

# Display the top 50 most common words with percentages
print(top_50_words)

# Calculate some statistics
total_unique_words <- nrow(word_counts)
words_used_once <- sum(word_counts$n == 1)
percentage_used_once <- (words_used_once / total_unique_words) * 100

# Print the summary statistics
cat("Total words after removing stop words:", total_words, "\n")
cat("Total unique words after removing stop words:", total_unique_words, "\n")
cat("Words used only once:", words_used_once, "\n")
cat("Percentage of words used only once:", round(percentage_used_once, 2), "%\n")