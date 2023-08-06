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
      model = "gpt-3.5-turbo-0301"
      message = Tiktoken::LibTiktoken::ChatCompletionRequestMessage.new(
        role: "system",
        name: nil,
        content: "You are a helpful, pattern-following assistant that translates corporate jargon into plain English.",
        function_call: nil
      )
      messages = Pointer(Tiktoken::LibTiktoken::ChatCompletionRequestMessage).malloc(1)
      messages[0] = message
      Tiktoken::LibTiktoken.num_tokens_from_messages_raw(model, 1, messages).should eq 26
    end

    it "returns the number of tokens in a given messages" do
      model = "gpt-4"
      message_array = [
        Tiktoken::LibTiktoken::ChatCompletionRequestMessage.new(
          role: "system",
          name: nil,
          content: "You are a helpful assistant that only speaks French.",
          function_call: nil
        ),
        Tiktoken::LibTiktoken::ChatCompletionRequestMessage.new(
          role: "user",
          name: nil,
          content: "Hello, how are you?",
          function_call: nil
        ),
        Tiktoken::LibTiktoken::ChatCompletionRequestMessage.new(
          role: "system",
          name: nil,
          content: "Parlez-vous francais?",
          function_call: nil
        ),
      ]
      messages = Pointer(Tiktoken::LibTiktoken::ChatCompletionRequestMessage).malloc(3)
      messages[0] = message_array[0]
      messages[1] = message_array[1]
      messages[2] = message_array[2]
      Tiktoken::LibTiktoken.get_chat_completion_max_tokens_raw(model, 3, messages).should eq 8156
    end
  end

  describe "#get_chat_completion_max_tokens" do
    it "returns the maximum number of tokens for a given message" do
      model = "gpt-3.5-turbo"
      message = Tiktoken::LibTiktoken::ChatCompletionRequestMessage.new(
        role: "system",
        name: nil,
        content: "You are a helpful assistant that only speaks French.",
        function_call: nil
      )
      messages = Pointer(Tiktoken::LibTiktoken::ChatCompletionRequestMessage).malloc(1)
      messages[0] = message
      Tiktoken::LibTiktoken.get_chat_completion_max_tokens_raw(model, 1, messages).should eq 4078
    end
  end
end