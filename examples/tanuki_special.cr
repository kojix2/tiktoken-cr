require "../src/tiktoken.cr"

text = "吾輩は猫である。名前はたぬき。<|endoftext|>"

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode(text, allowed_special: [] of String)
p tokens
p encoding.decode(tokens)

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode(text, allowed_special: ["<|endoftext|>"])
p tokens
p encoding.decode(tokens)

