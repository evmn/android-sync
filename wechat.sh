#/bin/bash
#
# Put this file to ~/bin/ dir, so you can pull wechat file from any directory
#
declare -a remote_dirs=("sdcard/tencent/MicroMsg/Download/")

bak=wx_$(date +"%Y%m%d")
for dir in "${remote_dirs[@]}"
do
#       only pull files downloaded in 30 minutes
	adb shell find "$dir" -type f -type f -cmin -30 >> $bak
done

#cp $bak bak
sed -i '/\/\./d' $bak

while IFS= read -r remote
do
#	local=$(echo "$remote" | awk -F"/" '{OFS="/"; $1=$NF="";  print}' | sed 's/^\///')

#	echo "adb pull \"$remote\" \"$local\""
#	echo "adb pull \"$remote\" \"$local\"" | bash
	echo "adb pull \"$remote\" ./"
	echo "adb pull \"$remote\" ./" | bash

#	echo "adb shell rm \"$remote\""
#	echo "adb shell rm \"$remote\"" | bash
done < $bak
