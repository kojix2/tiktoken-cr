require "spec"
require "../../src/tiktoken"

describe "Tiktoken::LibTiktoken" do
  describe "#get_completion_max_tokens" do
    it "returns the maximum number of tokens for a given model" do
    Tiktoken::LibTiktoken.get_completion_max_tokens_raw("gpt-4", "I am a tanuki.").should eq 8186
    end
  end
  
  describe "#num_tokens_from_messages" do
    it "returns the number of tokens in a given message" do
      message = Tiktoken::LibTiktoken::ChatCompletionRequestMessage.new(
        role: "system", 
        name: nil,
        content: "You are a helpful, pattern-following assistant that translates corporate jargon into plain English.",
        function_call: nil
      )
      messages = Pointer(Tiktoken::LibTiktoken::ChatCompletionRequestMessage).malloc(1)
      messages[0] = message
      Tiktoken::LibTiktoken.num_tokens_from_messages_raw("gpt-3.5-turbo-0301", 1, messages).should eq 26
    end
  end
end