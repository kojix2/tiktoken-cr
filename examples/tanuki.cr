require "../src/tiktoken.cr"

p Tiktoken::LibTiktoken.c_get_completion_max_tokens("gpt-4", "I am a tanuki.")
