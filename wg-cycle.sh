#!/bin/bash


# set program variables
program_name="word-generator"
version=$(cat /var/lib/$program_name/current_version)


# checks random domain names with whois, cycling every 3 seconds
while true; do wg-domain-check `wg`;sleep 3;done


exit
