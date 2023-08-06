module Tiktoken
  @[Link("tiktoken_cr")]
  lib LibTiktoken
    struct FunctionCall
      name : LibC::Char*
      arguments : LibC::Char*
    end

    struct ChatCompletionRequestMessage
      role : LibC::Char*
      content : LibC::Char*
      name : LibC::Char*
      function_call : FunctionCall*
    end

    fun get_completion_max_tokens_raw(model : LibC::Char*, prompt : LibC::Char*) : Int32
    fun num_tokens_from_messages_raw(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : Int32
    fun get_chat_completion_max_tokens_raw(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : Int32
  end
end
