#! /bin/bash

# Authors: BK and hdrie
# Created in May 2024

# LICENSED UNDER EUPL v1.2: https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md

# For a comprehensive description of features and usage please refer to the Readme.md accompanying this script.

# Interactive script to automatically apply a performance tweak/workaround for xlua aircraft scripts.
# It's required to be run from the root folder of your X-Plane 12 installation.
# This script's main purpose is adding the line "jit.off()" to the top of every .lua script specified in a list of file paths.
# This list can be automatically generated and customized by the user.
# For this we use two whitelists, containing: 
# 1) One path per aircraft (acft-using-xlua.txt)
# 2) One path per .lua file (xlua-scripts.txt, can be automatically derived from above aircraft list)

# The script takes one (optional) argument: The path to a scripts whitelist. It will use xlua-scripts.txt by default.
# You could make a copy of the file after initialization and customization, rename it and pass it to this script explicitly.

# default file paths. Do not 
acft_whitelist_file="./Z_fix_lua-jit_files/acft-using-xlua.txt"
scripts_file="./Z_fix_lua-jit_files/xlua-scripts.txt"

# create files dir
function init_(){
    if [ ! -d ./Z_fix_lua-jit_files ]; then
        mkdir Z_fix_lua-jit_files
        echo "Created ./Z_fix_lua-jit_files/"
    fi
}

# Function: Pause
function pause(){
    echo "Press any key to continue..."
    read -p "$*"
}

# Function: Check if an argument was supplied and if the associated file exists
function check_arguments(){
if [ "$1" != "" ]; then
    scripts_file=$1
fi
echo " "
echo "Using $scripts_file as input."
echo " "
# Check if the file exists
if [ -e ./$scripts_file ]; then
  echo "Found $scripts_file."
else
  echo "$scripts_file not found. Provide an alternative file or generate xlua-scripts.txt"
fi
echo " "
}
    

# Function: Apply jit.off()
function Apply(){
    clear
    echo " "
    echo "This will add jit.off() to the top of every script file listed in $scripts_file"
    echo "REVIEW $scripts_file NOW"
    echo "AND ONLY CONTINUE WHEN READY!"
    echo " "
    echo "Continue? (y/n)"
    # Read choice
    read case;
    # Choices
    case $case in

    y) while read p; do sed -i '1i jit.off()' "$p"; done <$scripts_file
       echo " "
       echo "Done."
       echo " "
       pause
       Menu
        ;;
    n) Menu
    
    esac
}

# Function: Backup scripts for aircraft in whitelist
function Backup_Scripts(){
    clear
    echo " "
    echo "Backing up scripts to scripts_backup.tar (for aircraft in whitelist)"
    echo "The backup can be found in *aircraft-folder*/plugins/xlua/"
    echo " "
    echo "Continue? (y/n)"
    # Read choice
    read case;
    # Choices
    case $case in

    y) while read p; do (cd "$p" && cd .. && tar -c -f scripts_backup.tar scripts) ; done < $acft_whitelist_file
       echo " "
       echo "Done."
       echo " "
       pause
       Menu
        ;;
    n) Menu
    
    esac
}

# Function: Restore scripts for aircraft in whitelist
function Restore_Scripts(){
    clear
    echo " "
    echo "Restoring scripts from scripts_backup.tar (for aircraft in whitelist)"
    echo " "
    echo "Continue? (y/n)"
    # Read choice
    read case;
    # Choices
    case $case in

    y) while read p; do (cd "$p" && cd .. && tar -x -f scripts_backup.tar --overwrite && rm scripts_backup.tar) ; done < $acft_whitelist_file
       echo " "
       echo "Done."
       echo " "
       pause
       Menu
        ;;
    n) Menu
    
    esac
}

