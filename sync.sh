#/bin/bash

backup=backup_$(date +"%Y%m%d")
# Add remote directory to the following array
declare -a remote_dirs=("sdcard/inshot/"
						"sdcard/DCIM/"
						"sdcard/Pictures/")

for dir in "${remote_dirs[@]}"
do
	#adb shell du -a "$dir" | awk '/\.(png|PNG|jpg|JPG|mp4|MP4)$/{print $2}' >> $backup
	adb shell find "$dir" -type f \( -iname "*.mp4" -or -iname "*.jpg" -or -iname "*.png" \) >> $backup
done

#cp $backup bak
# Don't sync hidden folder
sed -i '/\/\./d' $backup

while IFS= read -r remote
do
	# local directory structure is the same as remote directory structure
	local=$(echo "$remote" | awk -F"/" '{OFS="/"; $1=$NF="";  print}' | sed 's/^\///')
	echo "src: $remote"
	echo "adb pull \"$remote\" \"$local\"" | bash
	echo "adb shell rm \"$remote\"" | bash
done < $backup
