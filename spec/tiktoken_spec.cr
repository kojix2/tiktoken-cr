require "spec"
require "../src/tiktoken.cr"

describe Tiktoken do
  describe "#num_tokens_from_messages" do
    model = "gpt-4"
    messages = [
      {
        "role"    => "system",
        "content" => "You are a helpful assistant that only speaks French.",
      },
      {
        "role"    => "user",
        "content" => "Hello, how are you?",
      },
      {
        "role"    => "assistant",
        "content" => "Parlez-vous francais?",
      },
    ]
    Tiktoken.num_tokens_from_messages(model, messages).should eq(36)
  end
end
