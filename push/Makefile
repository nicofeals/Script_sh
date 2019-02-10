CC = clang++

main: main.cc

check:
	./main > test
	if [[ `cat test` != "Hello Word !\n" ]]; then
		echo "fail" >&2
	fi
	$(RM) test