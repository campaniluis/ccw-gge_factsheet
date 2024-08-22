import pandas as pd
from collections import defaultdict

def consolidate_csv(input_file='consolidated_top_50_words.csv', output_file='consolidated_top_50_words.csv'):
    # Load the CSV file
    df = pd.read_csv(input_file)
    
    # Create a dictionary to store consolidated data
    consolidated_data = defaultdict(lambda: {'word': '', 'n': 0, 'percentage': 0.0})
    
    # Loop through each row in the dataframe
    for index, row in df.iterrows():
        word = row['word']
        
        # Check for special case "law" and "laws"
        if word == "law" or word == "laws":
            base_word = word  # Keep them as separate entries
        else:
            # General case: remove trailing 's' to find the base form
            base_word = word.rstrip('s')
        
        # Store the most common derivative or original word
        if not consolidated_data[base_word]['word'] or word.endswith('s'):
            consolidated_data[base_word]['word'] = word
        
        # Add the current row's values to the base word's entry in the dictionary
        consolidated_data[base_word]['n'] += row['n']
        consolidated_data[base_word]['percentage'] += row['percentage']
    
    # Create a new dataframe from the consolidated data
    consolidated_df = pd.DataFrame([
        {'word': data['word'], 'n': data['n'], 'percentage': data['percentage']}
        for word, data in consolidated_data.items()
    ])
    
    # Save the new dataframe to a CSV file
    consolidated_df.to_csv(output_file, index=False)

# Run the function
consolidate_csv()