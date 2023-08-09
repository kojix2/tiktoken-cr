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

void *c_r50k_base();    // returns a pointer to CoreBPE
void *c_p50k_base();    // returns a pointer to CoreBPE
void *c_p50k_edit();    // returns a pointer to CoreBPE
void *c_cl100k_base();  // returns a pointer to CoreBPE
void c_destroy_corebpe(void *corebpe);

int32_t c_get_completion_max_tokens(const char *model, const char *prompt);

int32_t c_num_tokens_from_messages(const char *model,
                                     uint32_t num_messages,
                                     const ChatCompletionRequestMessage *messages);

int32_t c_get_chat_completion_max_tokens(const char *model,
                                           uint32_t num_messages,
                                           const ChatCompletionRequestMessage *messages);

void *c_get_bpe_from_model(const char *model);  // returns a pointer to CoreBPE

uint64_t *c_corebpe_encode_ordinary(void *corebpe, const char *text, uint32_t *num_tokens);

uint64_t *c_corebpe_encode_with_special_tokens(void *corebpe,
                                                 const char *text,
                                                 uint32_t *num_tokens);

char *c_corebpe_decode(void *corebpe, const uint64_t *tokens, uint32_t num_tokens);
```

See https://github.com/zurawiki/tiktoken-rs/blob/main/tiktoken-rs/src/api.rs