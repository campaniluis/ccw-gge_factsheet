import pandas as pd
import os

def count_hcp_not_spoken(directory='./srcs/', total_hcp=127):
    n_hcp_spoke = set()

    for file in os.listdir(directory):
        if file.endswith('.csv'):
            df = pd.read_csv(os.path.join(directory, file))
            if {'Speaker', 'High Contracting Party'}.issubset(df.columns):
                n_hcp_spoke.update(df[df['High Contracting Party'] == 'Yes']['Speaker'])

    return total_hcp - len(n_hcp_spoke)

def main():
    n_hcp_silent = count_hcp_not_spoken()
    print(f"Number of High Contracting Parties with No Statements Delivered: {n_hcp_silent}")


if __name__ == "__main__":
    main()