module Tiktoken
  class Encoding
    private def initialize(corebpe : Pointer(Tiktoken::LibTiktoken::CoreBPE))
      @corebpe = corebpe
    end

    def self.for_model(model_name : String)
      corebpe = Tiktoken::LibTiktoken.c_get_bpe_from_model(model_name)
      new(corebpe)
    end

    def encode_ordinary(text : String)
      num_tokens = Pointer(LibC::SizeT).malloc(1)
      tokens = Tiktoken::LibTiktoken.c_corebpe_encode_ordinary(@corebpe, text, num_tokens)
      Array.new(num_tokens[0]) { |i| tokens[i] } # always be UInt64 here?
    end

    def encode(text : String, allowed_special : Array(String))
      allowed_special_len = allowed_special.size
      allowed_special_ptr = Pointer(Pointer(LibC::Char)).malloc(allowed_special_len)
      allowed_special.each_with_index do |special, i|
        allowed_special_ptr[i] = Pointer(LibC::Char).malloc(special.bytesize + 1)
        special.bytes.each_with_index do |byte, j|
          allowed_special_ptr[i][j] = byte
        end
      end
      num_tokens = Pointer(LibC::SizeT).malloc(1)
      tokens = Tiktoken::LibTiktoken.c_corebpe_encode(@corebpe, text, allowed_special_ptr, allowed_special_len, num_tokens)
      Array.new(num_tokens[0]) { |i| tokens[i] } # always be UInt64 here?
    end

    def encode_with_special_tokens(text : String)
      num_tokens = Pointer(LibC::SizeT).malloc(1)
      tokens = Tiktoken::LibTiktoken.c_corebpe_encode_with_special_tokens(@corebpe, text, num_tokens)
      Array.new(num_tokens[0]) { |i| tokens[i] } # always be UInt64 here?
    end

    def decode(tokens) : String
      num_tokens = tokens.size
      str_ptr = Tiktoken::LibTiktoken.c_corebpe_decode(@corebpe, tokens, num_tokens)
      String.new(str_ptr)
    end

    def finalize
      Tiktoken::LibTiktoken.c_destroy_corebpe(@corebpe)
    end
  end
end
