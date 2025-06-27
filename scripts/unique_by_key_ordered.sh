#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <file1> <key_pos_file1> <file2> <key_pos_file2> <delimiter>"
    exit 1
fi

FILE1="$1"
KEY1="$2"
FILE2="$3"
KEY2="$4"
DELIM="$5"

awk -v k1="$KEY1" -v k2="$KEY2" -F"$DELIM" '
    FNR==NR {
        key = $k1
        seen[key]++
        file1[key] = $0
        order[++count] = key
        next
    }
    {
        key = $k2
        seen[key]++
        file2[key] = $0
        order[++count] = key
    }
    END {
        for (i = 1; i <= count; i++) {
            k = order[i]
            if (seen[k] == 1)
                if (k in file1) print file1[k]
                else if (k in file2) print file2[k]
        }
    }
' "$FILE1" "$FILE2"




#PRESERVE order of the