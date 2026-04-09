require "spec"
require "../../src/tiktoken"

private def build_message(role : String, content : String? = nil, name : String? = nil, function_call : NamedTuple(name: String, arguments: String)? = nil, refusal : String? = nil, tool_calls : Array(NamedTuple(name: String, arguments: String)) = [] of NamedTuple(name: String, arguments: String))
  message = Tiktoken::LibTiktoken.tiktoken_chat_message_new(role)
  raise "failed to create chat message" if message.null?

  begin
    unless content.nil?
      Tiktoken::LibTiktoken.tiktoken_chat_message_set_content(message, content).should be_true
    end
    unless name.nil?
      Tiktoken::LibTiktoken.tiktoken_chat_message_set_name(message, name).should be_true
    end
    unless function_call.nil?
      Tiktoken::LibTiktoken.tiktoken_chat_message_set_function_call(message, function_call[:name], function_call[:arguments]).should be_true
    end
    tool_calls.each do |tool_call|
      Tiktoken::LibTiktoken.tiktoken_chat_message_add_tool_call(message, tool_call[:name], tool_call[:arguments]).should be_true
    end
    unless refusal.nil?
      Tiktoken::LibTiktoken.tiktoken_chat_message_set_refusal(message, refusal).should be_true
    end
  rescue ex
    Tiktoken::LibTiktoken.tiktoken_chat_message_destroy(message)
    raise ex
  end

  message
end

