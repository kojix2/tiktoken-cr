module Tiktoken
  @[Link("tiktoken_c")]
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

    fun c_r50k_base : Void*
    fun c_p50k_base : Void*
    fun c_p50k_edit : Void*
    fun c_cl100k_base : Void*
    fun c_destroy_corebpe(corebpe : Void*)
    fun c_get_completion_max_tokens(model : LibC::Char*, prompt : LibC::Char*) : Int32
    fun c_num_tokens_from_messages(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : Int32
    fun c_get_chat_completion_max_tokens(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : Int32
    fun c_get_bpe_from_model(model : LibC::Char*) : Void*
    fun c_corebpe_encode_ordinary(corebpe : Void*, text : LibC::Char*, num_tokens : UInt32*) : UInt64*
    fun c_corebpe_encode_with_special_tokens(corebpe : Void*, text : LibC::Char*, num_tokens : UInt32*) : UInt64*
    fun c_corebpe_decode(corebpe : Void*, tokens : UInt64*, num_tokens : UInt32) : LibC::Char*
  end
end
