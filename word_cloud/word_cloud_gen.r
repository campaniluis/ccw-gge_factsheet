# Load necessary libraries
library(ggwordcloud)
library(ggplot2)
library(showtext)
library(sysfonts)

# Enable showtext to use custom fonts
showtext_auto()

# Add the Poppins font from Google Fonts
font_add_google("Poppins", "poppins")

# Read the CSV file
df <- read.csv("consolidated_top_50_words.csv")

# Convert all words to uppercase
df$word <- toupper(df$word)

# Increase size scaling factor
df$percentage <- df$percentage * 100  # Adjust this factor to make words bigger

# Define the new color palette
colors <- c("#4a77a8")

# Create the word cloud with bold Poppins font and a rectangular appearance
wordcloud <- ggplot(df, aes(label = word, size = percentage)) +
  geom_text_wordcloud_area(eccentricity = 4, # Adjust eccentricity for a more rectangular shape
                           color = sample(colors, nrow(df), replace = TRUE),
                           family = "poppins",
                           fontface = "bold",
                           rm_outside = TRUE) + # Ensure text is not cut off
  scale_size_area(max_size = 50) + # Adjust max_size to control the largest word size
  theme_minimal() +
  theme(plot.margin = margin(0, 0, 0, 0), # Minimize margins
        panel.spacing = unit(0, "lines")) # Remove panel spacing

# Save the word cloud as an image file (e.g., PNG) with higher DPI and larger dimensions
ggsave("wordcloud.png", wordcloud, width = 12, height = 8, dpi = 300) # Higher DPI for better quality

# Print confirmation
if (file.exists("wordcloud.png")) {
  print("Word cloud has been saved as 'wordcloud.png'")
} else {
  print("Error: Word cloud could not be saved")
}