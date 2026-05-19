#! /bin/bash
#
# X-Plane 12 Installation - Automated script by BK
#
# README: https://github.com/JT8D-17/x-plane-utility-scripts/Benchmarking/readme.md
#
# LICENSED UNDER EUPL v1.2: https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md
#
# Configuration
clear

current_folder=$(pwd -P)
parent_folder="$(dirname "$current_folder")/X-Plane_12_Common"

# FOLDERS
custom_scenery=(
Aerosoft\ -\ LFMN\ Nice\ Cote\ d\ Azur\ X
Aerosoft\ -\ LPFR\ Faro
X-Plane\ Airports\ -\ EGPR\ Barra
X-Plane\ Airports\ -\ KBTV\ Burlington
X-Plane\ Airports\ -\ KJRB\ Downtown\ Manhattan\ Heliport
X-Plane\ Airports\ -\ LSEZ\ Zermatt\ Heliport
X-Plane\ Airports\ -\ TFFJ\ St\ Barthelemy
X-Plane\ Airports\ -\ TNCS\ Juancho\ E\ Yrausquin
X-Plane\ Landmarks\ -\ Berlin\ and\ Frankfurt
X-Plane\ Landmarks\ -\ Budapest
X-Plane\ Landmarks\ -\ Chicago
X-Plane\ Landmarks\ -\ Dubai
X-Plane\ Landmarks\ -\ Las\ Vegas
X-Plane\ Landmarks\ -\ London
X-Plane\ Landmarks\ -\ Los\ Angeles
X-Plane\ Landmarks\ -\ New\ York
X-Plane\ Landmarks\ -\ Paris
X-Plane\ Landmarks\ -\ Portland
X-Plane\ Landmarks\ -\ Rio\ De\ Janeiro
X-Plane\ Landmarks\ -\ Saint\ Louis
X-Plane\ Landmarks\ -\ Salzburg
X-Plane\ Landmarks\ -\ San\ Francisco
X-Plane\ Landmarks\ -\ Sydney
X-Plane\ Landmarks\ -\ Washington\ DC
)

common_folders=(
Aircraft/Laminar\ Research
Airfoils
Custom\ Data
Global\ Scenery/Global\ Airports
Global\ Scenery/X-Plane\ 12\ Demo\ Areas
Global\ Scenery/X-Plane\ 12\ Global\ Scenery
Instructions
Resources/bitmaps
Resources/default\ data
Resources/default\ scenery
Resources/dlls
Resources/effects
Resources/fonts
Resources/geoids
Resources/joystick\ configs
Resources/keyboard\ presets
Resources/manipulators
Resources/map\ data
Resources/menus
Resources/sounds
Resources/text
Resources/timezones
Resources/tutorials
Resources/vr
Resources/wizards
Support
Weapons
)

# SCRIPT
# Function: Pause
function pause(){
   read -p "$*"
}

controlsdir="$parent_folder/0_Control_Profiles"
fmsplansdir="$parent_folder/0_FMS_Plans"
addonaircraftdir="$parent_folder/AddOn_Aircraft"
addonscenerydir="$parent_folder/AddOn_Sceneries"
addonpluginsdir="$parent_folder/AddOn_Plugins"

