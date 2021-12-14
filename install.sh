#!/bin/bash


# set program name
program_name="word-generator"


# get current version
version=$(cat ./version)


# load installation header
header="
 __      ____ _ 
 \ \ /\ / / _  |
  \ V  V / (_| |
   \_/\_/ \__, |
           __/ |
          |___/ 
"
echo "$header"
echo ""
echo "Word Generator"
echo "version $version"
echo "https://github.com/pinebase/word-generator"
echo ""

# install writable /var directory 
if [ ! -d /var/lib/word-generator/ ]
then
	mkdir /var/lib/word-generator/
	echo "# created folder: /var/lib/word-generator/"
fi


# install log of generated words
if [ ! -f /var/lib/word-generator/words-raw.txt ]
then
	touch /var/lib/word-generator/words-raw.txt
	echo "# created file: /var/lib/word-generator/words-raw.txt"
fi


# install queue of words to check
if [ ! -f /var/lib/word-generator/words-to-check.txt ]
then
	touch /var/lib/word-generator/words-to-check.txt
	echo "# created file: /var/lib/word-generator/words-to-check.txt"
fi


# install list of checked words
if [ ! -f /var/lib/word-generator/words-checked.txt ]
then
	touch /var/lib/word-generator/words-checked.txt
	echo "# created file: /var/lib/word-generator/words-checked.txt"
fi


# set permissions for writable word lists
chmod 766 /var/lib/word-generator/words-*.txt
echo "# updated permissions: 766 /var/lib/word-generator/words-*.txt"


# install write protected program folder
if [ ! -d /usr/lib/word-generator/ ]
then
	mkdir /usr/lib/word-generator/
	echo "# created folder: /usr/lib/word-generator/"
fi


# install current version log
if [ ! -f /var/lib/word-generator/current_version ]
then
	touch /var/lib/word-generator/current_version
	echo "# created file: /var/lib/word-generator/current_version"
fi


# update current version file
echo $version > /var/lib/word-generator/current_version
echo "# current version updated"


# install version specific files
if [ ! -d /usr/lib/word-generator/word-generator-v$version/ ]
then
	mkdir /usr/lib/word-generator/word-generator-v$version/
	echo "# created folder: /usr/lib/word-generator/word-generator-v$version/"
fi


# copy program files to /var/lib
cp `pwd`/* -r /usr/lib/word-generator/word-generator-v$version/
echo "# copied files to: /usr/lib/word-generator/word-generator-v$version/"


# update permissions for executables
chmod 755 /usr/lib/word-generator/word-generator-v$version/wg*.sh
echo "# updated permissions: 755 /usr/lib/word-generator/word-generator-v$version/wg*.sh"


# install the word generator man pages
if [ -f ./manual/wg.1 ]
then
	if [ -d /usr/local/share/man/man1/ ]
	then
		# copy manual file
		cp ./manual/wg.1 /usr/local/share/man/man1/

		# refresh system man pages
		mandb -q
		echo "# man page updated for wg"
	fi
fi

if [ -f ./manual/wg-domain-check.1 ]
then
	if [ -d /usr/local/share/man/man1/ ]
	then
		# copy manual file
		cp ./manual/wg-domain-check.1 /usr/local/share/man/man1/

		# refresh system man pages
		mandb -q
		echo "# man page updated for wg-domain-check"
	fi
fi


# create soft links in /usr/bin
unlink /usr/bin/wg 2>/dev/nul
ln -s /usr/lib/word-generator/word-generator-v$version/wg.sh /usr/bin/wg
echo "# soft link created: /usr/bin/wg"

unlink /usr/bin/wg-domain-check 2>/dev/nul
ln -s /usr/lib/word-generator/word-generator-v$version/wg-domain-check.sh /usr/bin/wg-domain-check
echo "# soft link created: /usr/bin/wg-domain-check"

unlink /usr/bin/wg-cycle 2>/dev/nul
ln -s /usr/lib/word-generator/word-generator-v$version/wg-cycle.sh /usr/bin/wg-cycle
echo "# soft link created: /usr/bin/wg-cycle"


echo "# installation complete"
echo ""

exit
