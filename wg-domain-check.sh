#!/bin/bash


# set program variables
program_name="word-generator"
version=$(cat /var/lib/$program_name/current_version)


# program options
function options(){

	options_text="

		Word Generator Domain Check - options

		version $version

		-a	check words found in /var/lib/$program_name/words-to-check.txt
			default setting
			overrides individual word input check

		-i 	input word to check, example:
			# wg -i test -v

		-v 	enables verbose output

		-h 	display options


		https://github.com/pinebase/word-generator
	"
	echo "$options_text"
	exit
}


# add --help feature
if [ "$1" == '--help' ]
then
	options
fi


# process arguments
while getopts 'ai:v?' c
do
	case $c in 
		a) auto_check='1';;
		i) input_word=$OPTARG;;
		v) verbose='1';;
		h) options;;
		?) options;;
	esac
done	


if [ "$verbose" == '1' ]
then
	echo ""
	echo "auto_check: $auto_check"
	echo "input_word: $input_word"
	echo "verbose: $verbose"
	echo "\$1: $1"
	echo ""
fi


if [ "$input_word" == '' ]
then
	# check for switch in the inline input
	echo $1|grep -q "-"

	if [ $? != 0 ]; then 
		input_word=$1
	fi

fi


# check if available domains logfile exists
if [ -f /var/lib/$program_name/domains-available.txt ]
then
	domains_available_file='1'
fi

# check if previously checked logfile exists
if [ -f /var/lib/$program_name/words-checked.txt ]
then
	words_checked_file='1'
fi

# check if remaining words to check list
if [ -f /var/lib/$program_name/words-to-check.txt ]
then
	words_to_check_file='1'
else
	auto_check='0'
fi


# single input check
# no -a switch found
if [ "$auto_check" != '1' ]
then

	# if script input given
	if [ "$input_word" != '' ]
	then

		if [ "$verbose" == '1' ]
		then
			echo "checking domain: $input_word.com"
			echo ""
		fi

		# attempt to match output of whois with indicators of avaiable lease
		whois $input_word.com | egrep -q '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri' 

		# "$?" = check if last command was sucessful. 0 = sucess
		if [ $? -eq 0 ]; then 

			# log word to file
			if [ $domains_available_file=='1' ]
			then
				echo "$input_word.com" >> /var/lib/$program_name/domains-available.txt
			fi

			if [ "$verbose" == '1' ]
			then
				echo "results: $input_word.com is avaiable for lease"
				echo ""

			else
				echo $input_word.com 
			fi

		else

			if [ "$verbose" == '1' ]
			then
				echo "results: $input_word.com already taken"
				echo ""
			fi

		fi 

	else
		echo "# no input word found, exiting"
		exit
	fi
fi



# multiple input check from file ~/.$program_name/words_to_check.txt
# -a switch found
if [ "$auto_check" == '1' ]
then
	echo "# automatic check beginning"
	echo "# processing words in ~/.$program_name/words-to-check.txt"
	echo "# single word input check deactivated"
	echo ""

	if [ $words_to_check_file=='1' ]
	then
		words_to_check=$(cat /var/lib/$program_name/words-to-check.txt|sed 's/\n//g')
	fi

	for word in $words_to_check
	do
		# attempt to match output of whois with indicators of avaiable lease
		whois $word.com | egrep -q '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri' 

		# "$?" = check if last command was sucessful. 0 = sucess
		if [ $? -eq 0 ]; then 

			echo "$word.com"

			if [ $domains_available_file=='1' ]
			then
				echo "$word.com" >> /var/lib/$program_name/domains-available.txt
			fi
		fi 

		# remove word from words to check list
		if [ $words_to_check_file=='1' ]
		then
			sed -i "s/$word//g" /var/lib/$program_name/words-to-check.txt
		fi

		# add word to words checked list
		if [ $words_checked_file=='1' ]
		then
			echo "$word" >> /var/lib/$program_name/words-checked.txt
		fi

		sleep 3

	done
fi


exit
