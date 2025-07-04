require "./tiktoken/libtiktoken"
require "./tiktoken/version"
require "./tiktoken/encoding"

module Tiktoken
  def self.get_encoding(encoding_name)
    raise NotImplementedError
  end

  def self.encoding_for_model(model_name)
    Encoding.for_model(model_name)
  end

  def self.num_tokens_from_messages(model, messages)
    num_messages = messages.size
    messages_ptr = Pointer(LibTiktoken::CChatCompletionRequestMessage).malloc(num_messages)
    messages.each_with_index do |message, i|
      role = message["role"]
      content = message.has_key?("content") ? message["content"].to_unsafe : Pointer(LibC::Char).null
      name = message.has_key?("name") ? message["name"].to_unsafe : Pointer(LibC::Char).null
      function_call = \
         if message.has_key?("function_call")
           Pointer(LibTiktoken::CFunctionCall).malloc(1) do
             LibTiktoken::CFunctionCall.new(
               name: message["function_call"]["name"],
               arguments: message["function_call"]["arguments"]
             )
           end
         else
           Pointer(LibTiktoken::CFunctionCall).null
         end
      messages_ptr[i] = LibTiktoken::CChatCompletionRequestMessage.new(
        role: role,
        content: content,
        name: name,
        function_call: function_call
      )
    end
    LibTiktoken.tiktoken_num_tokens_from_messages(model, num_messages, messages_ptr).tap do |n|
      raise "Error in num_tokens_from_messages" if n == LibC::SizeT::MAX
    end
  end

  def self.chat_completion_max_tokens(model, messages)
    num_messages = messages.size
    messages_ptr = Pointer(LibTiktoken::CChatCompletionRequestMessage).malloc(num_messages)
    messages.each_with_index do |message, i|
      role = message["role"]
      content = message.has_key?("content") ? message["content"].to_unsafe : Pointer(LibC::Char).null
      name = message.has_key?("name") ? message["name"].to_unsafe : Pointer(LibC::Char).null
      function_call = \
         if message.has_key?("function_call")
           Pointer(LibTiktoken::CFunctionCall).malloc(1) do
             LibTiktoken::CFunctionCall.new(
               name: message["function_call"]["name"],
               arguments: message["function_call"]["arguments"]
             )
           end
         else
           Pointer(LibTiktoken::CFunctionCall).null
         end
      messages_ptr[i] = LibTiktoken::CChatCompletionRequestMessage.new(
        role: role,
        content: content,
        name: name,
        function_call: function_call
      )
    end
    LibTiktoken.tiktoken_get_chat_completion_max_tokens(model, num_messages, messages_ptr).tap do |n|
      raise "Error in chat_completion_max_tokens" if n == LibC::SizeT::MAX
    end
  end

  def self.tiktoken_c_version : String
    String.new(LibTiktoken.tiktoken_c_version)
  end
end
