ifeq ($(shell uname),Darwin)
	EXT := dylib
else
	EXT := so
endif

test: tiktoken-cr/target/debug/libtiktoken_cr.$(EXT)
	LIBRARY_PATH=$(PWD)/tiktoken-cr/target/debug:$(LIBRARY_PATH) LD_LIBRARY_PATH=$(PWD)/tiktoken-cr/target/debug crystal spec

tiktoken-cr/target/debug/libtiktoken_cr.$(EXT): tiktoken-cr/src/lib.rs tiktoken-cr/Cargo.toml
	cd tiktoken-cr && cargo build

clean:
	rm -rf tiktoken-cr/target
