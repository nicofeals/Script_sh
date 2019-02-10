#! /bin/sh

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
	if [[ $arg == "-r" && $remote == "" ]]; then
		opt_kind="remote"

	elif [[ $arg == "-t" && $testsuit == "" ]]; then
		opt_kind="testsuit"
		testsuit="N"

	elif [[ $arg == "--tag" && $tag == "" ]]; then
		opt_kind="tag"

	elif [[ $opt_kind == "remote" ]]; then
		remote="$arg"
		opt_kind=""

	elif [[ $opt_kind == "testsuit" ]]; then
		if [ $arg != "N" -a $arg != "Y" ]; then
			echo "Fail Usage: ./push [-r <remote_name>][-t <continue>=N][--tag <tagname>]" >&2
			echo "option -t can be followed by Y or N and is set to N by default" >&2
		else
			testsuit=$arg
		fi
		opt_kind=""

	elif [[ opt_kind == "tag" ]]; then
		tag="$arg"
		opt_kind=""

	else
		echo "Fail Usage: ./push [-r remote_name][-t <continue>=N][--tag <tagname>]\n" >&2
		echo "$arg is not an option or is allready set" >&2
		echo "here are the options allready set:"
		if [[ $remote != "" ]]; then
			echo "-r : $remote"
		fi

		if [[ $testsuit != "" ]]; then
			echo "-t : $testsuit"
		fi

		if [[ $tag != "" ]]; then
			echo "--tag : $tag"
		fi
		
	fi
done
mkdir .__tmp_push__
make
make 2> .__tmp_push__/error
resum=""
if [[ `cat .__tmp_push__/error` != "" ]]; then
	echo ""
	echo "$RED$BOLD$BLINKING!\tMAKE FAILE\t!$NORMAL"
	exit 1
else
	clear
	resume="$GREEN$BOLD\tCompile OK$NORMAL"
	if [[ testsuit != "" ]]; then
		make check 2>.__tmp_push__/error
		make check
		if [[ `cat .__tmp_push__/error` != "" ]]; then
			resume="$resume\n$RED$BOLD$BLINKING!\tMAKE CHECK FAIL\t!$NORMAL"
		else
			resume="$resume\n$GREEN$BOLD\tmake check OK$NORMAL"
			testsuit="OK"
		fi	
	fi
	if [[ $testsuit == "OK" || $testsuit == "" || $testsuit == "Y" ]]; then
		clear
		echo "$resume"
		git push
		git push "$remote"
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
exit 0