import os
import pandas as pd

def duration_to_seconds(duration):
    h, m, s = map(int, duration.split(':'))
    return h * 3600 + m * 60 + s

def seconds_to_hhmmss(seconds):
    h = seconds // 3600
    m = (seconds % 3600) // 60
    s = seconds % 60
    return f"{h:02}:{m:02}:{s:02}"

def calculate_no_high_contracting_party_time(directory):
    total_time, time_civil_society = 0, 0
    organizations_included = set()
    
    exclude_speakers = {
        'IRAN (ISLAMIC REPUBLIC OF)',
        'EUROPEAN UNION',
        'I. NAKAMITSU UNDER SECRETARY GENERAL AND HIGH REPRESENTATIVE FOR DISARMAMENT AFFAIRS'
    }
    
    for file in os.listdir(directory):
        if file.endswith('.csv'):
            df = pd.read_csv(os.path.join(directory, file))
            if {'High Contracting Party', 'Duration', 'Speaker'}.issubset(df.columns):
                df['Duration_in_Seconds'] = df['Duration'].apply(duration_to_seconds)
                total_time += df['Duration_in_Seconds'].sum()
                
                filtered_df = df[
                    (df['High Contracting Party'] == 'No') & 
                    (~df['Speaker'].isin(exclude_speakers))
                ]
                time_civil_society += filtered_df['Duration_in_Seconds'].sum()
                organizations_included.update(filtered_df['Speaker'].unique())
    
    percentage_civil_society = (time_civil_society / total_time) * 100 if total_time else 0
    return seconds_to_hhmmss(time_civil_society), percentage_civil_society, sorted(organizations_included)

def main():
    output_dir = './srcs/'
    time_civil_society, percentage_civil_society = calculate_no_high_contracting_party_time(output_dir)
    
    print(f"Total time for Civil Society: {time_civil_society}")
    print(f"Percentage of total time: {percentage_civil_society:.2f}%")

if __name__ == "__main__":
    main()