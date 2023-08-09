# tiktoken-c

This library adds a simple API for C to [tiktoken-rs](https://github.com/zurawiki/tiktoken-rs).

## API
    
```c
struct FunctionCall {
  const char *name;
  const char *arguments;
};

struct ChatCompletionRequestMessage {
  const char *role;
  const char *content;
  const char *name;
  const FunctionCall *function_call; // optional (NULL)

void *r50k_base_raw();    // returns a pointer to CoreBPE
void *p50k_base_raw();    // returns a pointer to CoreBPE
void *p50k_edit_raw();    // returns a pointer to CoreBPE
void *cl100k_base_raw();  // returns a pointer to CoreBPE
void destroy_corebpe_raw(void *corebpe);

int32_t get_completion_max_tokens_raw(const char *model, const char *prompt);

int32_t num_tokens_from_messages_raw(const char *model,
                                     uint32_t num_messages,
                                     const ChatCompletionRequestMessage *messages);

int32_t get_chat_completion_max_tokens_raw(const char *model,
                                           uint32_t num_messages,
                                           const ChatCompletionRequestMessage *messages);

void *get_bpe_from_model_raw(const char *model);  // returns a pointer to CoreBPE

uint64_t *corebpe_encode_ordinary_raw(void *corebpe, const char *text, uint32_t *num_tokens);

uint64_t *corebpe_encode_with_special_tokens_raw(void *corebpe,
                                                 const char *text,
                                                 uint32_t *num_tokens);

char *corebpe_decode_raw(void *corebpe, const uint64_t *tokens, uint32_t num_tokens);
```

See https://github.com/zurawiki/tiktoken-rs/blob/main/tiktoken-rs/src/api.rs