# #!/bin/bash

# # Loop through all image files in the directory
# for input_image in *.{png,jpeg,jpg}; do
#     output_image="${input_image%.*}.png"  # Change the extension to png
#     width=$(identify -format "%w" $input_image)
#     height=$(identify -format "%h" $input_image)
#     min_side=$(($width < $height ? $width : $height))
#     round_radius=$(($min_side / 10))  # 10% of the shorter side

#     echo "Processing $input_image - Width: $width Height: $height Round Radius: $round_radius"
    
#     convert $input_image \
#     \( -size ${width}x${height} xc:none -fill white -draw "roundrectangle 0,0 ${width},${height} ${round_radius},${round_radius}" \) \
#     -alpha off -compose CopyOpacity -composite $output_image
# done

#!/bin/bash

# 元画像があるディレクトリと変換後の保存先ディレクトリ
input_dir="."
output_dir="."

# 出力ディレクトリが存在しない場合は作成
if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
fi

# ディレクトリ内のすべての画像ファイルをPNG形式に変換して保存
for file in $input_dir/*.{jpg,jpeg,gif}; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        filename="${filename%.*}"
        convert "$file" "${output_dir}/${filename}.png"
        rm $file
    fi
done