describe "Tiktoken::LibTiktoken" do
  describe "#get_completion_max_tokens" do
    it "returns the maximum number of tokens for a given model" do
      Tiktoken::LibTiktoken.tiktoken_get_completion_max_tokens("gpt-4", "I am a tanuki.").should eq 8186
    end

    it "returns the maximum number of tokens for a given model and empty string" do
      n = Tiktoken::LibTiktoken.tiktoken_get_completion_max_tokens("gpt-4", "")
      n.should eq 8192
    end

    it "returns LibC::SizeT::MAX if the model is not found" do
      n = Tiktoken::LibTiktoken.tiktoken_get_completion_max_tokens("cat-dog", "I am a tanuki.")
      n.should eq LibC::SizeT::MAX
    end

    it "returns LibC::SizeT::MAX if the model is nil" do
      n = Tiktoken::LibTiktoken.tiktoken_get_completion_max_tokens(nil, "I am a tanuki.")
      n.should eq LibC::SizeT::MAX
    end

    it "returns LibC::SizeT::MAX if the prompt is nil" do
      n = Tiktoken::LibTiktoken.tiktoken_get_completion_max_tokens("gpt-4", nil)
      n.should eq LibC::SizeT::MAX
    end
  end

  describe "encoding factories" do
    it "returns CoreBPE for r50k_base" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_r50k_base
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns CoreBPE for p50k_base" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_p50k_base
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns CoreBPE for p50k_edit" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_p50k_edit
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns CoreBPE for cl100k_base" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_cl100k_base
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns CoreBPE for o200k_base" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_o200k_base
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end
  end

  describe "chat message builder" do
    it "creates and destroys a message" do
      message = Tiktoken::LibTiktoken.tiktoken_chat_message_new("assistant")
      message.null?.should be_false
      Tiktoken::LibTiktoken.tiktoken_chat_message_destroy(message)
    end

    it "sets optional fields and tool calls" do
      message = build_message(
        "assistant",
        content: "I'll call the weather tool.",
        name: "planner",
        function_call: {name: "get_weather", arguments: %({"location":"Tokyo"})},
        refusal: "I cannot help with that request.",
        tool_calls: [
          {name: "get_weather", arguments: %({"location":"Tokyo"})},
        ]
      )

      Tiktoken::LibTiktoken.tiktoken_chat_message_clear_function_call(message)
      Tiktoken::LibTiktoken.tiktoken_chat_message_clear_tool_calls(message)
      Tiktoken::LibTiktoken.tiktoken_chat_message_destroy(message)
    end
  end

  describe "chat token counting" do
    it "returns the number of tokens in a given message" do
      messages = [
        build_message(
          "system",
          content: "You are a helpful, pattern-following assistant that translates corporate jargon into plain English."
        ),
      ]

      begin
        Tiktoken::LibTiktoken.tiktoken_num_tokens_from_messages("gpt-3.5-turbo-0301", messages.size, messages.to_unsafe).should eq 26
      ensure
        messages.each { |pointer| Tiktoken::LibTiktoken.tiktoken_chat_message_destroy(pointer) }
      end
    end

    it "returns the number of tokens in multiple messages" do
      messages = [
        build_message("system", content: "You are a helpful assistant that only speaks French."),
        build_message("user", content: "Hello, how are you?"),
        build_message("assistant", content: "Parlez-vous francais?"),
      ]

      begin
        Tiktoken::LibTiktoken.tiktoken_num_tokens_from_messages("gpt-4", messages.size, messages.to_unsafe).should eq 36
      ensure
        messages.each { |pointer| Tiktoken::LibTiktoken.tiktoken_chat_message_destroy(pointer) }
      end
    end

    it "returns the maximum number of tokens for a given message" do
      messages = [build_message("system", content: "You are a helpful assistant that only speaks French.")]

      begin
        Tiktoken::LibTiktoken.tiktoken_get_chat_completion_max_tokens("gpt-3.5-turbo", messages.size, messages.to_unsafe).should eq 16368
      ensure
        messages.each { |pointer| Tiktoken::LibTiktoken.tiktoken_chat_message_destroy(pointer) }
      end
    end
  end

  describe "#tiktoken_get_bpe_from_model" do
    it "returns a pointer to a CoreBPE for gpt-4" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model("gpt-4")
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      corebpe.null?.should be_false
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns a pointer to a CoreBPE for gpt-4o" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model("gpt-4o")
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      corebpe.null?.should be_false
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns a null pointer for an invalid model" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model("cat-dog")
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      corebpe.null?.should be_true
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end
  end

  describe "token encode, count, and decode" do
    it "encodes, counts, and decodes ordinary tokens" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_r50k_base
      string = "This is a very beautiful day."
      num_tokens = Pointer(LibC::SizeT).malloc(1, 0)
      arr_ptr = Tiktoken::LibTiktoken.tiktoken_corebpe_encode_ordinary(corebpe, string, num_tokens)

      begin
        n = num_tokens[0]
        t = Array.new(n) { |i| arr_ptr[i].to_u32 }
        t.should eq [1212, 318, 257, 845, 4950, 1110, 13]
        Tiktoken::LibTiktoken.tiktoken_corebpe_count_ordinary(corebpe, string).should eq n

        decoded = Tiktoken::LibTiktoken.tiktoken_corebpe_decode(corebpe, arr_ptr, n)
        String.new(decoded).should eq string
        Tiktoken::LibTiktoken.tiktoken_free(decoded.as(Void*))

        num_bytes = Pointer(LibC::SizeT).malloc(1, 0)
        decoded_bytes = Tiktoken::LibTiktoken.tiktoken_corebpe_decode_bytes(corebpe, arr_ptr, n, num_bytes)
        Bytes.new(num_bytes[0].to_i) { |i| decoded_bytes[i] }.should eq string.to_slice
        Tiktoken::LibTiktoken.tiktoken_free(decoded_bytes.as(Void*))
      ensure
        Tiktoken::LibTiktoken.tiktoken_free(arr_ptr.as(Void*)) unless arr_ptr.null?
        Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
      end
    end

    it "counts and encodes special tokens" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model("gpt-4")
      allowed_special_ptr = Pointer(Pointer(LibC::Char)).malloc(1)
      allowed_special_ptr[0] = "<|endoftext|>".to_unsafe
      num_tokens = Pointer(LibC::SizeT).malloc(1, 0)
      arr_ptr = Tiktoken::LibTiktoken.tiktoken_corebpe_encode(corebpe, "Hello world <|endoftext|>", allowed_special_ptr, 1, num_tokens)

      begin
        Array.new(num_tokens[0]) { |i| arr_ptr[i].to_u32 }.should eq [9906, 1917, 220, 100257]
        Tiktoken::LibTiktoken.tiktoken_corebpe_count(corebpe, "Hello world <|endoftext|>", allowed_special_ptr, 1).should eq num_tokens[0]
        Tiktoken::LibTiktoken.tiktoken_corebpe_count_with_special_tokens(corebpe, "Hello world <|endoftext|>").should eq 4
      ensure
        Tiktoken::LibTiktoken.tiktoken_free(arr_ptr.as(Void*)) unless arr_ptr.null?
        Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
      end
    end
  end

  describe "#tiktoken_c_version" do
    it "returns a pointer of tiktoken_c version number" do
      v = Tiktoken::LibTiktoken.tiktoken_c_version
      v.should be_a(Pointer(UInt8))
      v.null?.should be_false
    end
  end
end
