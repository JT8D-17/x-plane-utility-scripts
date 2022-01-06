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
echo "Checking tile: '$tile'" >> $logfile
tilename=
tername=
# Check if the "Earth nav data" folder is present
if [ -d "$tilepath/$tile/Earth nav data" ]; then
    if [[ ! -n $(find "$tilepath/$tile/Earth nav data" -name "*.dsf") ]]; then
        echo "'$tile/Earth nav data' does not contain a .dsf file!"
        echo "'$tile/Earth nav data' does not contain a .dsf file!" >> $logfile
    fi
else
    echo "'$tile' does not have a 'Earth nav data' folder!"
    echo "'$tile' does not have a 'Earth nav data' folder!" >> $logfile
fi
# Check if the "terrain" and "textures" folders are present, then check TER file to DDS file matching
if [ -d "$tilepath/$tile/terrain" ] && [ -d "$tilepath/$tile/textures" ]; then
    if [[ -n $(find "$tilepath/$tile/terrain" -name "*.ter") ]]; then
        find "$tilepath/$tile/terrain" -name "*.ter" | while read file; do
            tilename=${file##*zOrtho4XP_}
            tilename=${tilename%/terrain*}
            tername=${file##*/terrain/}
            texpath=$(grep -F 'BASE_TEX' $file)
            texpath=${texpath##*..}
            texpathshort=${texpath##*/textures/}
            # Check if the DDS files referenced by the TER files are present
            if [ ! -f "$tilepath/$tile/$texpath" ]; then
                # echo "$tilename/$tername: $texpathshort not found!" | tee -a $logfile
                echo "'$tilename/$tername': $texpathshort not found!"
                echo "'$tilename/$tername': $texpathshort not found!" >> $logfile
            fi
        done
    else
        echo "'$tile/terrain' does not contain any .ter files!"
        echo "'$tile/terrain' does not contain any .ter files!" >> $logfile
    fi
else
    # Notify if no terrain folder is present
    if [ ! -d "$tilepath/$tile/terrain" ]; then
    echo "'$tile' does not have a 'terrain' folder!"
    echo "'$tile' does not have a 'terrain' folder!" >> $logfile
    fi
    # Complain if no textures folder is present
    if [ ! -d "$tilepath/$tile/textures" ]; then
    echo "'$tile' does not have a 'textures' folder!"
    echo "'$tile' does not have a 'textures' folder!" >> $logfile
    fi
fi
}

function folderloop(){
    #echo "Ortho folder is: $path" | tee -a $logfile
    echo "Ortho folder is: $path"
    echo "Ortho folder is: $path" >> $logfile
    echo "Checking Ortho tile integrity, stand by..."
    find -L $path -maxdepth 2 -name "zOrtho4XP_*" -type d ! -type l -printf '%P\0' | while read -d $'\0' folder; do
        #echo $path/$folder
        checktile "$path" "$folder"
	done
	echo "All ortho tiles checked" >> $logfile
	echo "Done. Results saved in: $logfile"
}

preparelog
folderloop
