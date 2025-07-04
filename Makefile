ifeq ($(shell uname),Darwin)
	EXT := dylib
	LIB_PATH_VAR := DYLD_LIBRARY_PATH
else ifeq ($(OS),Windows_NT)
	EXT := dll
	LIB_PATH_VAR := PATH
else
	EXT := so
	LIB_PATH_VAR := LD_LIBRARY_PATH
endif

test: tiktoken-c/target/debug/libtiktoken_c.$(EXT)
	LIBRARY_PATH=$(PWD)/tiktoken-c/target/debug:$(LIBRARY_PATH) $(LIB_PATH_VAR)=$(PWD)/tiktoken-c/target/debug crystal spec

tiktoken-c/target/debug/libtiktoken_c.$(EXT): tiktoken-c/src/lib.rs tiktoken-c/Cargo.toml
	cd tiktoken-c && cargo build

clean:
	rm -rf tiktoken-c/target
