# tiktoken-c

This library adds a simple API for C to [tiktoken-rs](https://github.com/zurawiki/tiktoken-rs).

## API
    
```c
struct CFunctionCall {
  const char *name;
  const char *arguments;
};

struct CChatCompletionRequestMessage {
  const char *role;
  const char *content;
  const char *name;
  const FunctionCall *function_call; // optional (NULL)

CoreBPE *c_r50k_base(void);

CoreBPE *c_p50k_base(void);

CoreBPE *c_p50k_edit(void);

CoreBPE *c_cl100k_base(void);

uintptr_t c_get_completion_max_tokens(const char *model, const char *prompt);

uintptr_t c_num_tokens_from_messages(const char *model,
                                     uint32_t num_messages,
                                     const struct CChatCompletionRequestMessage *messages);

uintptr_t c_get_chat_completion_max_tokens(const char *model,
                                           uint32_t num_messages,
                                           const struct CChatCompletionRequestMessage *messages);

CoreBPE *c_get_bpe_from_model(const char *model);

uintptr_t *c_corebpe_encode_ordinary(CoreBPE *ptr, const char *text, uintptr_t *num_tokens);

uintptr_t *c_corebpe_encode_with_special_tokens(CoreBPE *ptr,
                                                const char *text,
                                                uintptr_t *num_tokens);

char *c_corebpe_decode(CoreBPE *ptr, const uintptr_t *tokens, uintptr_t num_tokens);
```

See https://github.com/zurawiki/tiktoken-rs/blob/main/tiktoken-rs/src/api.rs