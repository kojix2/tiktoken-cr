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
    with_chat_messages(messages) do |message_pointers|
      LibTiktoken.tiktoken_num_tokens_from_messages(model, message_pointers.size, message_pointers.to_unsafe).tap do |count|
        raise "Error in num_tokens_from_messages" if count == LibC::SizeT::MAX
      end
    end
  end

  def self.chat_completion_max_tokens(model, messages)
    with_chat_messages(messages) do |message_pointers|
      LibTiktoken.tiktoken_get_chat_completion_max_tokens(model, message_pointers.size, message_pointers.to_unsafe).tap do |count|
        raise "Error in chat_completion_max_tokens" if count == LibC::SizeT::MAX
      end
    end
  end

  def self.tiktoken_c_version : String
    String.new(LibTiktoken.tiktoken_c_version)
  end

  private def self.with_chat_messages(messages, &)
    pointers = [] of Pointer(LibTiktoken::ChatCompletionRequestMessage)
    messages.each do |message|
      pointers << build_chat_message(message)
    end
    yield pointers
  ensure
    pointers.try &.each do |pointer|
      LibTiktoken.tiktoken_chat_message_destroy(pointer)
    end
  end

  private def self.build_chat_message(message) : Pointer(LibTiktoken::ChatCompletionRequestMessage)
    role = required_string_value(message, "role")
    pointer = LibTiktoken.tiktoken_chat_message_new(role)
    raise ArgumentError.new("Failed to create chat message") if pointer.null?

    begin
      apply_optional_string(pointer, message, "content") do |ptr, value|
        LibTiktoken.tiktoken_chat_message_set_content(ptr, value)
      end
      apply_optional_string(pointer, message, "name") do |ptr, value|
        LibTiktoken.tiktoken_chat_message_set_name(ptr, value)
      end
      apply_function_call(pointer, message["function_call"]?)
      apply_tool_calls(pointer, message["tool_calls"]?)
      apply_optional_string(pointer, message, "refusal") do |ptr, value|
        LibTiktoken.tiktoken_chat_message_set_refusal(ptr, value)
      end

      pointer
    rescue ex
      LibTiktoken.tiktoken_chat_message_destroy(pointer)
      raise ex
    end
  end

  private def self.apply_optional_string(pointer : Pointer(LibTiktoken::ChatCompletionRequestMessage), message, key : String, & : Pointer(LibTiktoken::ChatCompletionRequestMessage), String -> Bool)
    value = string_value(message[key]?, key)
    return if value.nil?

    raise ArgumentError.new("Invalid #{key} value") unless yield pointer, value
  end

  private def self.apply_function_call(pointer : Pointer(LibTiktoken::ChatCompletionRequestMessage), value)
    return if value.nil?
    function_call = string_hash_value(value, "function_call")
    raise ArgumentError.new("Invalid function_call value") unless LibTiktoken.tiktoken_chat_message_set_function_call(pointer, required_string_value(function_call, "name"), required_string_value(function_call, "arguments"))
  end

  private def self.apply_tool_calls(pointer : Pointer(LibTiktoken::ChatCompletionRequestMessage), value)
    return if value.nil?
    tool_calls = hash_array_value(value, "tool_calls")
    tool_calls.each do |tool_call|
      raise ArgumentError.new("Invalid tool_calls value") unless LibTiktoken.tiktoken_chat_message_add_tool_call(pointer, required_string_value(tool_call, "name"), required_string_value(tool_call, "arguments"))
    end
  end

  private def self.required_string_value(message, key : String) : String
    string_value(message[key]?, key) || raise ArgumentError.new("Missing #{key}")
  end

  private def self.string_value(value, key : String) : String?
    case value
    when String
      value
    when Nil
      nil
    else
      raise ArgumentError.new("Expected #{key} to be a string")
    end
  end

  private def self.string_hash_value(value, key : String) : Hash(String, String)
    case value
    when Hash(String, String)
      value
    else
      raise ArgumentError.new("Expected #{key} to be an object")
    end
  end

  private def self.hash_array_value(value, key : String) : Array(Hash(String, String))
    case value
    when Array(Hash(String, String))
      value
    else
      raise ArgumentError.new("Expected #{key} to be an array")
    end
  end
end
