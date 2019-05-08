#/bin/bash

declare -a remote_dirs=("sdcard/inshot/"
			"sdcard/DCIM/"
			"sdcard/Pictures/")

bak=bak_$(date +"%Y%m%d")
for dir in "${remote_dirs[@]}"
do
#	#adb shell du -a "$dir" | awk '/\.(png|PNG|jpg|JPG|mp4|MP4)$/{print $2}' >> $bak
	adb shell find "$dir" -type f \( -iname "*.mp4" -or -iname "*.jpg" -or -iname "*.png" \) >> $bak
done

#cp $bak bak
sed -i '/\/\./d' $bak

while IFS= read -r remote
do
	local=$(echo "$remote" | awk -F"/" '{OFS="/"; $1=$NF="";  print}' | sed 's/^\///')
	echo "adb pull \"$remote\" \"$local\""
	echo "adb pull \"$remote\" \"$local\"" | bash
	echo "adb shell rm \"$remote\""
	echo "adb shell rm \"$remote\"" | bash
done < $bak
