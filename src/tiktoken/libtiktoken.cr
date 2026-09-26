module Tiktoken
  {% if flag?(:msvc) %}
    @[Link(ldflags: "/LIBPATH:#{__DIR__}/../../vendor/tiktoken-c")]
    @[Link("ntdll")]
  {% elsif flag?(:darwin) %}
    @[Link(ldflags: "-L#{__DIR__}/../../vendor/tiktoken-c")]
    @[Link("iconv")]
    @[Link("pthread")]
    @[Link("m")]
    @[Link("c")]
  {% elsif flag?(:linux) && !flag?(:musl) %}
    @[Link(ldflags: "-L#{__DIR__}/../../vendor/tiktoken-c")]
    @[Link("gcc_s")]
    @[Link("util")]
    @[Link("rt")]
    @[Link("pthread")]
    @[Link("m")]
    @[Link("dl")]
    @[Link("c")]
  {% end %}
  @[Link("tiktoken_c")]
  lib LibTiktoken
    alias Rank = UInt32

    type CoreBPE = Void
    type ChatCompletionRequestMessage = Void

    fun init_logger = tiktoken_init_logger
    fun chat_message_new = tiktoken_chat_message_new(role : LibC::Char*) : ChatCompletionRequestMessage*
    fun chat_message_set_role = tiktoken_chat_message_set_role(message : ChatCompletionRequestMessage*, role : LibC::Char*) : Bool
    fun chat_message_set_content = tiktoken_chat_message_set_content(message : ChatCompletionRequestMessage*, content : LibC::Char*) : Bool
    fun chat_message_set_name = tiktoken_chat_message_set_name(message : ChatCompletionRequestMessage*, name : LibC::Char*) : Bool
    fun chat_message_set_function_call = tiktoken_chat_message_set_function_call(message : ChatCompletionRequestMessage*, name : LibC::Char*, arguments : LibC::Char*) : Bool
    fun chat_message_clear_function_call = tiktoken_chat_message_clear_function_call(message : ChatCompletionRequestMessage*)
    fun chat_message_add_tool_call = tiktoken_chat_message_add_tool_call(message : ChatCompletionRequestMessage*, name : LibC::Char*, arguments : LibC::Char*) : Bool
    fun chat_message_clear_tool_calls = tiktoken_chat_message_clear_tool_calls(message : ChatCompletionRequestMessage*)
    fun chat_message_set_refusal = tiktoken_chat_message_set_refusal(message : ChatCompletionRequestMessage*, refusal : LibC::Char*) : Bool
    fun chat_message_destroy = tiktoken_chat_message_destroy(message : ChatCompletionRequestMessage*)
    fun r50k_base = tiktoken_r50k_base : CoreBPE*
    fun p50k_base = tiktoken_p50k_base : CoreBPE*
    fun p50k_edit = tiktoken_p50k_edit : CoreBPE*
    fun cl100k_base = tiktoken_cl100k_base : CoreBPE*
    fun o200k_base = tiktoken_o200k_base : CoreBPE*
    fun o200k_harmony = tiktoken_o200k_harmony : CoreBPE*
    fun destroy_corebpe = tiktoken_destroy_corebpe(corebpe : CoreBPE*)
    fun get_text_completion_max_tokens = tiktoken_get_text_completion_max_tokens(model : LibC::Char*, prompt : LibC::Char*) : LibC::SizeT
    fun num_tokens_from_messages = tiktoken_num_tokens_from_messages(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage**) : LibC::SizeT
    fun get_chat_completion_max_tokens = tiktoken_get_chat_completion_max_tokens(model : LibC::Char*, num_messages : UInt32, messages : ChatCompletionRequestMessage**) : LibC::SizeT
    fun get_bpe_from_model = tiktoken_get_bpe_from_model(model : LibC::Char*) : CoreBPE*
    fun corebpe_encode_ordinary = tiktoken_corebpe_encode_ordinary(corebpe : CoreBPE*, text : LibC::Char*, num_tokens : LibC::SizeT*) : Rank*
    fun corebpe_count_ordinary = tiktoken_corebpe_count_ordinary(corebpe : CoreBPE*, text : LibC::Char*) : LibC::SizeT
    fun corebpe_encode = tiktoken_corebpe_encode(corebpe : CoreBPE*, text : LibC::Char*, allowed_special : LibC::Char**, allowed_special_len : LibC::SizeT, num_tokens : LibC::SizeT*) : Rank*
    fun corebpe_count = tiktoken_corebpe_count(corebpe : CoreBPE*, text : LibC::Char*, allowed_special : LibC::Char**, allowed_special_len : LibC::SizeT) : LibC::SizeT
    fun corebpe_encode_with_special_tokens = tiktoken_corebpe_encode_with_special_tokens(corebpe : CoreBPE*, text : LibC::Char*, num_tokens : LibC::SizeT*) : Rank*
    fun corebpe_count_with_special_tokens = tiktoken_corebpe_count_with_special_tokens(corebpe : CoreBPE*, text : LibC::Char*) : LibC::SizeT
    fun corebpe_decode = tiktoken_corebpe_decode(corebpe : CoreBPE*, tokens : Rank*, num_tokens : LibC::SizeT) : LibC::Char*
    fun corebpe_decode_bytes = tiktoken_corebpe_decode_bytes(corebpe : CoreBPE*, tokens : Rank*, num_tokens : LibC::SizeT, num_bytes : LibC::SizeT*) : UInt8*
    fun free = tiktoken_free(ptr : Void*)
    fun c_version = tiktoken_c_version : LibC::Char*
  end
end
