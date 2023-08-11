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

    fun c_init_logger
    fun c_r50k_base : CoreBPE*
    fun c_p50k_base : CoreBPE*
    fun c_p50k_edit : CoreBPE*
    fun c_cl100k_base : CoreBPE*
    fun c_destroy_corebpe(corebpe : CoreBPE*)
    fun c_get_completion_max_tokens(model : LibC::Char*, prompt : LibC::Char*) : LibC::SizeT
    fun c_num_tokens_from_messages(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : LibC::SizeT
    fun c_get_chat_completion_max_tokens(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage*) : LibC::SizeT
    fun c_get_bpe_from_model(model : LibC::Char*) : CoreBPE*
    fun c_corebpe_encode_ordinary(corebpe : CoreBPE*, text : LibC::Char*, num_tokens : LibC::SizeT*) : LibC::SizeT*
    fun c_corebpe_encode(corebpe : CoreBPE*, text : LibC::Char*, allowed_special : LibC::Char**, allowed_special_len : LibC::SizeT, num_tokens : LibC::SizeT*) : LibC::SizeT*
    fun c_corebpe_encode_with_special_tokens(corebpe : CoreBPE*, text : LibC::Char*, num_tokens : LibC::SizeT*) : LibC::SizeT*
    fun c_corebpe_decode(corebpe : CoreBPE*, tokens : LibC::SizeT*, num_tokens : LibC::SizeT) : LibC::Char*
  end
end
