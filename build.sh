#!/bin/bash

# Capture arguments
APP=${1%/}
FILENAME=$2
VOLNAME=$3
BACKGROUND=$4
VOLICON=$5

# Universal settings
WINDOWSIZE='600 400'
ICONSIZE='100'
APPDROPLINK='440 260'
ICONPOS='145 260'
TEXTSIZE='11'

function display_usage {
	echo "Usage: $0 <source.app> <target.dmg> <title> <background.png> <volicon.icns>"
	echo ""
	echo "source.app is a macOS Application"
	echo "target.dmg is the file to be created"
	echo "title is the title of the volume to be created"
	echo "background.png (optional) is a 600x400 pixel image file to be used as the window background"
	echo "volicon.icns (optional) is an icon to be used for the mounted volume"
	exit
}

# Validate arguments
if [ "$APP" = "" -o "$FILENAME" = "" -o "$VOLNAME" = "" ]; then
	display_usage
fi

# Install create-dmg if necessary
if [ ! -d create-dmg ]; then
	if [ "`which git`" != "" ]; then
		git clone https://github.com/andreyvit/create-dmg.git
	else
		echo "Git is not found. Quitting."
		exit
	fi
fi

# Confirm that specified files exist
if [ ! -d $APP ]; then
	echo "The App seems to be missing."
	exit
fi

# Remove existing DMG if it exists
if [ -e "$FILENAME" ]; then
	if [ "$(hdiutil info | grep $FILENAME)" = "" ]; then
		rm "$FILENAME"
	else
		echo "Volume is mounted. Exiting."
		exit
	fi
fi

# Build command arguments
OPTIONS=" --window-size $WINDOWSIZE \
 --volname $VOLNAME \
 --text-size $TEXTSIZE \
 --app-drop-link $APPDROPLINK \
 --icon-size $ICONSIZE \
 --icon $APP $ICONPOS"

if [ -f "$BACKGROUND" ]; then
	OPTIONS="$OPTIONS --background $BACKGROUND"
fi
if [ -f "$VOLICON" ]; then
	OPTIONS="$OPTIONS --volicon $VOLICON"
fi

# Execute
create-dmg/create-dmg $OPTIONS $FILENAME $APP



#  --volname name
#      set volume name (displayed in the Finder sidebar and window title)
#  --volicon icon.icns
#      set volume icon
#  --background pic.png
#      set folder background image (provide png, gif, jpg)
#  --window-pos x y
#      set position the folder window
#  --window-size width height
#      set size of the folder window
#  --text-size text_size
#      set window text size (10-16)
#  --icon-size icon_size
#      set window icons size (up to 128)
#  --icon file_name x y
#      set position of the file's icon
#  --hide-extension file_name
#      hide the extension of file
#  --custom-icon file_name custom_icon_or_sample_file x y
#      set position and custom icon
#  --app-drop-link x y
#      make a drop link to Applications, at location x,y
#  --eula eula_file
#      attach a license file to the dmg
#  --no-internet-enable
#      disable automatic mount&copy
