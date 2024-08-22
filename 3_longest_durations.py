import os
import pandas as pd

def duration_to_seconds(duration):
    h, m, s = map(int, duration.split(':'))
    return h * 3600 + m * 60 + s

def process_speaker_data(directory):
    speaker_data = {}
    total_speaking_time_all = 0
    total_statements_all = 0

    for file in os.listdir(directory):
        if file.endswith('.csv'):
            df = pd.read_csv(os.path.join(directory, file))
            if {'Speaker', 'Duration'}.issubset(df.columns):
                for _, row in df.iterrows():
                    speaker = row['Speaker']
                    duration = duration_to_seconds(row['Duration'])
                    
                    total_speaking_time_all += duration
                    total_statements_all += 1

                    if speaker not in speaker_data:
                        speaker_data[speaker] = {'total_time': 0, 'statement_count': 0}
                    
                    speaker_data[speaker]['total_time'] += duration
                    speaker_data[speaker]['statement_count'] += 1

    return speaker_data, total_speaking_time_all

def filter_and_calculate_percentage(speaker_data, total_speaking_time_all, min_statements=15):
    """Filter speakers with more than `min_statements` and calculate their total speaking time percentage."""
    high_freq_speakers = {speaker: data for speaker, data in speaker_data.items() 
                          if data['statement_count'] > min_statements}
    
    result_df = pd.DataFrame.from_dict(high_freq_speakers, orient='index').reset_index(drop=True)
    result_df['speaker'] = high_freq_speakers.keys()
    result_df = result_df.sort_values('total_time', ascending=False)

    total_high_freq_time = result_df['total_time'].sum()
    percentage_high_freq = (total_high_freq_time / total_speaking_time_all) * 100
    
    return percentage_high_freq

def main():
    output_dir = './srcs/'
    speaker_data, total_speaking_time_all = process_speaker_data(output_dir)
    percentage_high_freq = filter_and_calculate_percentage(speaker_data, total_speaking_time_all)

    print(f"Percentage of total speaking time by high-frequency speakers: {percentage_high_freq:.2f}%")

if __name__ == "__main__":
    main()