# tiktoken-cr

[![test](https://github.com/kojix2/tiktoken-cr/actions/workflows/test.yml/badge.svg)](https://github.com/kojix2/tiktoken-cr/actions/workflows/test.yml)

Tiktoken for Crystalists.

- [tiktoken-rs](https://github.com/zurawiki/tiktoken-rs)
- [tiktoken-c](https://github.com/kojix2/tiktoken-c)

## Usage

```crystal
require "../src/tiktoken.cr"

text = "吾輩は猫である。名前はたぬき。"

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode_with_special_tokens(text)

p tokens

# [7305, 122, 164, 120, 102, 15682, 163, 234, 104, 16556, 30591, 30369, 1811, 13372, 25580, 15682, 28713, 2243, 105, 50834, 1811]

p encoding.decode(tokens)

# "吾輩は猫である。名前はたぬき。"

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
