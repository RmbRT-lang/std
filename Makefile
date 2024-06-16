TEST_FILES=$(shell find test/ -type f | grep ".rl")

all:
	rmbrtbc --test $(TEST_FILES) && (time -p ./a.out && valgrind -q --error-exitcode=1 --leak-check=yes ./a.out)