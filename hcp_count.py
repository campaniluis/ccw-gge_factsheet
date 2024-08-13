import pandas as pd
import os

output_dir = './srcs/'

# Initialize a set to store unique high contracting parties
high_contracting_parties = set()

# Read and process each CSV file in the directory
for file in os.listdir(output_dir):
    if file.endswith('.csv'):
        df = pd.read_csv(os.path.join(output_dir, file))
        # Update the set with unique speakers if the 'Speaker' column exists
        high_contracting_parties.update(df.get('Speaker', []))

# Print the number of unique high contracting parties
print(f"Number of High Contracting Parties: {len(high_contracting_parties)}")