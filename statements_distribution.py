import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import os

output_dir = './srcs/'

# Initialize a dictionary to count statements per high contracting party
statements_count = {}

# Count the number of statements for each speaker
for file in os.listdir(output_dir):
    if file.endswith('.csv'):
        file_path = os.path.join(output_dir, file)
        df = pd.read_csv(file_path)
        if 'Speaker' in df.columns:
            for speaker in df['Speaker']:
                if speaker in statements_count:
                    statements_count[speaker] += 1
                else:
                    statements_count[speaker] = 1

# Create a DataFrame from the statements count
statements_df = pd.DataFrame(list(statements_count.items()), columns=['Speaker', 'Statement Count'])

# Count the distribution of statement counts
distribution = statements_df['Statement Count'].value_counts().sort_index()

# Plotting the distribution
plt.figure(figsize=(10, 6))
sns.barplot(x=distribution.index, y=distribution.values, palette='viridis')
plt.title('Distribution of Statements Delivered by High Contracting Parties')
plt.xlabel('Number of Statements')
plt.ylabel('Number of High Contracting Parties')
plt.xticks(rotation=45)
plt.grid(axis='y')

# Save the plot as an HTML file
plt.tight_layout()
plt.savefig('statements_distribution.png')
plt.show()

# Indicate completion
print('done')