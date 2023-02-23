#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <sam@snwh.org>
#   Peter Cornelis <poltertec@gmail.com>
#
# Description:
#   An installation bash script for EvoPop GTK Theme
#
# Legal Stuff:
#
# This file is part of the EvoPop GTK Theme and is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; version 3.
#
# This file is part of the EvoPop GTK Theme and is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/lgpl-3.0.txt>

clear
echo '#-----------------------------------------#'
echo '#     EvoPop GTK Theme Install Script     #'
echo '#-----------------------------------------#'


show_question() {
echo -e "\033[1;34m$@\033[0m"
}

show_dir() {
echo -e "\033[1;32m$@\033[0m"
}

show_error() {
echo -e "\033[1;31m$@\033[0m"
}

function _continue {
echo
show_question '\tDo you want to continue? (Y)es, (N)o : ' 
echo
read INPUT
case $INPUT in
	[Yy]* ) main;;
    [Nn]* ) exit 99;;
    * ) echo; echo "Sorry, try again."; _continue;;
esac
}

function main {

BRANCH=$(basename $(git symbolic-ref HEAD 2>/dev/null))
# .local/share/themes
	TARGET=$(basename $(pwd))
	if [ "$BRANCH" != "master" ]; then
		TARGET=$TARGET"-"$BRANCH
	fi
if [ "$UID" -eq "$ROOT_UID" ]; then
	if [ -d /usr/share/themes/$TARGET ]; then
		echo
		show_question '\tFound an existing installation. Replace it? (Y)es, (N)o : '
		echo
		read INPUT
		case $INPUT in
			[Yy]* ) rm -Rf /usr/share/themes/Snow 2>/dev/null;;
			[Nn]* );;
		    * ) clear; show_error '\tSorry, try again.'; main;;
		esac
	fi
	echo "Installing..."
	cp -R ./EvoPop/ /usr/share/themes/
	chmod -R 755 /usr/share/themes/EvoPop
	echo "Installation complete!"
	echo "You will have to set your theme manually."
	end
elif [ "$UID" -ne "$ROOT_UID" ]; then
	if [ -d $HOME/github/gnome-look/$TARGET ]; then
		echo
		show_question '\tFound an existing installation. Replace it? (Y)es, (N)o : '
		echo
		read INPUT
		case $INPUT in
			[Yy]* ) rm -Rf "$HOME/github/gnome-look/Snow" 2>/dev/null;;
			[Nn]* );;
		    * ) clear; show_error '\tSorry, try again.'; main;;
		esac
	fi
	echo "Installing..."
		install -d $HOME/github/gnome-look/$TARGET
	cp -R ./assets/ $HOME/github/gnome-look/$TARGET
	cp -R ./unity/ $HOME/github/gnome-look/$TARGET
	cp -R ./gtk-3.0/ $HOME/github/gnome-look/$TARGET
    #gnome-shell
    mkdir -p  $HOME/github/gnome-look/$TARGET/gnome-shell
    cp -R ./gnome-shell/assets $HOME/github/gnome-look/$TARGET/gnome-shell
    cp  ./gnome-shell/gnome-shell.css $HOME/github/gnome-look/$TARGET/gnome-shell
    #gtk2
    mkdir -p  $HOME/github/gnome-look/$TARGET/gtk-2.0 
    cp -R ./gtk-2.0/assets $HOME/github/gnome-look/$TARGET/gtk-2.0
    cp -R ./gtk-2.0/apps $HOME/github/gnome-look/$TARGET/gtk-2.0
    cp  ./gtk-2.0/gtkrc $HOME/github/gnome-look/$TARGET/gtk-2.0 
    cp  ./gtk-2.0/main.rc $HOME/github/gnome-look/$TARGET/gtk-2.0
    #gtk3
    mkdir -p  $HOME/github/gnome-look/$TARGET/gtk-3.20 
    cp  ./gtk-3.20/gtk.css $HOME/github/gnome-look/$TARGET/gtk-3.20  
    cp  ./gtk-3.20/gtk-dark.css $HOME/github/gnome-look/$TARGET/gtk-3.20  
    
    #xfwm
    mkdir -p  $HOME/github/gnome-look/$TARGET/xfwm4
    cp  ./xfwm4/*.png $HOME/github/gnome-look/$TARGET/xfwm4  
    cp  ./xfwm4/themerc $HOME/github/gnome-look/$TARGET/xfwm4

    #metacity
    mkdir -p  $HOME/github/gnome-look/$TARGET/metacity-1
    cp  ./metacity-1/* $HOME/github/gnome-look/$TARGET/metacity-1  

	#cinnamon
    mkdir -p  $HOME/github/gnome-look/$TARGET/cinnamon
    cp -r ./cinnamon/* $HOME/github/gnome-look/$TARGET/cinnamon  
   

    cp  ./index.theme $HOME/github/gnome-look/$TARGET
    cp  ./LICENSE $HOME/github/gnome-look/$TARGET
    cp  ./README.md $HOME/github/gnome-look/$TARGET


	tar -cf ../gnome-look/$TARGET.tar.xz -C ../gnome-look  $TARGET --xz

	# .themes
#	install -d $HOME/.themes
#	cp -R ./EvoPop/ $HOME/.themes/
	echo "Installation complete!"
	#_set
fi
}



function _set {
echo
show_question '\tDo you want to set EvoPop as desktop theme? (Y)es, (N)o : '
echo
read INPUT
case $INPUT in
	[Yy]* ) settheme;;
    [Nn]* ) end;;
    * ) echo; show_error "\aUh oh, invalid response. Please retry."; _set;;
esac
}

function settheme {
echo "Setting EvoPop as desktop GTK theme..."
gsettings reset org.gnome.desktop.interface gtk-theme
gsettings reset org.gnome.desktop.wm.preferences theme
gsettings set org.gnome.desktop.interface gtk-theme "EvoPop"
gsettings set org.gnome.desktop.wm.preferences theme "EvoPop"
echo "Done."
setthemegnome
}

function setthemegnome {
if [ -d /usr/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/ ]; then
	echo
	show_question '\tWould you like to use EvoPop as your GNOME Shell theme? (Y)es, (N)o : '
	echo
	read INPUT
	case $INPUT in
		[Yy]* ) gsettings _set org.gnome.shell.extensions.user-theme name "EvoPop";;
	    [Nn]* ) end;;
	    * ) echo; show_error "\aUh oh, invalid response. Please retry."; _set;;
	esac
	end
else
	end
fi
}

function end {
	echo "Exiting"
	exit 0
}


ROOT_UID=0
if [ "$UID" -ne "$ROOT_UID" ]; then
	echo
	echo "EvoPop GTK Theme will be installed in:"
	echo
	show_dir '\t$HOME/.local/share/themes'
	echo
	echo "To make them available to all users, run this script as root."
	_continue
else
	echo
	echo "EvoPop GTK Theme will be installed in:"
	echo
	show_dir '\t/usr/share/themes'
	echo
	echo "It will be available to all users."
	_continue
fi
