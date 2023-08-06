require "spec"
require "../../src/tiktoken"

describe "Tiktoken::LibTiktoken" do
  describe "#get_completion_max_tokens" do
    it "returns the maximum number of tokens for a given model" do
    Tiktoken::LibTiktoken.get_completion_max_tokens_raw("gpt-4", "I am a tanuki.").should eq 8186
    end
  end
end