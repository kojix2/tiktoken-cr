require "../src/tiktoken"

text = "吾輩は猫である。名前はたぬき。<|endoftext|>"

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode(text, allowed_special: Set(String).new)
puts tokens.inspect
puts encoding.decode(tokens)

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode(text, allowed_special: ["<|endoftext|>"].to_set)
puts tokens.inspect
puts encoding.decode(tokens)
