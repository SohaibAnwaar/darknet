
base_path="/forest_3d_app/"

images_path=$base_path"forest_3d_app/data/dataset/images/"
output_file1=$base_path"darknet/tmp_yolo/train.txt"
output_file2=$base_path"darknet/tmp_yolo/val.txt"

touch "$output_file1"
touch "$output_file2"



files=($(ls "$images_path"))
echo "Total files: ${#files[@]}"
total_files=${#files[@]}
half=$((total_files/ 2))

for ((i=0; i < total_files; i++)); do
    if [ $i -lt $half ]; then
        echo $images_path${files[$i]}
        echo "$images_path${files[$i]}" >> "$output_file1"
    else
        echo "$images_path${files[$i]}" >> "$output_file2"
    fi
done