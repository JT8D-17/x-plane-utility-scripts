#! /bin/bash
#
# X-Plane Installation - Automated script by BK
#
# README: https://github.com/JT8D-17/x-plane-utility-scripts/Benchmarking/readme.md
#
# LICENSED UNDER EUPL v1.2: https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md
#
# Configuration
clear

parent_folder="/media/Simulators/X-Plane_11"
current_folder="$PWD"

# FOLDERS
folder_names=(
Base_Data
Control_Profiles
AddOn_Airplanes
AddOn_Sceneries
)


custom_scenery=(
Aerosoft\ -\ EDDF\ Frankfurt
Aerosoft\ -\ EDLP\ Paderborn-Lippstadt
Aerosoft\ -\ EGLL\ Heathrow
Aerosoft\ -\ LFMN\ Nice\ Cote\ d\ Azur\ X
Aerosoft\ -\ LFPO\ Paris\ Orly
Aerosoft\ -\ LPFR\ Faro
Global\ Airports
KSEA\ Demo\ Area
LOWI\ Demo\ Area
X-Plane\ Landmarks\ -\ Chicago
X-Plane\ Landmarks\ -\ Dubai
X-Plane\ Landmarks\ -\ Las\ Vegas
X-Plane\ Landmarks\ -\ London
X-Plane\ Landmarks\ -\ New\ York
X-Plane\ Landmarks\ -\ Sydney
X-Plane\ Landmarks\ -\ Washington\ DC
)

common_folders=(
Aircraft
Airfoils
Custom\ Data
Global\ Scenery
Instructions
Resources/bitmaps
Resources/certificates
Resources/default\ data
Resources/default\ scenery
Resources/dlls
Resources/effects
Resources/fonts
Resources/joystick\ configs
Resources/keyboard\ presets
Resources/manipulators
Resources/map\ data
Resources/menus
Resources/sounds
Resources/text
Resources/tutorials
Resources/vr
Resources/wizards
Weapons
)

# SCRIPT
# Function: Pause
function pause(){
   read -p "$*"
}

basedir="$parent_folder/${folder_names[0]}"
controlsdir="$parent_folder/${folder_names[1]}"
addonaircraftdir="$parent_folder/${folder_names[2]}"
addonscenerydir="$parent_folder/${folder_names[3]}"

function local_dirs(){
	if [ ! -h "$parent_folder" ]; then 
		mkdir "$parent_folder"
		echo "CREATED: $parent_folder";
	fi
	if [ ! -h "$basedir" ]; then 
		mkdir "$basedir"
		echo "CREATED: $basedir";
	fi
		if [ ! -h "$addonscenerydir" ]; then 
		mkdir "$addonscenerydir"
		echo "CREATED: $addonscenerydir";
	fi
	if [ ! -h "$controlsdir" ]; then 
		mkdir "$controlsdir"
		echo "CREATED: $controlsdir";
	fi
	if [ ! -h "$PWD/Resources" ]; then 
		mkdir "$PWD/Resources"
		echo "CREATED: $PWD/Resources";
	fi
	if [ ! -h "$basedir/Resources" ]; then 
		mkdir "$basedir/Resources"
		echo "CREATED: $basedir/Resources";
	fi
	if [ ! -h "$PWD/Resources/plugins" ]; then 
		mkdir "$PWD/Resources/plugins"
		echo "CREATED: $PWD/Resources/plugins";
	fi
	if [ ! -h "$PWD/Output" ]; then 
		mkdir "$PWD/Output"
		echo "CREATED: $PWD/Output";
	fi
	if [ ! -h "$PWD/Output/preferences" ]; then 
		mkdir "$PWD/Output/preferences"
		echo "CREATED: $PWD/Output/preferences";
	fi
	if [ ! -h "$PWD/Output/preferences/control profiles" ]; then
		ln -s "$controlsdir" "$PWD/Output/preferences/control profiles"
		echo "LINKED: Output/preferences/control profiles";
	fi
	pause "Press enter to continue... "
}

