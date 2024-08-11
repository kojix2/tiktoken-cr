require "spec"
require "../src/tiktoken"

describe Tiktoken do
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

  describe "#num_tokens_from_messages" do
    it "should return the number of tokens in the messages" do
      Tiktoken.num_tokens_from_messages(model, messages).should eq(36)
    end
  end

  describe "#chat_completion_max_tokens" do
    it "should return the number of tokens remaining in the chat" do
      Tiktoken.chat_completion_max_tokens(model, messages).should eq(8156)
    end
  end

  describe "#VERSION" do
    it "has a version number" do
      Tiktoken::VERSION.should be_a(String)
    end
  end

  describe "#tiktoken_c_version" do
    it "return a tiktoken_c version number" do
      v = Tiktoken.tiktoken_c_version
      v.should be_a(String)
    end
  end
end
