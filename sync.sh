#/bin/bash

declare -a remote_dirs=("sdcard/inshot/"
			"sdcard/DCIM/"
			"sdcard/Pictures/"
			"sdcard/Download"
			"sdcard/Movies/")

bak=bak_$(date +"%Y%m%d-%H%M%S")
for dir in "${remote_dirs[@]}"
do
#	adb shell du -a "$dir" | awk '/\.(png|PNG|jpg|JPG|mp4|MP4)$/{print $2}' >> $bak
	adb shell find "$dir" -type f -iname "*.mp4" -or -iname "*.jpg" -or -iname "*.png" >> $bak
done

sed -i '/\/\./d' $bak

while IFS= read -r remote
do

	local=$(echo "$remote" | awk -F"/" '{OFS="/"; $1=$NF="";  print}' | sed 's/^\///')
	if [ ! -d "$local" ]; then
		echo "mkdir -p $local"
		echo "mkdir -p $local" | bash
	fi

	media=$(echo "$remote" | awk -F"/" '{OFS="/"; $1="";  print}' | sed 's/^\///')
	if [ ! -f "$media" ]; then
		echo "adb pull \"$remote\" \"$local\""
		echo "adb pull \"$remote\" \"$local\"" | bash
	fi

#	echo "adb shell rm \"$remote\""
#	echo "adb shell rm \"$remote\"" | bash
done < $bak
