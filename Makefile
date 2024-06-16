TEST_FILES=$(shell find test/ -type f | grep ".rl")

all:
	rmbrtbc --test $(TEST_FILES) #&& valgrind -q --error-exitcode=1 --leak-check=yes
	time -p ./a.out