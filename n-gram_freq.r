library(dplyr)
library(readr)
library(ggplot2)
library(tidytext)
library(stringr)
library(tidyr)

# Read the CSV file
df <- read_csv("tidied_text.csv")

# Function to process n-grams with a minimum of 7 words
process_ngrams_min_7 <- function(n_min) {
  df %>%
    group_by(session_date, session_shift) %>%
    summarise(text = paste(word, collapse = " "), .groups = "drop") %>%
    unnest_tokens(ngram, text, token = "ngrams", n = n_min) %>%
    filter(str_count(ngram, "\\S+") >= n_min) %>% # Ensure that the ngram has at least 7 words
    count(ngram, sort = TRUE) %>%
    mutate(n_words = str_count(ngram, "\\S+"))
}

# Process n-grams with 7 or more words
ngrams_7_plus <- process_ngrams_min_7(7)

# Remove stop words from n-grams
data(stop_words)
ngrams_filtered <- ngrams_7_plus %>%
  separate(ngram, into = paste0("word", 1:max(ngrams_7_plus$n_words)), sep = " ", fill = "right") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word | is.na(word2),
         !word3 %in% stop_words$word | is.na(word3),
         !word4 %in% stop_words$word | is.na(word4),
         !word5 %in% stop_words$word | is.na(word5),
         !word6 %in% stop_words$word | is.na(word6),
         !word7 %in% stop_words$word | is.na(word7)) %>%
  unite(ngram, paste0("word", 1:max(ngrams_7_plus$n_words)), sep = " ", na.rm = TRUE) %>%
  arrange(desc(n))

# Display the top 50 most common n-grams with 7+ words after removing stop words
top_50_ngrams_7_plus <- head(ngrams_filtered, 50)
print("Top 50 most common n-grams with 7+ words after removing stop words:")
print(top_50_ngrams_7_plus)

# Create a bar plot of the top 20 most common 7+ word n-grams
p1 <- ggplot(top_50_ngrams_7_plus, aes(x = reorder(ngram, n), y = n)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 50 Most Common 7+ Word N-grams (Excluding Stop Words)", 
       x = "N-gram", 
       y = "Frequency") +
  theme_minimal()

print(p1)
ggsave("top_50_ngrams_7_plus_no_stopwords.png", plot = p1, width = 12, height = 8)

# Calculate the percentage of total n-grams for each n-gram
total_ngrams <- sum(ngrams_filtered$n)
ngrams_filtered <- ngrams_filtered %>%
  mutate(percentage = n / total_ngrams * 100)

# Display the top 50 most common 7+ word n-grams with percentages
print("Top 50 most common 7+ word n-grams with percentages:")
print(head(ngrams_filtered, 50))

# Calculate some statistics
total_unique_ngrams <- nrow(ngrams_filtered)
ngrams_used_once <- sum(ngrams_filtered$n == 1)
percentage_used_once <- (ngrams_used_once / total_unique_ngrams) * 100

# Print the summary statistics
cat("Total n-grams after removing stop words:", total_ngrams, "\n")
cat("Total unique n-grams after removing stop words:", total_unique_ngrams, "\n")
cat("N-grams used only once:", ngrams_used_once, "\n")
cat("Percentage of n-grams used only once:", round(percentage_used_once, 2), "%\n")

# Distribution of n-gram lengths
ngram_length_distribution <- ngrams_filtered %>%
  mutate(ngram_length = str_count(ngram, "\\S+")) %>%
  count(ngram_length) %>%
  mutate(percentage = n / sum(n) * 100)

print("Distribution of n-gram lengths:")
print(ngram_length_distribution)

# Plot the distribution of n-gram lengths
p2 <- ggplot(ngram_length_distribution, aes(x = factor(ngram_length), y = percentage)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Distribution of N-gram Lengths (7+ Words)", 
       x = "Number of Words in N-gram", 
       y = "Percentage") +
  theme_minimal()

print(p2)
ggsave("ngram_length_distribution_7_plus.png", plot = p2, width = 10, height = 6)