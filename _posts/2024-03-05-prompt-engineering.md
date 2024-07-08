---
title: Prompt Engineering
categories:
  - Posts
classes:
  - wider-content
tags:
  - Deep Learning
  - LLM
---
This post contains survey of notable prompt engineering techniques. 

Prompt engineering refers to a way to construct a natural language in such a way to feed to the LLM in order to improve the performance. In this domain, the assumption is that the LLM is a **blackbox** therefore cannot be directly optimized, so the improvement must come from the prompt or other external parameters.

There are abundant amount of prompt techniques but the trade-off is usually between the **performance improvement** and the **cost**, e.g. inference time, numer of tokens, cost of using the LLM, additional models, etc.

Directly feeding the original prompt without any modifications to the LLM is refered to as **zero-shot** strategy. It is fast, easy, but the performance is not good on complex task.

## Expanding the Prompt

### [Few-Shot / In-Context Learning](https://arxiv.org/pdf/2005.14165.pdf)

Give the LLM several demonstrations of the expected interactions before giving the actual prompt.
![fewshot](/assets/images/prompt-eng/933c2183-a80f-4541-aa4d-b12348c51dd3.png){: .align-center}

### [Generate Knowledge](https://arxiv.org/pdf/2110.08387.pdf)

![genknow](/assets/images/prompt-eng/9e6b851e-62f4-4742-8830-82f990e9aadb.png){: .align-center}

- Generate a “knowledge” that is related to the original prompt
- Append the knowledge as additional context to the original prompt to generate the final answer

### [Retrieval Augmented Generation (RAG)](https://arxiv.org/pdf/2005.11401.pdf)

- LLMs are trained with a knowledge cutoff, making more recent information unavailable to access
- However, it can perform a zero-shot reasoning considerably well given enough context

![genknow](/assets/images/prompt-eng/3ff5f30a-e717-4128-b0df-bafbb1ad4a30.png){: .align-center}

- The idea is to create vectors from chunks of documents, i.e. the source of information
- For each user prompt, it will be match with the top-K most similar document chunks and combined to give additional context

## Expanding the LLM Generation

LLM models are autoregressive, so they generate one token at a time. During the generation process, they consider past tokens to get the next token.

The idea of expanding the LLM generation works because instead of giving the final answer to the prompt directly as a short answer, it generates more token, giving more context for the next token generation, thus resulting in better answer overall.

### [Chain-of-Thought](https://arxiv.org/pdf/2201.11903.pdf)

![cot1](/assets/images/prompt-eng/908f25d2-87c8-4d9c-b011-45a4db32327c.png){: .align-center}

There are also many variations introduced that were derived from this techniques.

![cot2](/assets/images/prompt-eng/b384c45d-e943-44f3-b678-d90de0abd1fe.png){: .align-center}

### [Tree-of-Thought](https://arxiv.org/pdf/2305.10601.pdf)

- Similar with CoT, but it works by generating intermediate answer with intermediate reasoning
- Similar to how DFS or BFS works, it generates a tree of reasoning and pursue the most likely path to get the best answer

![tot](/assets/images/prompt-eng/c2797b19-b0c8-44f1-9bc6-cf32ea69cd17.png){: .align-center}

### [Self-Consistency](https://arxiv.org/pdf/2203.11171.pdf)

It generates the answer for the same prompt multiple times, and select the final answer based on the majority vote (the most consistent).

![sc](/assets/images/prompt-eng/1f3cf77e-6c4a-4a5e-9f45-a57cb94c39b8.png){: .align-center}

### [ReAct](https://arxiv.org/pdf/2210.03629.pdf)

![react](/assets/images/prompt-eng/9341ef3b-e97d-4619-a872-6cfe2cfded99.png){: .align-center}

- Similar with CoT, but it also integrates acting, reasoning, and observation
- It generates the next step based on the reasoning and observation of previous steps
- It enables LLM to interact with external tools that generate the observation
- It also makes the LLM able to adapt each step depending on the observation

### [RCI](https://arxiv.org/pdf/2303.17491.pdf)

![rci](/assets/images/prompt-eng/0897121b-261e-4d5b-9946-a23e64b3047a.png){: .align-center}

Introduce “retry” mechanism by finding the problems and improve upon it

### [Reflexion](https://arxiv.org/pdf/2303.11366.pdf)

![reflexion1](/assets/images/prompt-eng/b4598213-e6fa-4f8d-b81c-e6f878ca0e51.png){: .align-center}

![reflexion2](/assets/images/prompt-eng/206ab644-fee7-4c46-85b0-78e2b3db8004.png){: .align-center}

There are 3 components:
- Actor, the LLM that generates the response conditioned by the prompt and observation
- Evaluator, the one that evaluates the quality of the generation
- Self-reflection, another LLM that generates reinforcement cues to assist the Actor in self-improvement

## Prompt Optimization

Previous techniques tries to develop a **general** algorithm/framework to improve the LLM generation. The following techniques works to develop a prompt that works well on **specific** queries.

### [OIRL](https://arxiv.org/pdf/2309.06553.pdf)

![oirl](/assets/images/prompt-eng/49850f75-d65d-4177-92d1-482ebc953f64.png){: .align-center}

- It works by creating an offline reward model to score the prompt. However, direct optimization of this reward model requires the parameter of the LLM, which might not always be available. Even if available, it will be very costly as the LLM contains billions of parameters.
- Therefore, a proxy reward model is introduced by training additional model with a supervised learning objective to minimize the discrepancies with the true reward.

### [OPRO](https://arxiv.org/pdf/2309.03409.pdf)

![opro](/assets/images/prompt-eng/0a3e35be-1ee2-4361-b5b7-55f9bb10b249.png){: .align-center}

- This algorithm works by prompting the model to “generate a new instruction that achieves a higher accuracy” given trajectories of past solutions paired with their optimization scores, sorted in **ascending** order
- The model has to pick up the pattern to generate a better solution