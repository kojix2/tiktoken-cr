module Tiktoken
  @[Link("tiktoken_c")]
  lib LibTiktoken
    alias Rank = UInt32

    type CoreBPE = Void
    type ChatCompletionRequestMessage = Void

    fun tiktoken_init_logger
    fun tiktoken_chat_message_new(role : LibC::Char*) : ChatCompletionRequestMessage*
    fun tiktoken_chat_message_set_role(message : ChatCompletionRequestMessage*, role : LibC::Char*) : Bool
    fun tiktoken_chat_message_set_content(message : ChatCompletionRequestMessage*, content : LibC::Char*) : Bool
    fun tiktoken_chat_message_set_name(message : ChatCompletionRequestMessage*, name : LibC::Char*) : Bool
    fun tiktoken_chat_message_set_function_call(message : ChatCompletionRequestMessage*, name : LibC::Char*, arguments : LibC::Char*) : Bool
    fun tiktoken_chat_message_clear_function_call(message : ChatCompletionRequestMessage*)
    fun tiktoken_chat_message_add_tool_call(message : ChatCompletionRequestMessage*, name : LibC::Char*, arguments : LibC::Char*) : Bool
    fun tiktoken_chat_message_clear_tool_calls(message : ChatCompletionRequestMessage*)
    fun tiktoken_chat_message_set_refusal(message : ChatCompletionRequestMessage*, refusal : LibC::Char*) : Bool
    fun tiktoken_chat_message_destroy(message : ChatCompletionRequestMessage*)
    fun tiktoken_r50k_base : CoreBPE*
    fun tiktoken_p50k_base : CoreBPE*
    fun tiktoken_p50k_edit : CoreBPE*
    fun tiktoken_cl100k_base : CoreBPE*
    fun tiktoken_o200k_base : CoreBPE*
    fun tiktoken_o200k_harmony : CoreBPE*
    fun tiktoken_destroy_corebpe(corebpe : CoreBPE*)
    fun tiktoken_get_completion_max_tokens(model : LibC::Char*, prompt : LibC::Char*) : LibC::SizeT
    fun tiktoken_num_tokens_from_messages(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage**) : LibC::SizeT
    fun tiktoken_get_chat_completion_max_tokens(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage**) : LibC::SizeT
    fun tiktoken_get_bpe_from_model(model : LibC::Char*) : CoreBPE*
    fun tiktoken_corebpe_encode_ordinary(corebpe : CoreBPE*, text : LibC::Char*, num_tokens : LibC::SizeT*) : Rank*
    fun tiktoken_corebpe_count_ordinary(corebpe : CoreBPE*, text : LibC::Char*) : LibC::SizeT
    fun tiktoken_corebpe_encode(corebpe : CoreBPE*, text : LibC::Char*, allowed_special : LibC::Char**, allowed_special_len : LibC::SizeT, num_tokens : LibC::SizeT*) : Rank*
    fun tiktoken_corebpe_count(corebpe : CoreBPE*, text : LibC::Char*, allowed_special : LibC::Char**, allowed_special_len : LibC::SizeT) : LibC::SizeT
    fun tiktoken_corebpe_encode_with_special_tokens(corebpe : CoreBPE*, text : LibC::Char*, num_tokens : LibC::SizeT*) : Rank*
    fun tiktoken_corebpe_count_with_special_tokens(corebpe : CoreBPE*, text : LibC::Char*) : LibC::SizeT
    fun tiktoken_corebpe_decode(corebpe : CoreBPE*, tokens : Rank*, num_tokens : LibC::SizeT) : LibC::Char*
    fun tiktoken_corebpe_decode_bytes(corebpe : CoreBPE*, tokens : Rank*, num_tokens : LibC::SizeT, num_bytes : LibC::SizeT*) : UInt8*
    fun tiktoken_free(ptr : Void*)
    fun tiktoken_c_version : LibC::Char*
  end
end
