# Delegate for Claude Code

Two [Claude Code](https://claude.com/claude-code) skills that hand work to subagents and bring back only the result. Your main session stays small and focused on decisions, and routine work runs on a cheaper model.

- **`delegate`**: write "delegate" in a message, or ask for something to run on a subagent. That one task goes to a subagent, and you get the answer back.
- **`/director`**: run it once and the whole session becomes a director. From then on, any work that would fill the context with file contents, logs or test output goes to subagents, and you talk only with the director.

## Why

Long sessions fill up with raw material: files read to find one function, a whole test log for one failure, pages of search hits. All of it stays in the main model's context, makes every later turn more expensive and pushes out what matters. A subagent reads that material in its own context and returns a few lines.

Typing "run this on a subagent and pick a suitable model" every few messages gets old. These skills turn that request into one word.

## Which one to use

| You want | Use | Example |
| --- | --- | --- |
| One task on a subagent; the rest of the session works as usual | `delegate` | `review this plan, delegate` |
| Several independent tasks at once | `delegate` | `fix 1 and 2, delegate` |
| A specific model | `delegate` | `look at this as a Payload developer, on opus` |
| The whole session delegating by default | `/director` | `/director implement #42 up to a draft PR` |

`delegate` triggers on its own when your message asks for it. `/director` starts only when you type it.

## Install

Clone the repository and link both skills into your personal skills folder:

```bash
git clone https://github.com/FilipMessa/claude-code-delegate.git ~/claude-code-delegate
mkdir -p ~/.claude/skills
ln -s ~/claude-code-delegate/skills/delegate ~/.claude/skills/delegate
ln -s ~/claude-code-delegate/skills/director ~/.claude/skills/director
```

If a `delegate` or `director` skill already exists in `~/.claude/skills`, inspect it before replacing it. Start a new Claude Code session afterwards, because skills are discovered when a session starts. To update, run `git pull` in the clone.

### Let Claude Code do it

Paste this into Claude Code:

```text
Install the delegate and director skills from https://github.com/FilipMessa/claude-code-delegate
into ~/.claude/skills as symlinks to a clone, following its README.
```

## How it works

### `delegate`

1. **Brief.** A subagent starts with none of your conversation, so Claude writes a brief that stands on its own: the goal, what is already decided, the files and issues involved, the rules the session follows (worktrees, commit and push rules, skills to load), what done looks like, and a short report format. When the brief would mostly retell the conversation, Claude forks the session instead.
2. **Model and effort.** A model you name wins. Otherwise Claude picks the cheapest model and effort that do the task well. Iterative work, such as debugging by hypothesis, goes to one subagent that runs the whole loop.
3. **Dispatch.** You get one line per subagent: what it does, on which model and effort, and why.
4. **Result.** Claude checks the result against the brief. It looks at what a decision rests on itself, such as screenshots or the final diff before a commit, and sends a weak result back or up one model. You get the answer, its evidence and the open points, without the subagent's logs.

Independent items run in parallel, and subagents that write each get their own git worktree.

### `/director`

The director runs every task through `delegate`. It delegates when the raw material clearly outweighs the result plus a subagent's cold start, batches small lookups into one subagent, and keeps decisions and quick lookups for itself.

## Trade-offs

- **Cold starts cost tokens.** Each subagent re-reads the project's instructions. For a small task this can cost more in total than doing it inline, which is why the director delegates only when the raw material clearly outweighs it.
- **Round trips are slower.** Each delegation waits for a subagent to finish.
- **`delegate` is always in context.** Its one-sentence description is loaded in every session so the word can trigger it. `/director` costs nothing until you run it.
- **Director mode can fade.** After Claude Code compacts a long conversation, the director may drift back to doing work itself. Run `/director` again.

## Requirements

Claude Code with subagents (the Agent tool). The skills rely on Claude Code's agent types, forks and `SendMessage`, so they are not portable to other agents as written.

## Uninstall

```bash
rm ~/.claude/skills/delegate ~/.claude/skills/director
```

## License

MIT
