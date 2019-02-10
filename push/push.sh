#!/bin/sh

mkdir .__tmp_push__
make
make 2> .__tmp_push__/error
if [[ `cat .__tmp_push__/error` != "" ]]; then
	#clear
	echo ""
	echo "\033[31;1;5m!\tMAKE FAILE\t!\033[0m"
	#make
else
	clear
	resume="$GREEN$BOLD\tCompile OK$NORMAL"
	if [[ testsuit != "" ]]; then
		make check 2>.__tmp_push__/error
		clear
		make check
		if [[ `cat .__tmp_push__/error` != "" ]]; then
			resume="$resume\n$RED$BOLD$BLINKING!\tMAKE CHECK FAIL \t!$NORMAL"
			if [[ $testsuit == "N" ]]; then
				echo "\n$resume"
				exit 2
			fi
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
		git push "$remote" --tags
	fi
fi
rm -r .__tmp_push__