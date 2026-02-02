#!/bin/bash

input_file="$1"
output_file="output.txt"

> "$output_file"   # clear output file

awk '
/"frame.time"/ {
    frame_time = $0
}
/"wlan.fc.type"/ {
    fc_type = $0
}
/"wlan.fc.subtype"/ {
    fc_subtype = $0

    # Once all 3 are found, print them
    print frame_time >> "'"$output_file"'"
    print fc_type >> "'"$output_file"'"
    print fc_subtype >> "'"$output_file"'"
    print "" >> "'"$output_file"'"   # blank line between entries

    # reset for next frame
    frame_time=""
    fc_type=""
    fc_subtype=""
}
' "$input_file"

echo "Extraction complete → output.txt"
