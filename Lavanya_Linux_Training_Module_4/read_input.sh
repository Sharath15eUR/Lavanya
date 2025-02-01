#!/bin/bash


if [ $# -ne 1 ]; then
    echo "Give parameter: $0 <input_file>"
    exit 1
fi


INPUT_FILE="$1"
OUTPUT_FILE="output.txt"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file $INPUT_FILE not found."
    exit 1
fi

> "$OUTPUT_FILE"

while IFS= read -r line
do
   
    frame_time=$(echo "$line" | grep -oP '(?<=frame.time":\s")[^"]*')
    
    wlan_fc_type=$(echo "$line" | grep -oP '(?<=wlan.fc.type":\s")[^"]*')
    
    wlan_fc_subtype=$(echo "$line" | grep -oP '(?<=wlan.fc.subtype":\s")[^"]*')

    if [ -n "$frame_time" ] && [ -n "$wlan_fc_type" ] && [ -n "$wlan_fc_subtype" ]; then
        echo "\"frame.time\": \"$frame_time\"," >> "$OUTPUT_FILE"
        echo "\"wlan.fc.type\": \"$wlan_fc_type\"," >> "$OUTPUT_FILE"
        echo "\"wlan.fc.subtype\": \"$wlan_fc_subtype\"," >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"

echo "Processing complete. Output saved to $OUTPUT_FILE."
