require "tiktoken"

model = ARGV.shift? || abort "Usage: count_tokens MODEL TEXT"
text = ARGV.join(" ")
abort "Usage: count_tokens MODEL TEXT" if text.empty?

puts Tiktoken.encoding_for_model(model).count(text)
