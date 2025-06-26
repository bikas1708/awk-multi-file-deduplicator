awk -F'|' '{count[$2]++; lines[$2]=$0} END {for (k in count) if (count[k]==1) print lines[k]}' file.txt > output.txt



#-F'|' sets the delimiter.
#$1 is the keyword field (change to $2, $3, etc. as needed).
#count[$1]++ counts occurrences of the keyword.
#lines[$1]=$0 stores the full line.
#Only prints lines where the keyword appeared once.
