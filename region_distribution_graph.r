# Load necessary libraries
library(data.table)
library(ggplot2)
library(showtext)
library(sysfonts)

# Set the directory containing the CSV files
csv_dir <- "srcs"

# List all CSV files in the specified directory
csv_files <- list.files(path = csv_dir, pattern = "*.csv", full.names = TRUE)

# Read all CSV files into a list of data.tables
list_of_dfs <- lapply(csv_files, fread)

# Function to ensure consistent data types across all data.tables
convert_to_character <- function(df) {
  df[] <- lapply(df, as.character)
  return(df)
}

# Apply the function to each data.table in the list
list_of_dfs <- lapply(list_of_dfs, convert_to_character)

# Combine all data.tables into one after ensuring consistent data types
combined_df <- rbindlist(list_of_dfs)

# Count the number of statements per region
region_counts <- combined_df[, .N, by = Region]

# Rename the columns to match the previous code
setnames(region_counts, c("Region", "N"), c("Region", "Count"))

# Load and enable Open Sans font
font_add_google("Open Sans", "open_sans")
showtext_auto()

# Create the JPEG file
jpeg("region_distribution.jpg", width = 1000, height = 800, res = 150)

# Create a more attractive bar plot
ggplot(region_counts, aes(x = Region, y = Count)) +
  geom_bar(stat = "identity", fill = "#ffcd38", color = "#555555") +
  theme_minimal(base_family = "open_sans") +
  theme(
    plot.title = element_text(size = 20, face = "bold", color = "#333333"),
    plot.subtitle = element_text(size = 14, margin = margin(10, 0, 20, 0)),
    axis.title.x = element_text(size = 14, margin = margin(10, 0, 0, 0)),
    axis.title.y = element_text(size = 14, margin = margin(0, 10, 0, 0)),
    axis.text = element_text(size = 12, color = "#333333"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major = element_line(color = "#dddddd"),
    panel.grid.minor = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  ) +
  labs(
    title = "Distribution of Statements by Region",
    subtitle = "A visualization of the number of statements across different regions",
    x = "Region",
    y = "Number of Statements"
  )

# Close the JPEG device
dev.off()

# Print the region counts
print(region_counts)