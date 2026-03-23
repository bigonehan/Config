#
# ~/.bashrc
#

# Bridge fish-defined `nf` command into bash sessions.
nf() {
  local notify_script="/home/tree/Config/data/fish/functions/notify.fish"
  if [[ ! -f "$notify_script" ]]; then
    echo "nf: notify script not found: $notify_script" >&2
    return 127
  fi

  if command -v fish >/dev/null 2>&1; then
    fish --no-config "$notify_script" "$@"
    return $?
  fi

  if [[ -x "$notify_script" ]]; then
    "$notify_script" "$@"
    return $?
  fi

  echo "nf: fish is not installed and script is not executable: $notify_script" >&2
  return 127
}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

if [[ -f "$HOME/.local/bin/env" ]]; then
  . "$HOME/.local/bin/env"
fi

alias codexo="/home/tree/.local/bin/codexo"
