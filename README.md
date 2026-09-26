# tiktoken-cr

[![test](https://github.com/kojix2/tiktoken-cr/actions/workflows/test.yml/badge.svg)](https://github.com/kojix2/tiktoken-cr/actions/workflows/test.yml)

Token counting and encoding for Crystal, powered by [tiktoken-c](https://github.com/kojix2/tiktoken-c).

## Install

Add the shard to `shard.yml`:

```yaml
dependencies:
  tiktoken:
    github: kojix2/tiktoken-cr
```

Then install it:

```sh
shards install
```

The install step downloads the required native library. No separate Rust or C toolchain is needed.

## Use

### Count, encode, and decode

```crystal
require "tiktoken"

encoding = Tiktoken.encoding_for_model("gpt-5.4")
text = "Hello, world!"

encoding.count(text)  # => 4

tokens = encoding.encode(text)
encoding.decode(tokens)  # => "Hello, world!"
```

To use an encoding directly:

```crystal
encoding = Tiktoken::Encoding.o200k_base
```

### Allow special tokens

```crystal
text = "Hello <|endoftext|>"
allowed = Set{"<|endoftext|>"}

encoding.encode(text, allowed_special: allowed)
encoding.count(text, allowed_special: allowed)
```

### Count chat messages

```crystal
messages = [
  {"role" => "system", "content" => "You are a helpful assistant."},
  {"role" => "user", "content" => "Hello!"},
]

Tiktoken.num_tokens_from_messages("gpt-5.4", messages)
Tiktoken.chat_completion_max_tokens("gpt-5.4", messages)
```

See the [API documentation](https://kojix2.github.io/tiktoken-cr/) for the complete API.

## Command-line example

The repository includes a small token-counting command:

```sh
cd examples/count_tokens
shards install
shards build

echo "Hello, world!" | bin/count_tokens
bin/count_tokens -m gpt-4o file.txt
```

Run `bin/count_tokens --help` for its options. Without `-m`, it uses `gpt-5.4`.

## Supported platforms

- Linux x86_64 (glibc)
- macOS aarch64
- Windows x86_64 (MSVC)

Other targets are not currently supported.

## License

MIT