function local_dirs(){
	if [ ! -h "$parent_folder" ]; then 
		mkdir "$parent_folder"
		echo "DONE: $parent_folder";
	fi
	if [ ! -h "$parent_folder" ]; then
		mkdir "$parent_folder"
		echo "DONE: $parent_folder";
	fi
	if [ ! -h "$addonaircraftdir" ]; then 
		mkdir "$addonaircraftdir"
		echo "DONE: $addonaircraftdir";
	fi
    if [ ! -h "$addonscenerydir" ]; then 
		mkdir "$addonscenerydir"
		echo "DONE: $addonscenerydir";
	fi
    if [ ! -h "$addonpluginsdir" ]; then
		mkdir "$addonpluginsdir"
		echo "DONE: $addonpluginsdir";
	fi
	if [ ! -h "$controlsdir" ]; then 
		mkdir "$controlsdir"
		echo "DONE: $controlsdir";
	fi
	if [ ! -h "$fmsplansdir" ]; then
		mkdir "$fmsplansdir"
		echo "DONE: $fmsplansdir";
	fi
	if [ ! -h "$PWD/Aircraft" ]; then 
		mkdir "$PWD/Aircraft"
		echo "DONE: $PWD/Aircraft";
	fi
	if [ ! -h "$parent_folder/Aircraft" ]; then
		mkdir "$parent_folder/Aircraft"
		echo "DONE: $parent_folder/Aircraft";
	fi
	if [ ! -h "$parent_folder/Custom Scenery" ]; then
		mkdir "$parent_folder/Custom Scenery"
		echo "DONE: $parent_folder/Custom Scenery";
	fi
	if [ ! -h "$PWD/Global Scenery" ]; then
		mkdir "$PWD/Global Scenery"
		echo "DONE: $PWD/Global Scenery";
	fi
	if [ ! -h "$parent_folder/Global Scenery" ]; then
		mkdir "$parent_folder/Global Scenery"
		echo "DONE: $parent_folder/Global Scenery";
	fi
	if [ ! -h "$PWD/Resources" ]; then 
		mkdir "$PWD/Resources"
		echo "DONE: $PWD/Resources";
	fi
	if [ ! -h "$parent_folder/Resources" ]; then
		mkdir "$parent_folder/Resources"
		echo "DONE: $parent_folder/Resources";
	fi
	if [ ! -h "$PWD/Resources/plugins" ]; then 
		mkdir "$PWD/Resources/plugins"
		echo "DONE: $PWD/Resources/plugins";
	fi
	if [ ! -h "$PWD/Output" ]; then 
		mkdir "$PWD/Output"
		echo "DONE: $PWD/Output";
	fi
	if [ ! -h "$PWD/Output/preferences" ]; then 
		mkdir "$PWD/Output/preferences"
		echo "DONE: $PWD/Output/preferences";
	fi
	if [ ! -h "$PWD/Output/preferences/control profiles" ]; then
		ln -s "$controlsdir" "$PWD/Output/preferences/control profiles"
		echo "LINKED: Output/preferences/control profiles";
	fi
	if [ ! -h "$PWD/Output/FMS plans" ]; then
		ln -s "$fmsplansdir" "$PWD/Output/FMS plans"
		echo "LINKED: Output/FMS plans";
	fi
	if [ ! -h "$PWD/Aircraft/AddOn_Aircraft" ]; then
		ln -s "$addonaircraftdir" "$PWD/Aircraft/AddOn_Aircraft"
		echo "LINKED: Aircraft/AddOn_Aircraft";
	fi
	pause "Press enter to continue... "
}

function check_customscenery(){
	if [ ! -h "$PWD/Custom Scenery" ]; then
		mkdir "$PWD/Custom Scenery"
		echo "DONE: $PWD/Custom Scenery";
	fi
}

function construct_folders(){
	clear
	array=$1'[@]'
	for folder in "${!array}"; do 
		if [ ! -h "$parent_folder/$folder" ]; then
			mkdir "$parent_folder/$folder"
			echo "DONE: $parent_folder/$folder";
		fi
		if [ ! -h "$PWD/$folder" ]; then 
			ln -s "$parent_folder/$folder" "$PWD/$folder"
			echo "LINKED: $folder";
			#pause "Press enter to continue... "
		fi
	done
	check_customscenery
	pause "Press enter to continue... "
}

function add_path(){
	if [ ! -h "$HOME/.x-plane" ]; then 
		mkdir "$HOME/.x-plane"
	else
		echo "$HOME/.x-plane already exists!";
	fi
	#echo "" >> "$HOME/.x-plane/x-plane_install_12.txt"
	echo "$PWD/" >> "$HOME/.x-plane/x-plane_install_12.txt"
	echo "X-Plane 12 install path added to installer location file.";
	#pause "Press enter to continue... "
}

function link_defaults_to_local(){
	clear
	
	check_customscenery
	
	array=$1'[@]'
	for folder in "${!array}"; do 
		if [ ! -h "$parent_folder/Custom Scenery/$folder" ]; then
			mkdir "$parent_folder/Custom Scenery/$folder"
			echo "DONE: $parent_folder/Custom Scenery/$folder";
		fi
		if [ ! -h "$PWD/Custom Scenery/$folder" ]; then 
			ln -s "$parent_folder/Custom Scenery/$folder" "$PWD/Custom Scenery/$folder"
			echo "LINKED: $folder";
		fi
	done
	
	echo "DONE: Linking Default Custom Scenery Folders To Local Custom Scenery Folder"
	pause "Press enter to continue... "
	
	menu "main"
}

function link_addons_to_local(){
    clear
	
	check_customscenery
	
	find $addonscenerydir -maxdepth 1 -type d ! -type l -printf '%P\0' | while read -d $'\0' folder; do
		if [ ! $folder=="" ] && [ ! -h "$PWD/Custom Scenery/$folder" ]; then
			ln -s "$addonscenerydir/$folder" "$current_folder/Custom Scenery/$folder"
			echo "LINKED: $addonscenerydir/$folder";
		fi
	done
	
	# Cleanup
	if [ -L "$PWD/Custom Scenery/AddOn_Sceneries" ]; then
		rm "$PWD/Custom Scenery/AddOn_Sceneries"
	fi
	
	echo "DONE: Linking Add-On Scenery Folders To Local Custom Scenery Folder"
	pause "Press enter to continue... "
	
	menu "main"
}

