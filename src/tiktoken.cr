require "./tiktoken/libtiktoken"
require "./tiktoken/version"
require "./tiktoken/encoding"

module Tiktoken
  def self.get_encoding(encoding_name)
    raise NotImplementedError
  end

  def self.encoding_for_model(model_name)
    Encoding.for_model(model_name)
  end
end
