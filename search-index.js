crystal_doc_search_index_callback({"repository_name":"tiktoken","body":"# tiktoken-cr\n\n[![test](https://github.com/kojix2/tiktoken-cr/actions/workflows/test.yml/badge.svg)](https://github.com/kojix2/tiktoken-cr/actions/workflows/test.yml)\n\nTiktoken for Crystalists.\n\n- [tiktoken-rs](https://github.com/zurawiki/tiktoken-rs)\n- [tiktoken-c](https://github.com/kojix2/tiktoken-c)\n\n## Usage\n\n```crystal\nrequire \"../src/tiktoken.cr\"\n\ntext = \"吾輩は猫である。名前はたぬき。\"\n\nencoding = Tiktoken.encoding_for_model(\"gpt-4\")\ntokens = encoding.encode_with_special_tokens(text)\n# [7305, 122, 164, 120, 102, 15682, 163, 234, 104, 16556, 30591, 30369, 1811, 13372, 25580, 15682, 28713, 2243, 105, 50834, 1811]\n\nencoding.decode(tokens)\n# \"吾輩は猫である。名前はたぬき。\"\n```\n\nCount the number of ChatGPT tokens\n\n```crystal\nmodel = \"gpt-4\"\nmessages = [\n  {\n    \"role\"    => \"system\",\n    \"content\" => \"You are a helpful assistant that only speaks French.\",\n  },\n  {\n    \"role\"    => \"user\",\n    \"content\" => \"Hello, how are you?\",\n  },\n  {\n    \"role\"    => \"assistant\",\n    \"content\" => \"Parlez-vous francais?\",\n  },\n]\n\nTiktoken.num_tokens_from_messages(model, messages)\n# 36\n\nTiktoken.chat_completion_max_tokens(model, messages)\n# 8156\n```\n\n## Documentation\n\n[API Documentation](https://kojix2.github.io/tiktoken-cr/)\n\n## Contributing\n\n- Report bugs\n- Fix bugs and submit pull requests\n- Write, clarify, or fix documentation\n- Suggest or add new features\n- Make a donation\n\n## Acknowledgement\n\nThis project is inspired by [tiktoken_ruby](https://github.com/IAPark/tiktoken_ruby).\n## LICENSE\n\nMIT\n","program":{"html_id":"tiktoken/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"locations":[],"repository_name":"tiktoken","program":true,"enum":false,"alias":false,"const":false,"types":[{"html_id":"tiktoken/Tiktoken","path":"Tiktoken.html","kind":"module","full_name":"Tiktoken","name":"Tiktoken","abstract":false,"locations":[{"filename":"src/tiktoken.cr","line_number":5,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken.cr#L5"},{"filename":"src/tiktoken/encoding.cr","line_number":3,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L3"},{"filename":"src/tiktoken/libtiktoken.cr","line_number":1,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/libtiktoken.cr#L1"},{"filename":"src/tiktoken/version.cr","line_number":1,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/version.cr#L1"}],"repository_name":"tiktoken","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"{{ (`shards version /home/runner/work/tiktoken-cr/tiktoken-cr/src/tiktoken`).chomp.stringify }}"}],"class_methods":[{"html_id":"chat_completion_max_tokens(model,messages)-class-method","name":"chat_completion_max_tokens","abstract":false,"args":[{"name":"model","external_name":"model","restriction":""},{"name":"messages","external_name":"messages","restriction":""}],"args_string":"(model, messages)","args_html":"(model, messages)","location":{"filename":"src/tiktoken.cr","line_number":44,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken.cr#L44"},"def":{"name":"chat_completion_max_tokens","args":[{"name":"model","external_name":"model","restriction":""},{"name":"messages","external_name":"messages","restriction":""}],"visibility":"Public","body":"num_messages = messages.size\nmessages_ptr = Pointer(LibTiktoken::ChatCompletionRequestMessage).malloc(num_messages)\nmessages.each_with_index do |message, i|\n  role = message[\"role\"]\n  content = message.has_key?(\"content\") ? message[\"content\"].to_unsafe : Pointer(LibC::Char).null\n  name = message.has_key?(\"name\") ? message[\"name\"].to_unsafe : Pointer(LibC::Char).null\n  function_call = if message.has_key?(\"function_call\")\n    Pointer(LibTiktoken::FunctionCall).malloc(1) do\n      LibTiktoken::FunctionCall.new(name: message[\"function_call\"][\"name\"], arguments: message[\"function_call\"][\"arguments\"])\n    end\n  else\n    Pointer(LibTiktoken::FunctionCall).null\n  end\n  messages_ptr[i] = LibTiktoken::ChatCompletionRequestMessage.new(role: role, content: content, name: name, function_call: function_call)\nend\n(LibTiktoken.c_get_chat_completion_max_tokens(model, num_messages, messages_ptr)).tap do |n|\n  if n == LibC::SizeT::MAX\n    raise(\"Error in chat_completion_max_tokens\")\n  end\nend\n"}},{"html_id":"encoding_for_model(model_name)-class-method","name":"encoding_for_model","abstract":false,"args":[{"name":"model_name","external_name":"model_name","restriction":""}],"args_string":"(model_name)","args_html":"(model_name)","location":{"filename":"src/tiktoken.cr","line_number":10,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken.cr#L10"},"def":{"name":"encoding_for_model","args":[{"name":"model_name","external_name":"model_name","restriction":""}],"visibility":"Public","body":"Encoding.for_model(model_name)"}},{"html_id":"get_encoding(encoding_name)-class-method","name":"get_encoding","abstract":false,"args":[{"name":"encoding_name","external_name":"encoding_name","restriction":""}],"args_string":"(encoding_name)","args_html":"(encoding_name)","location":{"filename":"src/tiktoken.cr","line_number":6,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken.cr#L6"},"def":{"name":"get_encoding","args":[{"name":"encoding_name","external_name":"encoding_name","restriction":""}],"visibility":"Public","body":"raise(NotImplementedError)"}},{"html_id":"num_tokens_from_messages(model,messages)-class-method","name":"num_tokens_from_messages","abstract":false,"args":[{"name":"model","external_name":"model","restriction":""},{"name":"messages","external_name":"messages","restriction":""}],"args_string":"(model, messages)","args_html":"(model, messages)","location":{"filename":"src/tiktoken.cr","line_number":14,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken.cr#L14"},"def":{"name":"num_tokens_from_messages","args":[{"name":"model","external_name":"model","restriction":""},{"name":"messages","external_name":"messages","restriction":""}],"visibility":"Public","body":"num_messages = messages.size\nmessages_ptr = Pointer(LibTiktoken::ChatCompletionRequestMessage).malloc(num_messages)\nmessages.each_with_index do |message, i|\n  role = message[\"role\"]\n  content = message.has_key?(\"content\") ? message[\"content\"].to_unsafe : Pointer(LibC::Char).null\n  name = message.has_key?(\"name\") ? message[\"name\"].to_unsafe : Pointer(LibC::Char).null\n  function_call = if message.has_key?(\"function_call\")\n    Pointer(LibTiktoken::FunctionCall).malloc(1) do\n      LibTiktoken::FunctionCall.new(name: message[\"function_call\"][\"name\"], arguments: message[\"function_call\"][\"arguments\"])\n    end\n  else\n    Pointer(LibTiktoken::FunctionCall).null\n  end\n  messages_ptr[i] = LibTiktoken::ChatCompletionRequestMessage.new(role: role, content: content, name: name, function_call: function_call)\nend\n(LibTiktoken.c_num_tokens_from_messages(model, num_messages, messages_ptr)).tap do |n|\n  if n == LibC::SizeT::MAX\n    raise(\"Error in num_tokens_from_messages\")\n  end\nend\n"}}],"types":[{"html_id":"tiktoken/Tiktoken/Encoding","path":"Tiktoken/Encoding.html","kind":"class","full_name":"Tiktoken::Encoding","name":"Encoding","abstract":false,"superclass":{"html_id":"tiktoken/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"tiktoken/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"tiktoken/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/tiktoken/encoding.cr","line_number":4,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L4"}],"repository_name":"tiktoken","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"tiktoken/Tiktoken","kind":"module","full_name":"Tiktoken","name":"Tiktoken"},"class_methods":[{"html_id":"for_model(model_name:String)-class-method","name":"for_model","abstract":false,"args":[{"name":"model_name","external_name":"model_name","restriction":"String"}],"args_string":"(model_name : String)","args_html":"(model_name : String)","location":{"filename":"src/tiktoken/encoding.cr","line_number":13,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L13"},"def":{"name":"for_model","args":[{"name":"model_name","external_name":"model_name","restriction":"String"}],"visibility":"Public","body":"corebpe = Tiktoken::LibTiktoken.c_get_bpe_from_model(model_name)\nif corebpe.null?\n  raise(\"Failed to get BPE from model #{model_name}\")\nend\nnew(corebpe)\n"}}],"instance_methods":[{"html_id":"decode(tokens):String-instance-method","name":"decode","abstract":false,"args":[{"name":"tokens","external_name":"tokens","restriction":""}],"args_string":"(tokens) : String","args_html":"(tokens) : String","location":{"filename":"src/tiktoken/encoding.cr","line_number":48,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L48"},"def":{"name":"decode","args":[{"name":"tokens","external_name":"tokens","restriction":""}],"return_type":"String","visibility":"Public","body":"num_tokens = tokens.size\ntokens_ptr = Slice(LibC::SizeT).new(num_tokens) do |i|\n  cast_to_sizet(tokens[i])\nend\nstr_ptr = Tiktoken::LibTiktoken.c_corebpe_decode(@corebpe, tokens_ptr, num_tokens)\nif str_ptr.null?\n  raise(DecodeError.new(\"Failed to decode\"))\nend\nString.new(str_ptr)\n"}},{"html_id":"encode(text:String,allowed_special:Set(String)=Set(String).new)-instance-method","name":"encode","abstract":false,"args":[{"name":"text","external_name":"text","restriction":"String"},{"name":"allowed_special","default_value":"Set(String).new","external_name":"allowed_special","restriction":"Set(String)"}],"args_string":"(text : String, allowed_special : Set(String) = Set(String).new)","args_html":"(text : String, allowed_special : Set(String) = <span class=\"t\">Set</span>(<span class=\"t\">String</span>).new)","location":{"filename":"src/tiktoken/encoding.cr","line_number":26,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L26"},"def":{"name":"encode","args":[{"name":"text","external_name":"text","restriction":"String"},{"name":"allowed_special","default_value":"Set(String).new","external_name":"allowed_special","restriction":"Set(String)"}],"visibility":"Public","body":"allowed_special_len = allowed_special.size\nallowed_special_ptr = Pointer(Pointer(LibC::Char)).malloc(allowed_special_len)\nallowed_special.each_with_index do |special, i|\n  allowed_special_ptr[i] = Pointer(LibC::Char).malloc(special.bytesize + 1)\n  special.bytes.each_with_index do |byte, j|\n    allowed_special_ptr[i][j] = byte\n  end\nend\nnum_tokens = Pointer(LibC::SizeT).malloc(1)\ntokens = Tiktoken::LibTiktoken.c_corebpe_encode(@corebpe, text, allowed_special_ptr, allowed_special_len, num_tokens)\nif tokens.null?\n  raise(EncodeError.new(\"Failed to encode\"))\nend\nArray.new(num_tokens[0]) do |i|\n  tokens[i]\nend\n"}},{"html_id":"encode_ordinary(text:String)-instance-method","name":"encode_ordinary","abstract":false,"args":[{"name":"text","external_name":"text","restriction":"String"}],"args_string":"(text : String)","args_html":"(text : String)","location":{"filename":"src/tiktoken/encoding.cr","line_number":19,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L19"},"def":{"name":"encode_ordinary","args":[{"name":"text","external_name":"text","restriction":"String"}],"visibility":"Public","body":"num_tokens = Pointer(LibC::SizeT).malloc(1)\ntokens = Tiktoken::LibTiktoken.c_corebpe_encode_ordinary(@corebpe, text, num_tokens)\nif tokens.null?\n  raise(EncodeError.new(\"Failed to encode\"))\nend\nArray.new(num_tokens[0]) do |i|\n  tokens[i]\nend\n"}},{"html_id":"encode_with_special_tokens(text:String)-instance-method","name":"encode_with_special_tokens","abstract":false,"args":[{"name":"text","external_name":"text","restriction":"String"}],"args_string":"(text : String)","args_html":"(text : String)","location":{"filename":"src/tiktoken/encoding.cr","line_number":41,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L41"},"def":{"name":"encode_with_special_tokens","args":[{"name":"text","external_name":"text","restriction":"String"}],"visibility":"Public","body":"num_tokens = Pointer(LibC::SizeT).malloc(1)\ntokens = Tiktoken::LibTiktoken.c_corebpe_encode_with_special_tokens(@corebpe, text, num_tokens)\nif tokens.null?\n  raise(EncodeError.new(\"Failed to encode\"))\nend\nArray.new(num_tokens[0]) do |i|\n  tokens[i]\nend\n"}},{"html_id":"finalize-instance-method","name":"finalize","abstract":false,"location":{"filename":"src/tiktoken/encoding.cr","line_number":70,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L70"},"def":{"name":"finalize","visibility":"Public","body":"Tiktoken::LibTiktoken.c_destroy_corebpe(@corebpe)"}}],"types":[{"html_id":"tiktoken/Tiktoken/Encoding/DecodeError","path":"Tiktoken/Encoding/DecodeError.html","kind":"class","full_name":"Tiktoken::Encoding::DecodeError","name":"DecodeError","abstract":false,"superclass":{"html_id":"tiktoken/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"tiktoken/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"tiktoken/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"tiktoken/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/tiktoken/encoding.cr","line_number":7,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L7"}],"repository_name":"tiktoken","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"tiktoken/Tiktoken/Encoding","kind":"class","full_name":"Tiktoken::Encoding","name":"Encoding"}},{"html_id":"tiktoken/Tiktoken/Encoding/EncodeError","path":"Tiktoken/Encoding/EncodeError.html","kind":"class","full_name":"Tiktoken::Encoding::EncodeError","name":"EncodeError","abstract":false,"superclass":{"html_id":"tiktoken/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"tiktoken/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"tiktoken/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"tiktoken/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/tiktoken/encoding.cr","line_number":5,"url":"https://github.com/kojix2/tiktoken-cr/blob/65b28a866588ec0833711d862e40bb533fd9e872/src/tiktoken/encoding.cr#L5"}],"repository_name":"tiktoken","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"tiktoken/Tiktoken/Encoding","kind":"class","full_name":"Tiktoken::Encoding","name":"Encoding"}}]}]}]}})