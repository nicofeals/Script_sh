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
	echo ""
	echo "\033[32;1m\tCompile OK\033[0m"
	git push
	git push epita
	if [[ $# -eq 2 ]]; then
		git tag "$1"
	else
		echo "\n\033[1;4mTag\033[0m: "
		read my_tag
		git tag "$my_tag"
	fi
	git push --tags
	git push epita
fi
rm -r .__tmp_push__