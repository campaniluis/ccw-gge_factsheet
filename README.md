# CCW-GGE Factsheet

## Description

This project aims to highlight global discrepancies in the multilateral negotations towards a legally binding instrument on autonomous weapons through the Convention on Certain Conventional Weapons' Group of Governmental Experts (CCW/GGE) on LAWS. 

It generates various data analyses related to the CCW/GGE. It includes Python and R scripts to process and visualize data on civil society participation, regional distribution, and other relevant statistics.

What if we could build more tools to analyse multilateral negotiations on top of this? Contribute in this repository or reach out for future projects.


## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Files](#files)
- [Contributing](#contributing)
- [License](#license)

## Installation

1. Download the transcripts from the UNOG website:
    https://conf.unog.ch/digitalrecordings/en
2. Parse the data (algorithm publicly available soon);
4. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/ccw-gge_factsheet.git
   ```

5. Add a srcs folder with the input you want before running the functions;


## Files

	•	3_longest_durations.py: Analyzes the longest durations related to certain activities.
	•	civil_society_time.py: Processes and visualizes data on civil society participation.
	•	hcp_count.py: Counts High Contracting Parties (HCP) and generates relevant statistics.
	•	statements_distribution.py: Visualizes the distribution of statements across various categories.
	•	statements_distribution.r: R script for analyzing the distribution of statements.
	•	region_distribution_graph.r: Generates regional distribution graphs.
	•	text_tidier.r: organizes statements to extract most common words.
	•	word_frequency.r: generates list of most 50 most frequent words.
	•	words_parser.py: removes duplicates from most frequent words list.
	•	word_cloud_gen.r: generate word cloud from parsed most frequent words list.

## Contributing

Contributions are welcome!

## License
Copyright (c) 2024 [InterAgency Institute]([url](https://interagency.institute))

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
