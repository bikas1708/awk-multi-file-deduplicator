# AWK Multi-File Deduplication Toolkit

**A collection of AWK-powered Bash scripts to:**
- Compare 2 or more delimited files
- Deduplicate based on configurable keyword fields
- Support custom delimiters
- Preserve original order
- Filter unique, duplicate, or all records

## 🔧 Usage

```bash
./multi_file_compare.sh unique "|" file1.txt:1 file2.txt:2 file3.txt:3 > output.txt


## **normal_script.sh**
 - This contains simple awk command to check a file for duplicate key, run on the terminal.
 - This does not check using the whole record but only uses a specific keyword location.

 - Your file (file.txt) looks like this:

        |---|---|---|
        | apple | fruit | 123 |
        | banana | fruit | 456 |
        | apple | fruit | 789 |
        | orange | fruit | 789 |
        | grape | fruit | 123 |
        | banana | fruit | 111 |
    
  - 📄 Example Output (output.txt), if using field $1:

        |---|---|---|
        | orange | fruit | 789 |
        | grape | fruit | 123 |

        ```bash
        awk -F'|' '{count[$1]++; lines[$1]=$0} END {for (k in count) if (count[k]==1) print lines[k]}' file.txt > output.txt
    
    - -F'|' sets the delimiter.
    - $1 is the keyword field (change to $2, $3, etc. as needed).
    - count[$1]++ counts occurrences of the keyword.
    - lines[$1]=$0 stores the full line.
    - Only prints lines where the keyword appeared once.
    - This can be used only when we have duplicate records in the same file and the keyword position is same 
    - NOTE: This doesn't check if each record/row is duplicate but only checks if the keyword is duplicate

    🛠 To change the field:
    To use a different field as the keyword (e.g., second field), change $1 to $2, etc. everywhere in the command.

## **awk_unique_2files.sh**
 - This contains awk command to check duplicate key from 2 Files and fetch only ones which are unique, run on the terminal.

        ```bash
        awk -F'|' '
            FNR==NR { seen[$1]++; file1[$1]=$0; next }
            { seen[$1]++; file2[$1]=$0 }
            END {
                for (k in seen) {
                    if (seen[k] == 1) {
                        if (k in file1) print file1[k]
                        else if (k in file2) print file2[k]
                    }
                }
            }
        ' file1.txt file2.txt > output.txt

    - FNR==NR is true for the first file (only) — collects line by keyword into file1.
    - Second file is then read — same for file2.
    -  seen[k] tracks how many times the keyword appears across both files.
    - Only prints those where the keyword appeared exactly once.

    🛠 To change the field:
    To use a different field as the keyword (e.g., second field), change $1 to $2, etc. everywhere in the command.
    You can change $1, $2, etc., based on which field has the keyword in each file.

    🧠 How to customize:

    | File        | Keyword field |
    | ----------- | ------------- |
    | `file1.txt` | `key1 = $1`   |
    | `file2.txt` | `key2 = $2`   |

## **unique_by_key.sh**
 - This is a bash script which take in input parameter of 2 file name and The keyword (field) position for each file.
 - NOTE: This can handle only 2 files and only returns key which appears exactly once across both files.

    ## 🧪 Example Usage
    
        ```bash
        - chmod +x unique_by_key.sh
        - ./unique_by_key.sh file1.txt 1 file2.txt 2 > output.txt

    - 1 is the keyword field position in file1.txt
    - 2 is the keyword field position in file2.txt
    - Output is saved to output.txt


## **unique_by_key_delim.sh**
 - This is a bash script which takes in input parameters of 2 file name and The keyword (field) position for each file, this also takes in delimiter as input
 - NOTE : This version Supports custom delimiter

    ## 🧪 Example:

        ```bash
        ./unique_by_key_delim.sh file1.txt 1 file2.txt 2 "|" > output.txt


📜 Scripts

| Script                     | Description                               | 
| -------------------------- | ----------------------------------------- | 
| `multi_file_compare.sh`    | Compare N files with configurable keys    | 
| `unique_by_key.sh`         | Compare 2 files using fixed \` delimiter  | 
| `unique_by_key_delim.sh`   | Same as above, but with custom delimiter  | 
| `unique_by_key_ordered.sh` | Preserve order of appearance              | 
| `unique_or_duplicates.sh`  | Add filtering mode (unique/duplicate/all) | 




---
### Scripts still Pending.

    - unique_by_key_ordered 
    - unique_or_duplicates



### FAQ 

    🧰 What is awk?
    awk is a text processing language.

    It's used to scan, filter, analyze, and format text, especially structured text (like CSV, TSV, logs).
    Named after its creators: Aho, Weinberger, and Kernighan.


    🧠 What Does awk Do?
    Think of awk like a spreadsheet processor for lines of text.
    It reads each line (record) one at a time.
    It splits each line into fields (like columns) based on a delimiter (default is space).
    It lets you act on those fields: print them, compare them, aggregate them, etc.



    🔧 Why use FNR==NR?
    When you're processing multiple files in one awk pass, you need a way to distinguish which file you're currently processing.

    ```awk
    FNR==NR {
        # This block runs only for file1
        ...
    next
    }
    # This block runs for file2
    ...

    Step-by-step:
        - awk starts reading file1.txt.
        - Since it's the first file, FNR == NR is true.
        - After next, awk skips to next line without running the rest of the script.
        - When it switches to file2.txt, FNR resets to 1, but NR continues — now FNR != NR, so awk skips the first block and executes the second.

