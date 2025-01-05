# Handling Parquet NYC Taxi Dataset

This document provides information on how to handle the NYC Taxi dataset in Parquet format, including viewing the data in VS Code and using command-line tools.

## Note: more project-specific notes on the Parquet-formatted NYC data set is recorded in cohorts/2024/01-docker-terraform/follow-along/study-notes/boris-follow-along-notes.md.

## Viewing Parquet Files in VS Code

### Parquet Viewer Extension

To view Parquet files in VS Code, you can use the "Parquet Viewer" extension by Random Fractals Inc. This extension is known for its performance and reliability.

### Steps to Install the Parquet Viewer Extension

1. **Open VS Code**:
   - Launch Visual Studio Code.

2. **Go to Extensions View**:
   - Click on the Extensions icon in the Activity Bar on the side of the window or press `Ctrl+Shift+X`.

3. **Search for "Parquet Viewer"**:
   - In the search bar, type "Parquet Viewer".

4. **Install the Extension by Random Fractals Inc.**:
   - Look for the "Parquet Viewer" extension by "Random Fractals Inc." and click the "Install" button.

### Example of the Extension in the Extensions View

```plaintext
# ...existing code...
Parquet Viewer
Author: Random Fractals Inc.
Description: View Parquet files in VS Code.
# ...existing code...
```

### Opening the Parquet File

1. **Open the Parquet File**:
   - Open the Parquet file in VS Code by navigating to the file in the Explorer view and clicking on it.
   - The Parquet Viewer extension will automatically display the contents of the Parquet file in a human-readable format.

## Viewing Parquet Files in a Bash Terminal

### Using Apache Arrow and Parquet Tools

You can use tools like `parquet-tools` or `pyarrow` to inspect Parquet files in a bash terminal.

### Installing Apache Arrow and Parquet Tools

**Using `parquet-tools`**:
- Install `parquet-tools` using Homebrew (macOS) or download the binary from the Apache Parquet website.

```bash
# macOS
brew install parquet-tools

# Linux (download the binary)
wget https://github.com/apache/parquet-mr/releases/download/apache-parquet-1.12.0/parquet-tools-1.12.0.jar
```

**Using `pyarrow`**:
- Install `pyarrow` using pip.

```bash
pip install pyarrow
```

### Inspecting the Parquet File

**Using `parquet-tools`**:
- Use the `parquet-tools` command to inspect the Parquet file.

```bash
# If installed via Homebrew
parquet-tools head /path/to/your/file.parquet

# If using the downloaded JAR file
java -jar parquet-tools-1.12.0.jar head /path/to/your/file.parquet
```

**Using `pyarrow`**:
- Use a Python script to read and display the Parquet file.

```python
# filepath: /path/to/inspect_parquet.py
import pyarrow.parquet as pq

# Replace with the path to your Parquet file
parquet_file = '/path/to/your/file.parquet'

# Read the Parquet file
table = pq.read_table(parquet_file)

# Convert to a Pandas DataFrame for easier viewing
df = table.to_pandas()

# Print the DataFrame
print(df)
```

- Run the Python script in the terminal.

```bash
python /path/to/inspect_parquet.py
```

By following these steps, you can inspect a Parquet file in a human-readable format using both VS Code and a bash terminal. If there are any further issues, please provide additional details for further analysis.
