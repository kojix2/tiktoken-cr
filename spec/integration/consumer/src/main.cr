require "tiktoken"

unless Tiktoken.tiktoken_c_version == "0.9.1"
  abort "unexpected tiktoken-c version"
end

tokens = Tiktoken.encoding_for_model("gpt-4").encode("Hello from a consumer")
abort "tiktoken returned no tokens" if tokens.empty?

puts "consumer ok"