function link_defaults_to_addonscenery(){
	clear

	array=$1'[@]'
	for folder in "${!array}"; do 
		if [ ! -h "$parent_folder/Custom Scenery/$folder" ]; then
			mkdir "$parent_folder/Custom Scenery/$folder"
			echo "DONE: $parent_folder/Custom Scenery/$folder";
		fi
		if [ ! -h "$addonscenerydir/$folder" ]; then 
			ln -s "$parent_folder/Custom Scenery/$folder" "$addonscenerydir/$folder"
			echo "LINKED: $parent_folder/Custom Scenery/$folder";
		fi
	done
	
	echo "DONE: Linking Default Custom Scenery Folders To Add-On Scenery Folder"
	pause "Press enter to continue... "
	
	menu "main"
}

function link_addonscenery_to_local(){
	clear
	
	if [ ! -h "$PWD/Custom Scenery" ]; then 
		ln -s "$addonscenerydir" "$PWD/Custom Scenery"
		echo "LINKED: $addonscenerydir";
	fi
	
	echo "DONE: Linking Entire Add-On Scenery Folder As Local Custom Scenery Folder"
	pause "Press enter to continue... "
	
	menu "main"
}

function link_default_to_local(){
	clear
	
	if [ ! -h "$PWD/Custom Scenery" ]; then 
		ln -s "$parent_folder/Custom Scenery" "$PWD/Custom Scenery"
		echo "LINKED: $parent_folder/Custom Scenery";
	fi
	
	echo "DONE: Linking Default Custom Scenery Folder As Local Custom Scenery Folder"
	pause "Press enter to continue... "
	
	menu "main"
}

function link_plugins_to_local(){
    clear

	find $addonpluginsdir -maxdepth 1 -type d ! -type l -printf '%P\0' | while read -d $'\0' folder; do
		if [ ! -h "$PWD/Resources/plugins/$folder" ] && [ ! -d "$PWD/Resources/plugins/$folder" ]; then
			ln -s "$addonpluginsdir/$folder" "$current_folder/Resources/plugins/$folder"
			echo "LINKED: $addonpluginsdir/$folder";
		fi
	done

	find $addonpluginsdir -maxdepth 1 -type f ! -type l -printf '%P\0' | while read -d $'\0' file; do
		if [ ! -h "$PWD/Resources/plugins/$file" ]; then
			ln -s "$addonpluginsdir/$file" "$current_folder/Resources/plugins/$file"
			echo "LINKED: $addonpluginsdir/$file";
		fi
	done

	# Cleanup
	if [ -L "$PWD/Resources/plugins/AddOn_Plugins" ]; then
		rm "$PWD/Resources/plugins/AddOn_Plugins"
	fi

	pause "Press enter to continue... "

	menu "main"
}

function menu(){

if [ $1 == "main" ]; then
	clear
	echo "X-Plane 12 Installer"
	echo " "
	echo "X-Plane 12 base files: $parent_folder "
	echo "X-Plane 12 control profile folder: $controlsdir "
	echo " "
	echo "1) Install X-Plane 12 "
	echo " "
	echo "2) Custom Scenery Linking "
	echo " "
	echo "3) Link Third Party Plugins "
	echo " "
	echo "4) Exit "
	echo " "
	echo "Choice [1-4]:"
	echo " "
	# Read choice
	read case;
	# Choices
	case $case in

	 1) local_dirs
		construct_folders "common_folders"
		add_path
		menu "customscenery"
		;;
	 2) menu "customscenery"
		;;
	 3) link_plugins_to_local
		;;
	 4) clear
		exit
	 esac
fi
if [ $1 == "customscenery" ]; then
	clear
	echo "Pick an option for the Custom Scenery folder"
	echo " "
	echo "1) Link default folders individually to local folder"
	echo " "
	echo "2) Link add-on folders individually to local folder"
	echo " "
	echo "3) Link default folders individually to add-on folder"
	echo " "
	echo "4) Link add-on folder to local folder"
	echo " "
	echo "5) Link default folder to local folder"
	echo " "
	echo "6) Return to main menu"
	echo " "
	echo "Choice [1-6]:"
	echo " "
	read case;
	case $case in
	
		1) 	link_defaults_to_local "custom_scenery"
			;;
		2) 	link_addons_to_local
			;;
		3) 	link_defaults_to_addonscenery "custom_scenery"
			;;
		4) 	link_addonscenery_to_local
			;;
		5)	link_default_to_local
			;;
		6) 	menu "main"
			;;
	esac
fi
}


##
# Programs
##

menu "main"

#echo " "
#pause "Press enter to continue... "
