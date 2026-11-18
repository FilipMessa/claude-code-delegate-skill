# Delegate skill for Claude Code

A [Claude Code](https://claude.com/claude-code) skill that hands work to a subagent on a fitting model and brings back only the result. Write "delegate" in a message, or ask for something to run on a subagent, and that task leaves your main session; you get the answer back.

## Why

Long sessions fill up with raw material: files read to find one function, a whole test log for one failure, pages of search hits. All of it stays in the main model's context, makes every later turn more expensive and pushes out what matters. A subagent reads that material in its own context and returns a few lines, often on a cheaper model.

Typing "run this on a subagent and pick a suitable model" every few messages gets old. This skill turns that request into one word.

## Examples

| You write | What happens |
| --- | --- |
| `review this plan, delegate` | One subagent reviews the plan; you get its findings |
| `fix 1 and 2, delegate` | Each item gets its own subagent, in parallel |
| `look at this as a Payload developer, on opus` | The subagent runs on the model you named |
| `run the tests in a subagent` | Plain language works too, without the word "delegate" |

## Install

Clone the repository and link the skill into your personal skills folder:

```bash
git clone https://github.com/FilipMessa/claude-code-delegate-skill.git ~/claude-code-delegate-skill
mkdir -p ~/.claude/skills
ln -s ~/claude-code-delegate-skill/skills/delegate ~/.claude/skills/delegate
```

If a `delegate` skill already exists in `~/.claude/skills`, inspect it before replacing it. Start a new Claude Code session afterwards, because skills are discovered when a session starts. To update, run `git pull` in the clone.

### Let Claude Code do it

Paste this into Claude Code:

```text
Install the delegate skill from https://github.com/FilipMessa/claude-code-delegate-skill
into ~/.claude/skills as a symlink to a clone, following its README.
```

## How it works

1. **Brief.** A subagent starts with none of your conversation, so Claude writes a brief that stands on its own: the goal, what is already decided, the files and issues involved, the rules the session follows (worktrees, commit and push rules, skills to load), what done looks like, and a short report format. When the brief would mostly retell the conversation, Claude forks the session instead.
2. **Model and effort.** A model you name wins. Otherwise Claude picks the cheapest model and effort that do the task well. Iterative work, such as debugging by hypothesis, goes to one subagent that runs the whole loop.
3. **Dispatch.** You get one line per subagent: what it does, on which model and effort, and why.
4. **Result.** Claude checks the result against the brief. It looks at what a decision rests on itself, such as screenshots or the final diff before a commit, and sends a weak result back or up one model. You get the answer, its evidence and the open points, without the subagent's logs.

Independent items run in parallel, and subagents that write each get their own git worktree.

## Trade-offs

- **Cold starts cost tokens.** Each subagent re-reads the project's instructions. For a small task, delegating can cost more in total than doing it inline; it pays off when the raw material is large.
- **Round trips are slower.** Each delegation waits for a subagent to finish.
- **The skill is always in context.** Its one-sentence description is loaded in every session so the word "delegate" can trigger it.

## Requirements

Claude Code with subagents (the Agent tool). The skill relies on Claude Code's agent types, forks and `SendMessage`, so it is not portable to other agents as written.

## Uninstall

```bash
rm ~/.claude/skills/delegate
```

## License

MIT
