#/bin/bash

bak=bak_$(date +"%Y%m%d")

adb shell find data/app -name "base.apk" > $bak
#adb shell find data/app -name "base.apk" | cut -d "/" -f 3 | cut -d "-" -f 1

while IFS= read -r remote
do
    local=$(echo "$remote" | cut -d "/" -f 3 | cut -d "-" -f 1)/
    if [ ! -d "$local" ]; then
        echo "mkdir $local"
        echo "mkdir $local" | bash
    fi
    echo "adb pull $remote $local"
    echo "adb pull $remote ${local}base.apk" | bash
done < $bak
