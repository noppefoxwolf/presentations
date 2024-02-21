#!/bin/bash

# Loop through all image files in the directory
for input_image in *.{png,jpeg,jpg}; do
    output_image="${input_image%.*}.png"  # Change the extension to png
    width=$(identify -format "%w" $input_image)
    height=$(identify -format "%h" $input_image)
    min_side=$(($width < $height ? $width : $height))
    round_radius=$(($min_side / 10))  # 10% of the shorter side

    echo "Processing $input_image - Width: $width Height: $height Round Radius: $round_radius"
    
    convert $input_image \
    \( -size ${width}x${height} xc:none -fill white -draw "roundrectangle 0,0 ${width},${height} ${round_radius},${round_radius}" \) \
    -alpha off -compose CopyOpacity -composite $output_image
done
