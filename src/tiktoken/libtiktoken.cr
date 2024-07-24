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

    type CoreBPE = Void

    fun tiktoken_init_logger
    fun tiktoken_r50k_base : CoreBPE*
    fun tiktoken_p50k_base : CoreBPE*
    fun tiktoken_p50k_edit : CoreBPE*
    fun tiktoken_cl100k_base : CoreBPE*
    fun tiktoken_o200k_base : CoreBPE*
    fun tiktoken_destroy_corebpe(corebpe : CoreBPE*)
    fun tiktoken_get_completion_max_tokens(model : LibC::Char*, prompt : LibC::Char*) : LibC::SizeT
    fun tiktoken_num_tokens_from_messages(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : LibC::SizeT
    fun tiktoken_get_chat_completion_max_tokens(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : LibC::SizeT
    fun tiktoken_get_bpe_from_model(model : LibC::Char*) : CoreBPE*
    fun tiktoken_corebpe_encode_ordinary(corebpe : CoreBPE*, text : LibC::Char*, num_tokens : LibC::SizeT*) : LibC::SizeT*
    fun tiktoken_corebpe_encode(corebpe : CoreBPE*, text : LibC::Char*, allowed_special : LibC::Char**, allowed_special_len : LibC::SizeT, num_tokens : LibC::SizeT*) : LibC::SizeT*
    fun tiktoken_corebpe_encode_with_special_tokens(corebpe : CoreBPE*, text : LibC::Char*, num_tokens : LibC::SizeT*) : LibC::SizeT*
    fun tiktoken_corebpe_decode(corebpe : CoreBPE*, tokens : LibC::SizeT*, num_tokens : LibC::SizeT) : LibC::Char*
    fun tiktoken_c_version : LibC::Char*
  end
end
