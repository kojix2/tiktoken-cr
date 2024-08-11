require "../src/tiktoken"

text = "吾輩は猫である。名前はたぬき。"

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode_with_special_tokens(text)
p tokens
p encoding.decode(tokens)
