ifeq ($(shell uname),Darwin)
	EXT := dylib
else
	EXT := so
endif

test: tiktoken-c/target/debug/libtiktoken_c.$(EXT)
	LIBRARY_PATH=$(PWD)/tiktoken-c/target/debug:$(LIBRARY_PATH) LD_LIBRARY_PATH=$(PWD)/tiktoken-c/target/debug crystal spec

tiktoken-c/target/debug/libtiktoken_c.$(EXT): tiktoken-c/src/lib.rs tiktoken-c/Cargo.toml
	cd tiktoken-c && cargo build

clean:
	rm -rf tiktoken-c/target
