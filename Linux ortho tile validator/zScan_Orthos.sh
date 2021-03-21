#! /bin/bash
##
## Made by BK
## Version 21032021
## Use at your own risk!
## Licensed under the EUPL v1.2
clear

path=$PWD
logfile=$PWD/zOrtho_tile_integrity.txt

function preparelog(){
if [ -f "$logfile" ]; then
    rm $logfile
fi

#echo "Ortho integrity check performed on $(date)" | tee -a $logfile
echo "Ortho integrity check performed on $(date)" >> $logfile
}

function checktile(){
tilepath=$1
#tile=${tilepath##*zOrtho4XP_}
tile=$2
#echo "Checking tile $tile.." | tee -a $logfile
echo "Checking tile $tile.." >> $logfile
tilename=
tername=

find "$tilepath/$tile/terrain" -name "*.ter" | while read file; do
    tilename=${file##*zOrtho4XP_}
    tilename=${tilename%/terrain*}
    tername=${file##*/terrain/}
    texpath=$(grep -F 'BASE_TEX' $file)
    texpath=${texpath##*..}
    texpathshort=${texpath##*/textures/}
    if [ ! -f "$tilepath/$tile/$texpath" ]; then
        # echo "$tilename/$tername: $texpathshort not found!" | tee -a $logfile
        echo "$tilename/$tername: $texpathshort not found!" >> $logfile
    fi
done
}

function folderloop(){
    #echo "Ortho folder is: $path" | tee -a $logfile
    echo "Ortho folder is: $path"
    echo "Ortho folder is: $path" >> $logfile
    echo "Checking Ortho folders for missing texture files, stand by..."
    find $path -maxdepth 1 -name "zOrtho4XP_*" -type d ! -type l -printf '%P\0' | while read -d $'\0' folder; do
        #echo $path/$folder
        checktile "$path" "$folder"
	done
	echo "All ortho tiles checked" >> $logfile
	echo "Done. Results saved in:"
	echo "$logfile"
}

preparelog
folderloop
