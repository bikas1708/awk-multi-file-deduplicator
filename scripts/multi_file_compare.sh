#!/bin/bash

if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <mode: unique|duplicate|all> <delimiter> <file1>:<key1> <file2>:<key2> [<file3>:<key3> ...]"
    exit 1
fi

MODE="$1"         # unique | duplicate | all
DELIM="$2"
shift 2           # Shift mode and delimiter out of the argument list

# Build awk variables
awk_vars=""
file_args=()
i=1

for arg in "$@"; do
    file="${arg%%:*}"
    key="${arg##*:}"
    awk_vars+=" -v f${i}=\"$file\" -v k${i}=$key"
    file_args+=("$file")
    ((i++))
done

# Generate dynamic AWK code
awk_code='
BEGIN {
    split(file_list, files, " ")
    for (i = 1; i <= length(files); i++) seen_order[i] = 0
}

'

for idx in "${!file_args[@]}"; do
    i=$((idx + 1))
    awk_code+=$(cat <<EOF

FILENAME == f${i} {
    key = \$k${i}
    seen[key]++
    if (!(key in lines)) {
        lines[key] = \$0
        order[++count] = key
    }
    next
}
EOF
)
done

awk_code+=$(cat <<'EOF'

END {
    for (i = 1; i <= count; i++) {
        k = order[i]
        if ((mode == "unique" && seen[k] == 1) ||
            (mode == "duplicate" && seen[k] > 1) ||
            (mode == "all")) {
            print lines[k]
        }
    }
}
EOF
)

# Run awk
awk $awk_vars -v mode="$MODE" -v FS="$DELIM" -v file_list="${file_args[*]}" "$awk_code" "${file_args[@]}"
