require "option_parser"
require "tiktoken"

model = "gpt-5.4"

OptionParser.parse do |parser|
  parser.banner = "Usage: count_tokens [options] [files]"
  parser.on("-m MODEL", "--model=MODEL", "Model name (default: #{model})") { |name| model = name }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
end

puts Tiktoken.encoding_for_model(model).count(ARGF.gets_to_end)
