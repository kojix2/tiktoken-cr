require "./libtiktoken"

module Tiktoken
  class Encoding
    class EncodeError < Exception; end

    class DecodeError < Exception; end

    private def initialize(corebpe : Pointer(Tiktoken::LibTiktoken::CoreBPE))
      @corebpe = corebpe
    end

    def self.for_model(model_name : String)
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model(model_name)
      raise "Failed to get BPE from model #{model_name}" if corebpe.null?
      new(corebpe)
    end

    def encode_ordinary(text : String)
      num_tokens = Pointer(LibC::SizeT).malloc(1)
      tokens = Tiktoken::LibTiktoken.tiktoken_corebpe_encode_ordinary(@corebpe, text, num_tokens)
      raise EncodeError.new("Failed to encode") if tokens.null?
      Array.new(num_tokens[0]) { |i| tokens[i].to_u32 }
    end

    def encode(text : String, allowed_special : Set(String) = Set(String).new)
      allowed_special_len = allowed_special.size
      allowed_special_ptr = Pointer(Pointer(LibC::Char)).malloc(allowed_special_len)
      allowed_special.each_with_index do |special, i|
        allowed_special_ptr[i] = Pointer(LibC::Char).malloc(special.bytesize + 1)
        special.bytes.each_with_index do |byte, j|
          allowed_special_ptr[i][j] = byte
        end
      end
      num_tokens = Pointer(LibC::SizeT).malloc(1)
      tokens = Tiktoken::LibTiktoken.tiktoken_corebpe_encode(@corebpe, text, allowed_special_ptr, allowed_special_len, num_tokens)
      raise EncodeError.new("Failed to encode") if tokens.null?
      Array.new(num_tokens[0]) { |i| tokens[i].to_u32 }
    end

    def encode_with_special_tokens(text : String)
      num_tokens = Pointer(LibC::SizeT).malloc(1)
      tokens = Tiktoken::LibTiktoken.tiktoken_corebpe_encode_with_special_tokens(@corebpe, text, num_tokens)
      raise EncodeError.new("Failed to encode") if tokens.null?
      Array.new(num_tokens[0]) { |i| tokens[i].to_u32 }
    end

    def decode(tokens) : String
      num_tokens = tokens.size
      tokens_ptr = Slice(LibTiktoken::Rank).new(num_tokens) do |i|
        tokens[i].to_u32
      end
      str_ptr = Tiktoken::LibTiktoken.tiktoken_corebpe_decode(@corebpe, tokens_ptr, num_tokens)
      raise DecodeError.new("Failed to decode") if str_ptr.null?
      String.new(str_ptr)
    end

    def finalize
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(@corebpe)
    end
  end
end
