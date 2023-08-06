require "../src/tiktoken.cr"

p Tiktoken::LibTiktoken.get_completion_max_tokens_raw("gpt-4", "I am a tanuki.")
