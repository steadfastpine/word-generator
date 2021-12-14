#!/bin/bash


# set program variables
program_name="word-generator"
version=$(cat /var/lib/$program_name/current_version)


# program display funtions
function display_options(){

	options_text="

		Word Generator - options

		version $version

		-c	compound word output from 3 and 4 letter random words

		-l 	set number of letters per word 5-7
			default is 6

		-v 	enables verbose output

		-w 	set number of words to generate, default is 1

		-h 	display options

			
		https://github.com/pinebase/word-generator
	"
	echo "$options_text"
	exit
}

function display_liscence(){

	display_text=$(cat /usr/lib/$program_name/$program_name-v$version/COPYING)
	echo "$display_text"
	exit
}

function display_history(){

	display_history=$(cat /var/lib/$program_name/words-raw.txt)
	echo "$display_history"
	exit
}


# add --help feature
if [ "$1" == '--help' ]
then
	display_options
fi


# gnu compliant show command output
if [ "$1" == 'show' ]
then
	display_liscence
fi


# show the previosuly generated words
if [ "$1" == 'history' ]
then
	display_history
fi


# process arguments
while getopts 'l:w:cv?' c
do
	case $c in 
		l) length=$OPTARG;;
		w) words=$OPTARG;;
		c) real_words='1';;
		v) verbose='1';;
		h) display_options;;
		?) display_options;;
	esac
done	


# select random vowel
function vowel(){

	list="
	a
	e
	i
	o
	u
	"
	echo "$list"|sed 's/	//g;/^$/d;'|sort -R|head -n 1
}


# select random consonant
function consonant(){

	list="
	b
	c
	d
	f
	g
	h
	j
	l
	m
	n
	r
	s
	v
	w
	z
	"
	echo "$list"|sed 's/	//g;/^$/d;'|sort -R|head -n 1
}


if [ -f /var/lib/$program_name/words-raw.txt ]
then
	words_raw_file='1'
fi


# set default length
if [ "$length" == '' ]
then
	length=6
fi


# set default number of words to generate
if [ "$words" == '' ]
then
	words=1
fi


# output the length and word number option values
if [ "$verbose" == '1' ]
then
	echo "length: " $length
	echo "words: " $words
fi


# iterate through a generation cycle x $words
while [[ $counter -lt "$words" ]]
do
	let counter=$counter+1

	if [ "$real_words" == '1' ]
	then
		# real word combinations

		if [ "$length" == '5' ]
		then
			w1=$(cat /usr/lib/$program_name/$program_name-v$version/dictionary/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			w2=$(cat /usr/lib/$program_name/$program_name-v$version/dictionary/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			output_string=$w1$w2
		fi

		if [ "$length" == '6' ]
		then
			w1=$(cat /usr/lib/$program_name/$program_name-v$version/dictionary/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			w2=$(cat /usr/lib/$program_name/$program_name-v$version/dictionary/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			output_string=$w1$w2
		fi

		if [ "$length" == '7' ]
		then
			w1=$(cat /usr/lib/$program_name/$program_name-v$version/dictionary/3letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)
			w2=$(cat /usr/lib/$program_name/$program_name-v$version/dictionary/4letter|sed 's/	//g;/^$/d;'|sort -R|head -n 1)

			rannum=$(( ( RANDOM % 2 )  + 1 ))

			if [ "$rannum" == '1' ]
			then
				output_string=$w1$w2
			else
				output_string=$w2$w1
			fi
		fi

	else
		# random letters

		if [ "$length" == '5' ]
		then
			l1=`consonant`
			l2=`vowel`
			l3=`consonant`
			l4=`vowel`
			l5=`consonant`
			output_string=$l1$l2$l3$l4$l5
		fi

		if [ "$length" == '6' ]
		then
			l1=`consonant`
			l2=`vowel`
			l3=`consonant`
			l4=`vowel`
			l5=`consonant`
			l6=`vowel`
			output_string=$l1$l2$l3$l4$l5$l6
		fi

		if [ "$length" == '7' ]
		then
			l1=`consonant`
			l2=`vowel`
			l3=`consonant`
			l4=`vowel`
			l5=`consonant`
			l6=`vowel`
			l7=`consonant`
			output_string=$l1$l2$l3$l4$l5$l6$l7
		fi
	fi

	echo $output_string

	# log word to file
	if [ $words_raw_file=='1' ]
	then
		echo $output_string >> /var/lib/$program_name/words-raw.txt
	fi

done


# add space to log file
if [ $words_raw_file=='1' ]
then
	echo "" >> /var/lib/$program_name/words-raw.txt
fi


exit
