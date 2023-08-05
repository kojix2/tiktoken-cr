module Tiktoken
  @[Link("tiktoken_cr")]
  lib LibTiktoken
    fun get_completion_max_tokens_raw(model : LibC::Char*, prompt : LibC::Char*) : Int32
  end
end
