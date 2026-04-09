require "./libtiktoken"

module Tiktoken
  class Encoding
    class EncodeError < Exception; end

    class DecodeError < Exception; end

    private struct AllowedSpecialArg
      getter values : Array(String)
      getter pointers : Pointer(Pointer(LibC::Char))
      getter length : LibC::SizeT

      def initialize(@values : Array(String), @pointers : Pointer(Pointer(LibC::Char)), @length : LibC::SizeT)
      end
    end

    private def initialize(corebpe : Pointer(Tiktoken::LibTiktoken::CoreBPE))
      @corebpe = corebpe
    end

    def self.for_model(model_name : String)
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model(model_name)
      raise "Failed to get BPE from model #{model_name}" if corebpe.null?
      new(corebpe)
    end

    def self.r50k_base
      new(Tiktoken::LibTiktoken.tiktoken_r50k_base)
    end

    def self.p50k_base
      new(Tiktoken::LibTiktoken.tiktoken_p50k_base)
    end

    def self.p50k_edit
      new(Tiktoken::LibTiktoken.tiktoken_p50k_edit)
    end

    def self.cl100k_base
      new(Tiktoken::LibTiktoken.tiktoken_cl100k_base)
    end

    def self.o200k_base
      new(Tiktoken::LibTiktoken.tiktoken_o200k_base)
    end

    def self.o200k_harmony
      new(Tiktoken::LibTiktoken.tiktoken_o200k_harmony)
    end

    def encode_ordinary(text : String)
      num_tokens = Pointer(LibC::SizeT).malloc(1, 0)
      tokens = Tiktoken::LibTiktoken.tiktoken_corebpe_encode_ordinary(@corebpe, text, num_tokens)
      tokens_to_a(tokens, num_tokens[0])
    end

    def encode(text : String, allowed_special : Set(String) = Set(String).new)
      with_allowed_special(allowed_special) do |arg|
        num_tokens = Pointer(LibC::SizeT).malloc(1, 0)
        tokens = Tiktoken::LibTiktoken.tiktoken_corebpe_encode(@corebpe, text, arg.pointers, arg.length, num_tokens)
        tokens_to_a(tokens, num_tokens[0])
      end
    end

    def encode_with_special_tokens(text : String)
      num_tokens = Pointer(LibC::SizeT).malloc(1, 0)
      tokens = Tiktoken::LibTiktoken.tiktoken_corebpe_encode_with_special_tokens(@corebpe, text, num_tokens)
      tokens_to_a(tokens, num_tokens[0])
    end

    def count_ordinary(text : String) : Int32
      count = Tiktoken::LibTiktoken.tiktoken_corebpe_count_ordinary(@corebpe, text)
      check_count_result(count, "Failed to count tokens")
    end

    def count(text : String, allowed_special : Set(String) = Set(String).new) : Int32
      with_allowed_special(allowed_special) do |arg|
        count = Tiktoken::LibTiktoken.tiktoken_corebpe_count(@corebpe, text, arg.pointers, arg.length)
        check_count_result(count, "Failed to count tokens")
      end
    end

    def count_with_special_tokens(text : String) : Int32
      count = Tiktoken::LibTiktoken.tiktoken_corebpe_count_with_special_tokens(@corebpe, text)
      check_count_result(count, "Failed to count tokens")
    end

    def decode(tokens) : String
      num_tokens = tokens.size
      return "" if num_tokens == 0

      token_slice = token_slice(tokens)
      str_ptr = Tiktoken::LibTiktoken.tiktoken_corebpe_decode(@corebpe, token_slice.to_unsafe, num_tokens)
      if str_ptr.null?
        raise DecodeError.new("Failed to decode")
      end
      result = String.new(str_ptr)
      Tiktoken::LibTiktoken.tiktoken_free(str_ptr.as(Void*))
      result
    end

    def decode_bytes(tokens) : Bytes
      num_tokens = tokens.size
      return Bytes.empty if num_tokens == 0

      token_slice = token_slice(tokens)
      num_bytes = Pointer(LibC::SizeT).malloc(1, 0)
      bytes_ptr = Tiktoken::LibTiktoken.tiktoken_corebpe_decode_bytes(@corebpe, token_slice.to_unsafe, num_tokens, num_bytes)
      if bytes_ptr.null?
        raise DecodeError.new("Failed to decode bytes")
      end

      result = Bytes.new(num_bytes[0].to_i) { |i| bytes_ptr[i] }
      Tiktoken::LibTiktoken.tiktoken_free(bytes_ptr.as(Void*))
      result
    end

    def finalize
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(@corebpe)
    end

    private def token_slice(tokens)
      Slice(LibTiktoken::Rank).new(tokens.size) do |i|
        tokens[i].to_u32
      end
    end

    private def tokens_to_a(tokens : Pointer(LibTiktoken::Rank), num_tokens : LibC::SizeT) : Array(UInt32)
      if tokens.null?
        return [] of UInt32 if num_tokens == 0
        raise EncodeError.new("Failed to encode")
      end

      result = Array.new(num_tokens) { |i| tokens[i].to_u32 }
      Tiktoken::LibTiktoken.tiktoken_free(tokens.as(Void*))
      result
    end

    private def check_count_result(count : LibC::SizeT, message : String) : Int32
      raise EncodeError.new(message) if count == LibC::SizeT::MAX
      count.to_i
    end

    private def with_allowed_special(allowed_special : Set(String), &)
      values = allowed_special.to_a
      pointers = Pointer(Pointer(LibC::Char)).malloc(Math.max(values.size, 1), Pointer(LibC::Char).null)
      values.each_with_index do |value, index|
        pointers[index] = value.to_unsafe
      end
      yield AllowedSpecialArg.new(values, pointers, values.size.to_u64)
    end
  end
end
