require "spec"
require "../../src/tiktoken/encoding"

describe "Tiktoken::Encoding" do
  describe "#for_model" do
    it "should return the BPE for the model" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      e.should be_a(Tiktoken::Encoding)
    end

    it "should raise an error if the model is not supported" do
      expect_raises(Exception) do
        Tiktoken::Encoding.for_model("cat-dog")
      end
    end
  end

  describe "#encode_ordinary" do
    it "should encode the text" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      tokens = e.encode_ordinary("Hello world")
      tokens.should eq [9906, 1917]
    end

    it "should encode the unicode text" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      tokens = e.encode_ordinary("Hello world 🤖")
      tokens.should eq [9906, 1917, 11410, 97, 244]
    end
  end

  describe "#encode" do
    it "should encode the text" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      tokens = e.encode("Hello world")
      tokens.should eq [9906, 1917]
    end

    it "should encode the text and ignore special tokens" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      tokens = e.encode("Hello world <|endoftext|>")
      tokens.should eq [9906, 1917, 83739, 8862, 728, 428, 91, 29]
    end

    it "should encode the text with special tokens" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      tokens = e.encode("Hello world <|endoftext|>", allowed_special: Set{"<|endoftext|>"})
      tokens.should eq [9906, 1917, 220, 100257]
    end
  end

  describe "#encode_with_special_tokens" do
    it "should encode the text" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      tokens = e.encode_with_special_tokens("Hello world <|endoftext|>")
      tokens.should eq [9906, 1917, 220, 100257]
    end
  end

  describe "#decode" do
    it "should decode the tokens" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      text = e.decode([9906, 1917])
      text.should eq "Hello world"
    end

    it "should decode the tokens with special tokens" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      text = e.decode([9906, 1917, 220, 100257])
      text.should eq "Hello world <|endoftext|>"
    end

    it "should decode the tokens with special tokens as string" do
      e = Tiktoken::Encoding.for_model("gpt-4")
      text = e.decode([9906, 1917, 83739, 8862, 728, 428, 91, 29])
      text.should eq "Hello world <|endoftext|>"
    end
  end

  describe "encoding factories" do
    it "should create r50k_base encoding" do
      e = Tiktoken::Encoding.r50k_base
      e.should be_a(Tiktoken::Encoding)
    end

    it "should create p50k_base encoding" do
      e = Tiktoken::Encoding.p50k_base
      e.should be_a(Tiktoken::Encoding)
    end

    it "should create p50k_edit encoding" do
      e = Tiktoken::Encoding.p50k_edit
      e.should be_a(Tiktoken::Encoding)
    end

    it "should create cl100k_base encoding" do
      e = Tiktoken::Encoding.cl100k_base
      e.should be_a(Tiktoken::Encoding)
    end

    it "should create o200k_base encoding" do
      e = Tiktoken::Encoding.o200k_base
      e.should be_a(Tiktoken::Encoding)
    end

    it "should create o200k_harmony encoding" do
      e = Tiktoken::Encoding.o200k_harmony
      e.should be_a(Tiktoken::Encoding)
    end
  end

  it "should encode and decode the text" do
    e = Tiktoken::Encoding.for_model("gpt-4")
    text = "吾輩は猫である。名前はたぬき。"
    tokens = e.encode(text)
    decoded_text = e.decode(tokens)
    decoded_text.should eq text
  end
end
