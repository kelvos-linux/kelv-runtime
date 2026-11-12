CARGO ?= cargo
.PHONY: all build clean

all: build

build:
	$(CARGO) build --release --locked

clean:
	$(CARGO) clean
