# simle makefile used to build csv dynamic | static library

##include Config.mk
ifeq ($(CC),)
	CC=gcc
endif
ifeq ($(AR),)
	AR=ar
endif

CC_FILES = csv.c
SHARED_DIR = ./shared
STATIC_DIR = ./static
TEST_DIR = ./test
SHARED_OBJ := $(CC_FILES:%.c=$(SHARED_DIR)/%.o) 
STATIC_OBJ := $(CC_FILES:%.c=$(STATIC_DIR)/%.o) 
SHARED_LIB := $(SHARED_DIR)/csv.so 
STATIC_LIB := $(STATIC_DIR)/csv.a
TEST_BIN := $(TEST_DIR)/test
CFLAGS= -O3 -Wall -ansi -pedantic -g
DEFINES = -D_FILE_OFFSET_BITS=64

# make both, shared and static + test
all: make_outdir $(SHARED_LIB) $(STATIC_LIB) $(TEST_BIN) runtest
shared: make_outdir $(SHARED_LIB)
static: make_outdir $(STATIC_LIB)

make_outdir:
	$(shell mkdir -p $(SHARED_DIR) $(STATIC_DIR))

# shared library target
$(SHARED_LIB): CFLAGS += -fPIC
$(SHARED_LIB): $(SHARED_OBJ)
	$(CC) $^ -shared -o $@ 

$(STATIC_LIB): $(STATIC_OBJ)
	$(AR) rcs $@ $^

# compile test binary
$(TEST_BIN): CFLAGS=-O3 -Wall -pedantic
$(TEST_BIN): test.c
	$(CC) $(CFLAGS) $^ $(STATIC_LIB) -lrt -o $@

# all shared objs pass 
$(SHARED_DIR)/%.o: %.c
	$(CC) $^ $(CFLAGS) -c -o $@

# all static
$(STATIC_DIR)/%.o: %.c
	$(CC) $^ $(CFLAGS) -c -o $@

# runtests
runtest:
	./test/runtest.sh


# try clean both static and dynamic
clean:
	rm -fR $(SHARED_DIR)
	rm -fR $(STATIC_DIR)
	rm -f $(TEST_BIN) $(TEST_DIR)/*.csv

