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