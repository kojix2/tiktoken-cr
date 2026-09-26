require "tiktoken"

abort "missing tiktoken-c version" if Tiktoken.tiktoken_c_version.empty?

tokens = Tiktoken.encoding_for_model("gpt-4").encode("Hello from a consumer")
abort "tiktoken returned no tokens" if tokens.empty?

puts "consumer ok"
