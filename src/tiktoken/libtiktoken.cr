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

    fun r50k_base_raw : Void*
    fun p50k_base_raw : Void*
    fun p50k_edit_raw : Void*
    fun cl100k_base_raw : Void*
    fun destroy_corebpe_raw(corebpe : Void*)
    fun get_completion_max_tokens_raw(model : LibC::Char*, prompt : LibC::Char*) : Int32
    fun num_tokens_from_messages_raw(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : Int32
    fun get_chat_completion_max_tokens_raw(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : Int32
    fun get_bpe_from_model_raw(model : LibC::Char*) : Void*
    fun corebpe_encode_ordinary_raw(corebpe : Void*, text : LibC::Char*, num_tokens : UInt32) : LibC::SizeT*
  end
end