# Function: Find all aircraft that use xlua scripts, store the path to their xlua/scripts folder
function Find_Aircraft(){
    clear
    echo " "
    echo "Dumping list of aircraft using xlua scripts to acft-using-xlua.txt (Whitelist)."
    echo "This will overwrite any existing whitelist."
    echo "It's recommended that you customize the file afterwards"
    echo " "
    echo "Continue? (y/n)"
    # Read choice
    read case;
    # Choices
    case $case in

    y) find ./Aircraft/*/ -type f -regex ".*/xlua/scripts/.*\.lua" | sed -n 's/\(^.*\/plugins\/xlua\/scripts\)\/.*/\1/Ip' | uniq > ./Z_fix_lua-jit_files/acft-using-xlua.txt
       echo " "
       echo "Done."
       echo " "
       pause
       Menu
        ;;
    n) Menu
    
    esac
}

# Function: Find all xlua scripts for aircraft in whitelist (aircraft-using-xlua.txt)
function Find_Files(){
    clear
    echo " "
    echo "Dumping list of xlua scripts to xlua-scripts.txt."
    echo "This will overwrite any existing xlua-scripts.txt."
    echo "Review the file afterwards and remove any scripts that you don't need/want tweaked"
    echo " "
    echo "Continue? (y/n)"
    # Read choice
    read case;
    # Choices
    case $case in

    y) if [ -e "./Z_fix_lua-jit_files/xlua-scripts.txt" ]; then rm ./Z_fix_lua-jit_files/xlua-scripts.txt; fi
       while read p; do find "$p" -type f -regex ".*\.lua$" >> ./Z_fix_lua-jit_files/xlua-scripts.txt; done  <$acft_whitelist_file
       echo " "
       echo "These are xlua scripts that already have jit.off() set:"
       echo " "
       while read p; do sed -n '/^jit.off()/F' "$p"; done <$scripts_file
       echo " "
       echo "Done."
       echo " "
       pause
       Menu
        ;;
    n) Menu
    
    esac
}

# List files in scripts_file that already have the tweak applied. Does not modify anything.
function List_Tweaked(){
    clear
    echo " "
    echo "These are xlua scripts that currently have jit.off() set:"
    echo " "
    while read p; do sed -n '/^jit.off()/F' "$p"; done <$scripts_file
    echo " "
    echo " "
    pause
    Menu
}

# Function: Remove jit.off()
function Remove(){
    clear
    echo " "
    echo "Removing jit.off() from script files listed in $scripts_file"
    echo " "
    echo "Continue? (y/n)"
    # Read choice
    read case;
    # Choices
    case $case in

    y) while read p; do sed -i '/^jit.off()/d' "$p"; done <$scripts_file
       echo " "
       echo "Done."
       echo " "
       pause
       Menu
        ;;
    n) Menu
    
    esac
}

# Function: Main menu
function Menu(){
    echo "===================================================="
    echo " "
    echo "Switch off LuaJIT for aircraft Lua scripts"
    echo " "
    echo "Applying jit.off() as the first line of a Lua script"
    echo "may improve script performance and lessen the"
    echo "FPS impact of complex aircraft using xlua scripts."
    echo " "
    echo "Working with $scripts_file"
    echo " "
    echo "===================================================="
    echo " "
    echo "1) Create/Reset list of aircraft using xlua scripts (aircraft whitelist)"
    echo " "
    echo "2) Create/Reset whitelist of xlua scripts in xlua-scripts.txt (requires aircraft whitelist)"
    echo " "
    echo "3) Back up scripts for aircraft in whitelist"
    echo " "
    echo "4) Apply jit.off() to the xlua scripts listed in $scripts_file."
    echo " "
    echo "5) Remove jit.off() from the xlua scripts listed in $scripts_file."
    echo " "
    echo "6) List all scripts that currently have jit.off()"
    echo " "
    echo "7) Restore backed up scripts for aircraft in whitelist"
    echo " "
    echo "8) Exit"
    echo " "
    echo "Choice [1-8]:"
    echo " "
    # Read choice
    read case;
    # Choices
    case $case in

    1) Find_Aircraft
        ;;
    2) Find_Files
        ;;
    3) Backup_Scripts
        ;;
    4) Apply
        ;;
    5) Remove
        ;;
    6) List_Tweaked
        ;;
    7) Restore_Scripts
        ;;
    8) clear
        exit
    esac
}

# Call these functions
clear
check_arguments "$1"
init_
Menu
