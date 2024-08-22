# Load necessary libraries
library(dplyr)
library(ggplot2)
library(readr)
library(purrr)

# Define the directory containing your CSV files
csv_dir <- "srcs"

# List all CSV files in the directory
csv_files <- list.files(path = csv_dir, pattern = "*.csv", full.names = TRUE)

# Define the process_csv function
process_csv <- function(file) {
  tryCatch({
    df <- read_csv(file, col_types = cols(.default = col_character()))
    
    processed <- df %>%
      select(Speaker, `High Contracting Party`) %>%
      mutate(across(everything(), as.character)) %>%
      mutate(`High Contracting Party` = ifelse(`High Contracting Party` == "Yes", Speaker, NA_character_)) %>%
      filter(!is.na(`High Contracting Party`))
    
    return(processed)
  }, error = function(e) {
    print(paste("Error processing file:", file))
    print(paste("Error message:", e$message))
    return(NULL)
  })
}

# Process each file individually and store results in a list
processed_data <- map(csv_files, process_csv)

# Remove any NULL results (files that couldn't be processed)
processed_data <- compact(processed_data)

# Combine all processed dataframes
all_data <- bind_rows(processed_data)

# Count statements per high contracting party
statement_counts <- all_data %>%
  group_by(`High Contracting Party`) %>%
  summarise(Count = n()) %>%
  ungroup() %>%
  arrange(desc(Count))

# Calculate summary statistics
total_statements <- sum(statement_counts$Count)
total_countries <- nrow(statement_counts)
avg_statements <- mean(statement_counts$Count)
median_statements <- median(statement_counts$Count)

# Print summary statistics
cat("Summary Statistics:\n")
cat("Total number of statements:", total_statements, "\n")
cat("Total number of High Contracting Parties:", total_countries, "\n")
cat("Average number of statements per country:", round(avg_statements, 2), "\n")
cat("Median number of statements per country:", median_statements, "\n")

# Ensure distribution includes all numbers from 1 to the max count
max_count <- max(statement_counts$Count)
all_counts <- data.frame(Count = 1:max_count)

# Calculate distribution
distribution <- statement_counts %>%
  group_by(Count) %>%
  summarise(Num_High_Contracting_Parties = n()) %>%
  arrange(Count)

# Merge to ensure all numbers are included
distribution_complete <- all_counts %>%
  left_join(distribution, by = "Count") %>%
  mutate(Num_High_Contracting_Parties = ifelse(is.na(Num_High_Contracting_Parties), 0, Num_High_Contracting_Parties))

# Create the plot with the complete distribution
# Create the plot with the complete distribution
plot_distribution <- ggplot(distribution_complete, aes(x = factor(Count), y = Num_High_Contracting_Parties, fill = Count)) +
  geom_bar(stat = "identity", color = "#555555") +
  scale_fill_gradient(low = "#a1d986", high = "#5fa94b") +
  theme(
    plot.title = element_text(size = 14, face = "bold", color = "#333333"),
    plot.subtitle = element_text(size = 10, margin = margin(5, 0, 10, 0)),
    axis.title.x = element_text(size = 10, margin = margin(10, 0, 0, 0)),
    axis.title.y = element_text(size = 8, margin = margin(0, 5, 0, 0)),  # Smaller y-axis title
    axis.text.x = element_text(size = 8, color = "#333333"),
    axis.text.y = element_text(size = 6, color = "#333333"),  # Smaller y-axis text
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(color = "#dddddd"),
    panel.grid.minor = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  ) +
  labs(
    title = "Distribution of Statements by High Contracting Parties",
    subtitle = "Number of High Contracting Parties by Number of Statements",
    x = "Number of Statements",
    y = "Number of High Contracting Parties"
  ) +
  coord_fixed(ratio = 1/1)  # Adjust the aspect ratio (x/y ratio)

# Save the plot as a JPEG file
ggsave("distribution_of_statements.jpeg", plot = plot_distribution, device = "jpeg", bg = "white")
print(distribution_complete)