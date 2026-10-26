TEST_FILES=$(shell find test/ -type f | grep ".rl")
OS_FILE=$(shell find /tmp$(shell rmbrtbc --find ../os) -name *.o)
OS_FILE_RL=$(shell find $(shell rmbrtbc --find ../os) -name *.rl)
all:
	@# link the OS alongside.	
	@if [ -z "$(OS_FILE)" ]; then \
		echo "[DEP] os.out: NOT FOUND"; \
		exit 1; \
	else \
		echo "[DEP] os.out: $(OS_FILE)"; \
	fi

	@RL_LINK_LIBRARIES="$(OS_FILE)" rmbrtbc --testrun $(TEST_FILES) $(OS_FILE_RL)
	@#rmbrtbc --test $(TEST_FILES) && (time -p ./a.out && valgrind -q --error-exitcode=1 --leak-check=yes ./a.out)

	@#ARGS="--testrun $(TEST_FILES)" gdbtui rmbrtbc