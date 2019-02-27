#!/usr/bin/env bash

#Title          	:	MacCleaner.sh
#Description	 	:	This script will remove all cached and logs file from MacOS and will upgrade and cleanup brew in case it is installed.
#Author			    :	@Hx66
#Date   		    :	2019/Feb/27
#Version		    :	1.0
#Usage			    :	chmod +x MacCleaner.sh; ./MacCleaner.sh
#============================================================#


#Paths to delete from
declare -a trash=(/Volumes/*/.Trashes ~/.Trash/)
declare -a paths=(
		/private/var/log/asl/*.asl 
		/Library/Logs/DiagnosticReports/*
		/Library/Logs/CrashReporter/*
		/Library/Logs/Adobe/*
		/Library/Caches/*
		/var/log/*.bz2
		~/Library/Application\ Support/Google/Chrome/Default/History*
		~/Library/Application\ Support/Google/Chrome/Default/Cookie*
		~/Library/Application\ Support/Google/Chrome/Default/Thumbnails
		~/Library/Application\ Support/Google/Chrome/Default/Visited\ Links
		~/Library/Application\ Support/Google/Chrome/Default/LOG*
		~/Library/Application\ Support/Google/Chrome/Default/Top\ Sites*
		~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/*
		#Firefox - History, Cache, Logs, Passwords, Auto Complete, Thumbnails, Visited links, Top Sites...
		~/Library/Application\ Support/Firefox/Crash\ Reports/*
		~/Library/Application\ Support/Firefox/Profiles/*.default/cookies*
		~/Library/Application\ Support/Firefox/Profiles/*.default/crashes/
		~/Library/Application\ Support/Firefox/Profiles/*.default/datareporting/
		~/Library/Application\ Support/Firefox/Profiles/*.default/formhistory*
		~/Library/Application\ Support/Firefox/Profiles/*.default/storage/
		~/Library/Application\ Support/Firefox/Profiles/*.default/autofill-profiles.json
		~/Library/Application\ Support/Firefox/Profiles/*.default/weave/
		~/Library/Application\ Support/Firefox/Profiles/*.default/places.sqlite
		~/Library/Application\ Support/Firefox/Profiles/*.default/favicons.sqlite
		~/Library/Application\ Support/Firefox/Profiles/*.default/key4.db
		~/Library/Application\ Support/Firefox/Profiles/*.default/logins.json
		~/Library/Application\ Support/Firefox/Profiles/*.default/permissions.sqlite
		~/Library/Application\ Support/Firefox/Profiles/*.default/search.json.mozlz4
		)
declare -a xcode=(~/Library/Developer/Xcode/DerivedData/* /Library/Developer/Xcode/Archives/* )


# Ask for administrator password
echo 'Please enter your password to grant sudo'
sudo -v

echo 'Empty trash on all mounted volumes'
for t in "${trash[@]}"
do
	sudo rm -rf $t &> /dev/null
done
printf "\e[32m>>[+] Done.\e[m\n"


echo 'Clear System, Browsers, Adobe Logs and cache files...'
for p in "${paths[@]}"
do
	sudo rm -rf "$p" &> /dev/null
done

for x in $(ls ~/Library/Containers/) 
do 
    sudo rm -rf ~/Library/Containers/"$x"/Data/Library/Caches/* &> /dev/null
done
printf "\e[32m>>[+] Done.\e[m\n"


echo 'Cleanup XCode..'
for z in "${xcode[@]}"
do
	sudo rm -rf $z &> /dev/null
done
printf "\e[32m>>[+] Done.\e[m\n"

echo 'Clean Music..'
sudo rm -rf ~/Music/iTunes/iTunes\ Media/* &> /dev/null
printf "\e[32m>>[+] Done.\e[m\n"

# Check if brew is already installed, if yes update and ugrade then cleanup
which -s brew
if [[ $? != 0 ]] ; then
    clear && echo "[++] Everything is cleaned up $(whoami)"

else
    echo 'Update Homebrew...'
	brew update
	echo 'Upgrade && Cleanup Homebrew Cache...'
	brew cleanup --force -s &> /dev/null
	brew cask cleanup &> /dev/null
	brew tap --repair &> /dev/null
	brew upgrade
	printf "\e[32m>>[+] Done.\e[m\n"
fi

clear && echo "[++]Everything is cleaned up $(whoami)"