#!/bin/bash

# Loop through all image files in the directory
for input_image in *.{png,jpeg,jpg}; do
    width=$(identify -format "%w" $input_image)
    height=$(identify -format "%h" $input_image)
    min_side=$(($width < $height ? $width : $height))
    round_radius=$(($min_side / 10))  # 20% of the shorter side

    echo "Processing $input_image - Width: $width Height: $height Round Radius: $round_radius"
    
    convert $input_image \
    \( -size ${width}x${height} xc:none -fill white -draw "roundrectangle 0,0 ${width},${height} ${round_radius},${round_radius}" \) \
    -alpha off -compose CopyOpacity -composite $input_image
done