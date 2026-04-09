# tiktoken-cr

[![test](https://github.com/kojix2/tiktoken-cr/actions/workflows/test.yml/badge.svg)](https://github.com/kojix2/tiktoken-cr/actions/workflows/test.yml)
[![Lines of Code](https://img.shields.io/endpoint?url=https%3A%2F%2Ftokei.kojix2.net%2Fbadge%2Fgithub%2Fkojix2%2Ftiktoken-cr%2Flines)](https://tokei.kojix2.net/github/kojix2/tiktoken-cr)

Tiktoken for Crystalists.

- [tiktoken-c](https://github.com/kojix2/tiktoken-c)

## Installation

```bash
# Clone with submodules and build tiktoken-c
git clone --recursive https://github.com/kojix2/tiktoken-cr
cd tiktoken-cr && cd tiktoken-c && cargo build --release && cd ..

# Run with library path
export LD_LIBRARY_PATH=./tiktoken-c/target/release:$LD_LIBRARY_PATH  # Linux
export DYLD_LIBRARY_PATH=./tiktoken-c/target/release:$DYLD_LIBRARY_PATH  # macOS
crystal build your_program.cr

# Or use --link-flags
crystal build your_program.cr --link-flags "-L $(pwd)/tiktoken-c/target/release"
```

Add to `shard.yml`:

```yaml
dependencies:
  tiktoken:
    github: kojix2/tiktoken-cr
```

## Usage

### Using model name

```crystal
require "tiktoken"

text = "吾輩は猫である。名前はたぬき。"

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode_with_special_tokens(text)
# [7305, 122, 164, 120, 102, 15682, 163, 234, 104, 16556, 30591, 30369, 1811, 13372, 25580, 15682, 28713, 2243, 105, 50834, 1811]

encoding.decode(tokens)
# "吾輩は猫である。名前はたぬき。"

encoding.count(text)
# 21

encoding.decode_bytes(tokens)
# Bytes[229, 144, ...]
```

### Using encoding directly

You can also create encodings directly:

```crystal
require "tiktoken"

# Available encodings:
encoding = Tiktoken::Encoding.r50k_base       # GPT-3 models
encoding = Tiktoken::Encoding.p50k_base       # Code models
encoding = Tiktoken::Encoding.p50k_edit       # Edit models
encoding = Tiktoken::Encoding.cl100k_base     # ChatGPT models
encoding = Tiktoken::Encoding.o200k_base      # GPT-4o, o1, o3 models
encoding = Tiktoken::Encoding.o200k_harmony   # gpt-oss models

text = "Hello, world!"
tokens = encoding.encode(text)
decoded = encoding.decode(tokens)
```

### Counting tokens without allocating token arrays

```crystal
require "tiktoken"

encoding = Tiktoken.encoding_for_model("gpt-4")

encoding.count_ordinary("Hello world")
# 2

encoding.count("Hello world <|endoftext|>", allowed_special: Set{"<|endoftext|>"})
# 4

encoding.count_with_special_tokens("Hello world <|endoftext|>")
# 4
```

### Count the number of ChatGPT tokens

```crystal
model = "gpt-4"
messages = [
  {
    "role"    => "system",
    "content" => "You are a helpful assistant that only speaks French.",
  },
  {
    "role"    => "user",
    "content" => "Hello, how are you?",
  },
  {
    "role"    => "assistant",
    "content" => "Parlez-vous francais?",
  },
]

Tiktoken.num_tokens_from_messages(model, messages)
# 36

Tiktoken.chat_completion_max_tokens(model, messages)
# 8156
```

Supported chat message keys are `role`, `content`, `name`, `function_call`, `tool_calls`, and `refusal`.

```crystal
messages = [
  {
    "role"       => "assistant",
    "content"    => "I'll call the weather tool.",
    "tool_calls" => [
      {
        "name"      => "get_weather",
        "arguments" => %({"location":"Tokyo"}),
      },
    ],
  },
  {
    "role"    => "assistant",
    "refusal" => "I cannot help with that request.",
  },
]

Tiktoken.num_tokens_from_messages("gpt-4o", messages)
```

## Documentation

[API Documentation](https://kojix2.github.io/tiktoken-cr/)

## Contributing

- Report bugs
- Fix bugs and submit pull requests
- Write, clarify, or fix documentation
- Suggest or add new features
- Make a donation

## Acknowledgement

This project is inspired by [tiktoken_ruby](https://github.com/IAPark/tiktoken_ruby).

## LICENSE

MIT
