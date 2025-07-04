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

```crystal
require "tiktoken"

text = "吾輩は猫である。名前はたぬき。"

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode_with_special_tokens(text)
# [7305, 122, 164, 120, 102, 15682, 163, 234, 104, 16556, 30591, 30369, 1811, 13372, 25580, 15682, 28713, 2243, 105, 50834, 1811]

encoding.decode(tokens)
# "吾輩は猫である。名前はたぬき。"
```

Count the number of ChatGPT tokens

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
