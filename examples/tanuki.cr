require "../src/tiktoken.cr"

text = "I am a tanuki."

encoding = Tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode_with_special_tokens(text)
p tokens
p encoding.decode(tokens)

p Tiktoken::LibTiktoken.c_get_completion_max_tokens("gpt-4", "I am a tanuki.")
