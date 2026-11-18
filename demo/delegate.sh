#!/bin/bash
# Staged illustration of the delegate skill. Not a live Claude Code session.
# Used by delegate.tape to record delegate.gif.
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=demo/ui.sh
source "$here/demo/ui.sh"

say() { printf '%s⏺%s %s\n' "$text" "$reset" "$1"; }
line() { printf '  %s\n' "$1"; }

# type_box <text> : types into a prompt box like the Claude Code input
type_box() {
  local inner=$((BOX_WIDTH - 2)) i
  printf '%s╭%s╮%s\n' "$dim" "$(repeat '─' "$inner")" "$reset"
  for ((i = 0; i <= ${#1}; i++)); do
    printf '\r%s│%s %s>%s %-*s%s│%s' "$dim" "$reset" "$accent" "$reset" $((inner - 3)) "${1:0:i}" "$dim" "$reset"
    sleep 0.05
  done
  printf '\n%s╰%s╯%s\n' "$dim" "$(repeat '─' "$inner")" "$reset"
}

# run_line <tool uses> <total> <tokens> <tick>
run_line() {
  local frames=(◐ ◓ ◑ ◒)
  if [ "$1" -ge "$2" ]; then
    printf '\e[K  %s⎿  %s✓%s%s Done (%d tool uses · %s tokens)%s\n' "$dim" "$green" "$reset" "$dim" "$2" "$3" "$reset"
  else
    printf '\e[K  %s⎿  %s%s Running… (%d tool uses)%s\n' "$dim" "${frames[$4 % 4]}" "$reset$dim" "$1" "$reset"
  fi
}

head_line() { printf '\e[K%s⏺%s %sAgent%s(%s) %s%s%s\n' "$accent" "$reset" "$bold" "$reset" "$1" "$dim" "$2" "$reset"; }

# Two subagents running side by side
agents() {
  local t
  for ((t = 0; t <= 14; t++)); do
    [ "$t" -gt 0 ] && printf '\e[4A'
    head_line "Fix parseConfig on an empty file" sonnet
    run_line "$t" 14 "21.3k" "$t"
    head_line "Sync CLI docs with --help" haiku
    run_line "$((t / 2))" 5 "6.2k" "$t"
    sleep 0.35
  done
}

clear
printf '\n%sIllustration of the delegate skill in a Claude Code session%s\n\n' "$dim" "$reset"
say "Review found 2 issues: 1. parseConfig crashes on an empty file  2. CLI docs list removed flags"
printf '\n'
sleep 1.5
type_box 'fix 1 and 2, delegate'
printf '\n'
sleep 1
say "Two independent fixes, one subagent each, in parallel:"
line "• ${bold}parseConfig crash${reset} on ${cyan}Sonnet, medium${reset}: a scoped bug fix with a test"
line "• ${bold}CLI docs${reset} on ${cyan}Haiku, low${reset}: a mechanical text change"
printf '\n'
sleep 2.5
agents
printf '\n'
sleep 1
say "${green}${bold}Both fixed.${reset}"
line "1. Empty config now loads defaults: ${cyan}src/config.ts:42${reset}, regression test added, tests green"
line "2. README flags match ${cyan}--help${reset}, docs only"
line "${dim}The subagents' 27.5k tokens of reading stayed out of this session.${reset}"
sleep 6
