

 __      ____ _ 
 \ \ /\ / / _  |
  \ V  V / (_| |
   \_/\_/ \__, |
           __/ |
          |___/ 



Word Generator



# Contact: https://www.linkedin.com/in/steadfastpine/m

# Release Date: 2019-06-07
# Version: .9



Description

	Generate words of various lengths and composition.
	Types include randomly generated words, and compound words made up of smaller terms.



Prerequisites

	Bash Shell

	Operating Systems

		Linux

			Centos
			Redhat
			Fedora



Installation

		Download and unzip the program files, then change working directory to them:
		
			# cd word-generator


		Next, run the installation script:

			# ./install

	
		This will install the following files and folders:

			write protected library files, version specific
				/usr/lib/word-generator-$version	

			storage for lists of generated words
				/var/lib/word-generator

			man page for wg				
				/usr/local/share/man/man1/wg.1		

			word output log from generator
				/var/lib/word-generator/words-raw.txt	

			words for auto domain check feature input	
				/var/lib/word-generator/words-to-check.txt	

			words for auto domain check feature output
				/var/lib/word-generator/words-checked.txt	



Options

		Word Generator - (wg)

			Switch Options

			-c	compound word output from 3 and 4 letter random words

			-l 	set number of letters per word 5-7
				default is 6

			-v 	enables verbose output

			-w 	set number of words to generate, default is 1

			-? 	display options



		Word Generator Domain Check - (wg-domain-check)

			Switch Options

			-a	Check words found in words_to_check.txt
				this is the default setting
				overrides individual word input check

			-i 	Input word
				example: ./check.sh i test -v

			-v 	Enables verbose output

			-? 	Display options



Usage
	
	Generate a word with random letter in common letter patterns: (default)

	# wg
	vejibi
	

	Generate a word made up of smaller real words: (-r)  

	# wg -r
	nowyes


License 

	This program is licensed under the GPL License, view the LICENSE.md file for more information.