function construct_folders(){
	clear
	array=$1'[@]'
	for folder in "${!array}"; do 
		if [ ! -h "$basedir/$folder" ]; then
			mkdir "$basedir/$folder"
			echo "CREATED: $basedir/$folder";
		fi
		if [ ! -h "$PWD/$folder" ]; then 
			ln -s "$basedir/$folder" "$PWD/$folder"
			echo "LINKED: $folder";
			pause "Press enter to continue... "
		fi
	done
	pause "Press enter to continue... "
}

function add_path(){
	if [ ! -h "$HOME/.x-plane" ]; then 
		mkdir "$HOME/.x-plane"
	else
		echo "$HOME/.x-plane already exists!";
	fi
	#echo "" >> "$HOME/.x-plane/x-plane_install_11.txt"
	echo "$PWD/" >> "$HOME/.x-plane/x-plane_install_11.txt"
	echo "X-Plane 11 install path added to installer location file.";
	#pause "Press enter to continue... "
}

function check_customscenery(){
	if [ ! -h "$PWD/Custom Scenery" ]; then 
		mkdir "$PWD/Custom Scenery"
		echo "CREATED: $PWD/Custom Scenery";
	fi
}

function link_defaults_to_local(){
	clear
	
	check_customscenery
	
	array=$1'[@]'
	for folder in "${!array}"; do 
		if [ ! -h "$basedir/Custom Scenery/$folder" ]; then
			mkdir "$basedir/Custom Scenery/$folder"
			echo "CREATED: $basedir/Custom Scenery/$folder";
		fi
		if [ ! -h "$PWD/Custom Scenery/$folder" ]; then 
			ln -s "$basedir/Custom Scenery/$folder" "$PWD/Custom Scenery/$folder"
			echo "LINKED: $folder";
		fi
	done
	
	pause "Press enter to continue... "
	
	menu "main"
}

function link_addons_to_local(){
	
	check_customscenery
	
	find $addonscenerydir -maxdepth 1 -type d ! -type l -printf '%P\0' | while read -d $'\0' folder; do
		if [ ! -h "$PWD/Custom Scenery/$folder" ]; then
			ln -s "$addonscenerydir/$folder" "$current_folder/Custom Scenery/$folder"
			echo "LINKED: $addonscenerydir/$folder";
		fi
	done
	
	# Cleanup
	if [ -L "$PWD/Custom Scenery/${folder_names[3]}" ]; then
		rm "$PWD/Custom Scenery/${folder_names[3]}"
	fi
	
	pause "Press enter to continue... "
	
	menu "main"
}

function link_defaults_to_addonscenery(){
	clear

	array=$1'[@]'
	for folder in "${!array}"; do 
		if [ ! -h "$basedir/Custom Scenery/$folder" ]; then
			mkdir "$basedir/Custom Scenery/$folder"
			echo "CREATED: $basedir/Custom Scenery/$folder";
		fi
		if [ ! -h "$addonscenerydir/$folder" ]; then 
			ln -s "$basedir/Custom Scenery/$folder" "$addonscenerydir/$folder"
			echo "LINKED: $basedir/Custom Scenery/$folder";
		fi
	done
	
	pause "Press enter to continue... "
	
	menu "main"
}

function link_addonscenery_to_local(){
	clear
	
	if [ ! -h "$PWD/Custom Scenery" ]; then 
		ln -s "$addonscenerydir" "$PWD/Custom Scenery"
		echo "LINKED: $addonscenerydir";
	fi
	
	pause "Press enter to continue... "
	
	menu "main"
}

function link_default_to_local(){
	clear
	
	if [ ! -h "$PWD/Custom Scenery" ]; then 
		ln -s "$basedir/Custom Scenery" "$PWD/Custom Scenery"
		echo "LINKED: $basedir/Custom Scenery";
	fi
	
	pause "Press enter to continue... "
	
	menu "main"
}



function menu(){

if [ $1 == "main" ]; then
	clear
	echo "X-Plane 11 Installer"
	echo " "
	echo "X-Plane 11 base files: $basedir "
	echo "X-Plane 11 control profile folder: $controlsdir "
	echo " "
	echo "1) Install X-Plane 11 "
	echo " "
	echo "2) Custom Scenery Linking "
	echo " "
	echo "3) Exit "
	echo " "
	echo "Choice [1-3]:"
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

	 3) clear
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
