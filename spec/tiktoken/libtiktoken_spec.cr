require "spec"
require "../../src/tiktoken"

describe "Tiktoken::LibTiktoken" do
  describe "#get_completion_max_tokens" do
    it "returns the maximum number of tokens for a given model" do
      Tiktoken::LibTiktoken.tiktoken_get_completion_max_tokens("gpt-4", "I am a tanuki.").should eq 8186
    end

    it "returns the maximum number of tokens for a given model and \"\"" do
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

  describe "#r50k_base" do
    it "returns CoreBPE" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_r50k_base
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end
  end

  describe "#p50k_base" do
    it "returns CoreBPE" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_p50k_base
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end
  end

  describe "#p50k_edit" do
    it "returns CoreBPE" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_p50k_edit
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end
  end

  describe "#cl100k_base" do
    it "returns CoreBPE" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_cl100k_base
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end
  end

  describe "#o200k_base" do
    it "returns CoreBPE" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_o200k_base
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end
  end

  describe "#num_tokens_from_messages" do
    it "returns the number of tokens in a given message" do
      model = "gpt-3.5-turbo-0301"
      message = Tiktoken::LibTiktoken::CChatCompletionRequestMessage.new(
        role: "system",
        name: nil,
        content: "You are a helpful, pattern-following assistant that translates corporate jargon into plain English.",
        function_call: nil
      )
      messages = Pointer(Tiktoken::LibTiktoken::CChatCompletionRequestMessage).malloc(1)
      messages[0] = message
      Tiktoken::LibTiktoken.tiktoken_num_tokens_from_messages(model, 1, messages).should eq 26
    end

    it "returns the number of tokens in a given messages" do
      model = "gpt-4"
      message_array = [
        Tiktoken::LibTiktoken::CChatCompletionRequestMessage.new(
          role: "system",
          name: nil,
          content: "You are a helpful assistant that only speaks French.",
          function_call: nil
        ),
        Tiktoken::LibTiktoken::CChatCompletionRequestMessage.new(
          role: "user",
          name: nil,
          content: "Hello, how are you?",
          function_call: nil
        ),
        Tiktoken::LibTiktoken::CChatCompletionRequestMessage.new(
          role: "assistant",
          name: nil,
          content: "Parlez-vous francais?",
          function_call: nil
        ),
      ]
      messages = Pointer(Tiktoken::LibTiktoken::CChatCompletionRequestMessage).malloc(message_array.size) { |i| message_array[i] }
      Tiktoken::LibTiktoken.tiktoken_num_tokens_from_messages(model, message_array.size, messages).should eq 36
    end
  end

  describe "#get_chat_completion_max_tokens" do
    it "returns the maximum number of tokens for a given message" do
      model = "gpt-3.5-turbo"
      message = Tiktoken::LibTiktoken::CChatCompletionRequestMessage.new(
        role: "system",
        name: nil,
        content: "You are a helpful assistant that only speaks French.",
        function_call: nil
      )
      messages = Pointer(Tiktoken::LibTiktoken::CChatCompletionRequestMessage).malloc(1)
      messages[0] = message
      Tiktoken::LibTiktoken.tiktoken_get_chat_completion_max_tokens(model, 1, messages).should eq 16367
    end

    it "returns the number of tokens in a given messages" do
      model = "gpt-4"
      message_array = [
        Tiktoken::LibTiktoken::CChatCompletionRequestMessage.new(
          role: "system",
          name: nil,
          content: "You are a helpful assistant that only speaks French.",
          function_call: nil
        ),
        Tiktoken::LibTiktoken::CChatCompletionRequestMessage.new(
          role: "user",
          name: nil,
          content: "Hello, how are you?",
          function_call: nil
        ),
        Tiktoken::LibTiktoken::CChatCompletionRequestMessage.new(
          role: "assistant",
          name: nil,
          content: "Parlez-vous francais?",
          function_call: nil
        ),
      ]
      messages = Pointer(Tiktoken::LibTiktoken::CChatCompletionRequestMessage).malloc(message_array.size) { |i| message_array[i] }
      Tiktoken::LibTiktoken.tiktoken_get_chat_completion_max_tokens(model, message_array.size, messages).should eq 8156
    end
  end

  describe "#tiktoken_get_bpe_from_model" do
    it "returns a pointer to a CoreBPE for gpt-3.5-turbo" do
      model = "gpt-3.5-turbo"
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model(model)
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      corebpe.null?.should be_false
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns a pointer to a CoreBPE for gpt-4" do
      model = "gpt-4"
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model(model)
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      corebpe.null?.should be_false
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns a pointer to a CoreBPE for gpt-4o" do
      model = "gpt-4o"
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model(model)
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      corebpe.null?.should be_false
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end

    it "returns a null pointer for a nil model" do
      model = nil
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model(model)
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      corebpe.null?.should be_true
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe) # should work if null
    end

    it "returns a null pointer for an invalid model" do
      model = "cat-dog"
      corebpe = Tiktoken::LibTiktoken.tiktoken_get_bpe_from_model(model)
      corebpe.should be_a(Pointer(Tiktoken::LibTiktoken::CoreBPE))
      corebpe.null?.should be_true
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe) # should work if null
    end
  end

  describe "#tiktoken_corebpe_encode_ordinary" do
    it "returns a pointer to a CoreBPEEncodedString" do
      corebpe = Tiktoken::LibTiktoken.tiktoken_r50k_base
      string = "This is a very beautiful day."
      num_tokens1 = Pointer(LibC::SizeT).malloc(1)
      num_tokens2 = Pointer(LibC::SizeT).malloc(1)
      arr_ptr1 = Tiktoken::LibTiktoken.tiktoken_corebpe_encode_ordinary(corebpe, string, num_tokens1)
      arr_ptr2 = Tiktoken::LibTiktoken.tiktoken_corebpe_encode_with_special_tokens(corebpe, string, num_tokens2)
      n1 = num_tokens1[0]
      n2 = num_tokens2[0]
      t1 = Array.new(n1) { |i| arr_ptr1[i].to_u32 }
      t2 = Array.new(n2) { |i| arr_ptr2[i].to_u32 }
      t1.should eq [1212, 318, 257, 845, 4950, 1110, 13]
      t2.should eq [1212, 318, 257, 845, 4950, 1110, 13]
      s1 = Tiktoken::LibTiktoken.tiktoken_corebpe_decode(corebpe, arr_ptr1, n1)
      s2 = Tiktoken::LibTiktoken.tiktoken_corebpe_decode(corebpe, arr_ptr2, n2)
      String.new(s1).should eq string
      String.new(s2).should eq string
      Tiktoken::LibTiktoken.tiktoken_destroy_corebpe(corebpe)
    end
  end

  describe "#tiktoken_c_version" do
    it "returns a pointer of tiktoken_c version number" do
      v = Tiktoken::LibTiktoken.tiktoken_c_version
      v.should be_a(Pointer(UInt8))
      (v.null?).should be_false
    end
  end
end
