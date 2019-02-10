#!/bin/sh
RED="\033[31m"
GREEN="\033[32m"
BOLD="\033[1m"
UNDERLINE="\033[4m"
BLINKING="\033[5m"
NORMAL="\033[0m"

opt_kind=""
remote=""
testsuit=""
tag=""
for arg in $@; do
	if [[ $arg == "-r" ]]; then
		opt_kind="remote"

	elif [[ $opt_kind == "remote" ]]; then
		remote="$arg"
		opt_kind=""

	elif [[ $arg == "-t" ]]; then
		opt_kind="testsuit"

	elif [[ $opt_kind == "testsuit" ]]; then
		if [[ $arg != "N" -a $arg != "Y" ]]; then
			echo "Fail Usage: ./push [-r <remote_name>=epita][-t <continue>=N][tagname]" >&2
			echo "option -t can be followed by Y or N and is set to N by default" >&2
		else
			testsuit=$arg
		fi
		opt_kind=""

	elif [[ opt_kind == "" ]]; then
		tag="$arg"
		opt_kind="none"

	elif [[ opt_kind == "none" ]]; then
		echo "$arg is not an option and tagname is allready set to be: $tag"
		echo "may be you want change the tagname ? [y/n]"
		read answer
		if [[ answer == "y" ]]; then
			tag=$arg
		else
			echo "Fail Usage: ./push [-r <remote_name>=epita][-t <continue>=N][tagname]" >&2
		fi
	fi
done
mkdir .__tmp_push__
make
make 2> .__tmp_push__/error
if [[ `cat .__tmp_push__/error` != "" ]]; then
	echo ""
	echo "$RED$BOLD$BLINKING!\tMAKE FAILE\t!$NORMAL"
else
	clear
	echo "$GREEN$BOLD\tCompile OK$NORMAL"
	if [[ testsuit != "" ]]; then
		make check 2>.__tmp_push__/error
		make check
		if [[ `cat .__tmp_push__/error` != "" ]]; then
			echo ""
			echo "$RED$BOLD$BLINKING!\tMAKE CHECK FAIL\t!$NORMAL"
			if [[ testsuit == "Y" ]]; then
				testsuit="OK"
			else
				testsuit="KO"
			fi
		else
			clear
			echo "$GREEN$BOLD\tmake check OK$NORMAL"
			testsuit="OK"
		fi	
	fi
	if [[ testsuite == "OK" -o testsuit == "" ]]; then
		git push
		git push epita
		if [[ $# -eq 2 ]]; then
			git tag "$1"
		else
			echo "\n$BOLD$UNDERLINE Tag$NORMAL: "
			read my_tag
			git tag "$my_tag"
		fi
		git push --tags
		git push epita
	fi
fi
rm -r .__tmp_push__