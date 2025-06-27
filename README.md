# 🛠 AWK Multi-File Deduplication Toolkit

This toolkit is designed to help efficiently compare and deduplicate large, delimited text files using AWK-based Bash scripts. When you're working with massive datasets (e.g., log files, CSVs, export dumps), checking for duplicates or unique records manually is error-prone and slow. These tools allow you to compare files by a specific field (e.g., user ID, transaction code) and extract meaningful data faster than loading into spreadsheets or custom applications.

A collection of **AWK-powered Bash scripts** to:

- Compare 2 or more delimited files
- Deduplicate based on keyword field positions
- Support custom delimiters (`|`, `,`, `;`, etc.)
- Preserve original order of entries (optional)
- Filter for `unique`, `duplicate`, or `all` records across files

---

## 📦 Available Scripts

| Script Name                | Description                                                         |
| -------------------------- | ------------------------------------------------------------------- |
| `normal_script.sh`         | Deduplicate within a **single file** using a specific keyword field |
| `awk_unique_2files.sh`     | Compare **two files** and extract unique keywords                   |
| `unique_by_key.sh`         | Bash script to compare 2 files with field positions as input        |
| `unique_by_key_delim.sh`   | Same as above, but supports **custom delimiters**                   |
| `unique_by_key_ordered.sh` | Preserves original order of matching records                        |
| `multi_file_compare.sh`    | Compare **multiple files** with field-key and mode flexibility      |

---

## 🔧 Usage Examples

### 🔹 Compare Multiple Files (flexible)

```bash
./multi_file_compare.sh unique "|" \
  file1.txt:1 \
  file2.txt:2 \
  file3.txt:3 > unique_output.txt
```

### 🔹 Keep only duplicate records across 3 files

```bash
./multi_file_compare.sh duplicate "|" \
  file1.txt:1 file2.txt:2 file3.txt:3 > duplicates.txt
```

### 🔹 Run basic single-file deduplication

```bash
awk -F'|' '{count[$1]++; lines[$1]=$0} END {for (k in count) if (count[k]==1) print lines[k]}' file.txt > output.txt
```

- `-F'|'` → sets delimiter
- `$1` → keyword field (change to `$2`, `$3`, etc.)
- Keeps only lines where the keyword appears exactly once in the file

---

## 📂 Sample Input & Output

### 📁 `file1.txt`

```
apple|fruit|100
banana|fruit|200
cherry|fruit|300
```

### 📁 `file2.txt`

```
kiwi|banana|150
lemon|fruit|250
mango|fruit|300
```

### 📁 `file3.txt`

```
date|cherry|400
elderberry|fruit|500
fig|fruit|600
```

### 🧪 Example: Unique keywords across 3 files

```bash
./multi_file_compare.sh unique "|" file1.txt:1 file2.txt:2 file3.txt:2
```

✅ **Expected Output:**

```
apple|fruit|100
kiwi|banana|150
lemon|fruit|250
mango|fruit|300
date|cherry|400
elderberry|fruit|500
fig|fruit|600
```

### 🧪 Example: Duplicate keywords across 3 files

```bash
./multi_file_compare.sh duplicate "|" file1.txt:1 file2.txt:2 file3.txt:2
```

✅ **Expected Output:**

```
banana|fruit|200
cherry|fruit|300
```

### 🧪 Example: Single file keyword-based deduplication

#### 📁 `file.txt`

```
apple|fruit|100
banana|fruit|200
apple|fruit|300
cherry|fruit|400
banana|fruit|500
date|fruit|600
```

```bash
awk -F'|' '{count[$1]++; lines[$1]=$0} END {for (k in count) if (count[k]==1) print lines[k]}' file.txt
```

✅ **Expected Output:**

```
cherry|fruit|400
date|fruit|600
```

---

## 🧺script: `unique_by_key.sh`

Compare two files using keyword field positions:

```bash
chmod +x unique_by_key.sh
./unique_by_key.sh file1.txt 1 file2.txt 2 > output.txt
```

- `1` = field in `file1.txt`
- `2` = field in `file2.txt`
- Output written to `output.txt`

---

## 🧺 Script: `unique_by_key_delim.sh`

Same as above, but allows custom delimiter (e.g., `|`, `,`, etc.):

```bash
./unique_by_key_delim.sh file1.txt 1 file2.txt 2 "|" > output.txt
```

---

## 🧺 Script: `unique_by_key_ordered.sh`

Preserves the original order of records (instead of sorting/grouping):

```bash
./unique_by_key_ordered.sh file1.txt 1 file2.txt 2 "|" > output.txt
```

---

## 🧬 How `multi_file_compare.sh` Works

- Accepts **any number of files**
- Format: `filename:field_position`
- Modes:
  - `unique`: only keywords seen once across all files
  - `duplicate`: keywords seen more than once
  - `all`: include everything

### Example:

```bash
./multi_file_compare.sh all "|" \
  file1.txt:1 file2.txt:2 file3.txt:3 > all_records.txt
```

---

## ⚙️ Customize by Field

| File        | Field Position |
| ----------- | -------------- |
| `file1.txt` | 1              |
| `file2.txt` | 2              |
| `file3.txt` | 2              |

---

## 🤔 FAQ

### ❓ Why did I make this `script`?

Currently while migrating data in pipe separated format I found that many mismatch were there in files which should have the same record count.
For this I needed to find the unique records which were present and then check from there why the record is present/absent from each file.
But the problem I faced was each file had more than a million record, this makes finding the unique records tough and adding to that each file had a different format.
No two records were the same, the only similarity was 1 specific keyword / primary key, so to make my task easier I made this script.
Now I just have to run this and get the unique records and check why the entry is there.
I hope that you find this useful for your analysis / ETL task and makes life a bit easier for you.

---

### ❓ What is `awk`?

`awk` is a powerful UNIX text-processing language. It reads lines of text, splits them into fields (by a delimiter), and lets you analyze, filter, and transform them.

---

### ❓ What does `FNR==NR` mean in `awk`?

Used when comparing **two files** in a single `awk` call:

```awk
FNR == NR {
  # This runs for the first file
  ...
  next
}
# This runs for the second file
```

- `FNR` = current file’s line number
- `NR` = total line number across all files
- `FNR == NR` is only true **for the first file**

---

## 📜 License

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

## 🙌 Contribute

Feel free to open pull requests or submit issues! This repo is built to help anyone dealing with messy file merges, deduplication, and record-level analysis using simple command-line tools.
