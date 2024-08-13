import pandas as pd
import os

output_dir = './srcs/'

# Function to convert duration to seconds (assuming duration is in hh:mm:ss format)
def duration_to_seconds(duration):
    h, m, s = map(int, duration.split(':'))
    return h * 3600 + m * 60 + s

# Initialize a dictionary to store total speaking time and statement count for each speaker
speaker_data = {}

# Initialize variables to store the total speaking time and statement count of all speakers
total_speaking_time_all = 0
total_statements_all = 0

# Process each CSV file to accumulate speaker data
for file in os.listdir(output_dir):
    if file.endswith('.csv'):
        file_path = os.path.join(output_dir, file)
        df = pd.read_csv(file_path)
        if 'Speaker' in df.columns and 'Duration' in df.columns:
            for _, row in df.iterrows():
                speaker = row['Speaker']
                duration = duration_to_seconds(row['Duration'])  # Convert duration to seconds
                total_speaking_time_all += duration
                total_statements_all += 1
                if speaker not in speaker_data:
                    speaker_data[speaker] = {'total_time': 0, 'statement_count': 0}
                speaker_data[speaker]['total_time'] += duration
                speaker_data[speaker]['statement_count'] += 1

# Filter speakers with more than 15 statements
high_frequency_speakers = {speaker: data for speaker, data in speaker_data.items() 
                           if data['statement_count'] > 15}

# Convert the filtered data to a DataFrame for easier handling
result_df = pd.DataFrame.from_dict(high_frequency_speakers, orient='index')
result_df['speaker'] = result_df.index
result_df = result_df.reset_index(drop=True)

# Sort by total speaking time in descending order
result_df = result_df.sort_values('total_time', ascending=False)

# Calculate total speaking time of high-frequency speakers
total_high_freq_time = result_df['total_time'].sum()

# Calculate the percentage of total speaking time by high-frequency speakers
percentage_high_freq = (total_high_freq_time / total_speaking_time_all) * 100

# Print the percentage
print(f"Percentage of total speaking time by high-frequency speakers: {percentage_high_freq:.2f}%")