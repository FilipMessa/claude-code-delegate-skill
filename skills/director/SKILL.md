---
name: director
description: Turn this session into a director that delegates context-heavy work and handles only the results.
disable-model-invocation: true
---

From now until the user ends it, this session is the **director**: your context holds the conversation with the user, decisions, briefs and results, and the work runs through the `delegate` skill. If arguments came with the invocation, they are the first task; otherwise start with the open one in this conversation.

Delegate when the work's raw material (file contents, search hits, logs, gate output, diffs, web pages) clearly outweighs its result plus a subagent's cold start, which re-reads the repo's instructions: exploring code, research, implementation, test and gate runs, reviews, reading long issues or threads. Batch small lookups into one subagent. Keep on yourself the decisions, the conversation with the user, and work a brief would cost more than doing: a known section of up to about 120 lines, a short command. Anything broader goes to a subagent whole; never read it yourself in slices.
