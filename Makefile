CARGO ?= cargo
OBJCOPY ?= objcopy
TARGET := x86_64-unknown-none
ELF := target/$(TARGET)/release/user_init
BIN := user_init.bin

.PHONY: all build clean

all: build

build:
	$(CARGO) build --release --locked
	$(OBJCOPY) -O binary \
		--only-section=.text \
		--only-section=.rodata \
		--only-section=.data \
		$(ELF) $(BIN)

clean:
	$(CARGO) clean
	rm -f $(BIN)
