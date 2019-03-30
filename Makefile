PROJECT = print_world
BUILD_DIR = build
CCFLAGS = -I/usr/include/python3.7m -L/usr/lib/python3.7 -fPIC

GO_SO = $(patsubst $(PROJECT)/%.go, $(BUILD_DIR)/$(PROJECT)/go_%.so, $(wildcard $(PROJECT)/*.go))
GO_A = $(patsubst $(PROJECT)/%.go, $(BUILD_DIR)/$(PROJECT)/go_%.a, $(wildcard $(PROJECT)/*.go))

CPY_SO = $(patsubst $(PROJECT)/%.pyx, $(BUILD_DIR)/$(PROJECT)/cpy_%.so, $(wildcard $(PROJECT)/*.pyx))
CPY_A = $(patsubst $(PROJECT)/%.pyx, $(BUILD_DIR)/$(PROJECT)/cpy_%.a, $(wildcard $(PROJECT)/*.pyx))

C_SO = $(patsubst $(PROJECT)/%.c, $(BUILD_DIR)/$(PROJECT)/c_%.so, $(wildcard $(PROJECT)/*.c))
C_A = $(patsubst $(PROJECT)/%.c, $(BUILD_DIR)/$(PROJECT)/c_%.a, $(wildcard $(PROJECT)/*.c))

ALL = $(GO_SO) $(GO_A) $(CPY_SO) $(CPY_A) $(C_SO) $(C_A)

.PHONY: all clean

all: $(ALL)

# GoLang
$(BUILD_DIR)/$(PROJECT)/go_%.so: $(PROJECT)/%.go
	go build -compiler=gccgo -buildmode c-shared -o $@ $<

$(BUILD_DIR)/$(PROJECT)/go_%.a: $(PROJECT)/%.go
	go build -compiler=gccgo -buildmode c-archive -o $@ $<

# Cython
$(BUILD_DIR)/$(PROJECT)/cpy_%.c: $(PROJECT)/%.pyx
	cython -3 --embed -o $@ $<

$(BUILD_DIR)/$(PROJECT)/cpy_%.o: $(BUILD_DIR)/$(PROJECT)/cpy_%.c
	cc $(CCFLAGS) -c -o $@ $<

$(BUILD_DIR)/$(PROJECT)/cpy_%.so: $(BUILD_DIR)/$(PROJECT)/cpy_%.c
	cc $(CCFLAGS) -shared -o $@ $<

$(BUILD_DIR)/$(PROJECT)/cpy_%.a: $(BUILD_DIR)/$(PROJECT)/cpy_%.o
	ar rcs $@ $<

# C
$(BUILD_DIR)/$(PROJECT)/c_%.o: $(PROJECT)/%.c
	cc -c -o $@ $<

$(BUILD_DIR)/$(PROJECT)/c_%.so: $(BUILD_DIR)/$(PROJECT)/c_%.o
	cc -shared -o $@ $<

$(BUILD_DIR)/$(PROJECT)/c_%.a: $(BUILD_DIR)/$(PROJECT)/c_%.o
	ar rcs $@ $<

clean:
	rm -rf $(BUILD_DIR)

fresh: clean all
