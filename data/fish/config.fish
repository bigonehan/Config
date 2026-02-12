if status is-interactive
# Commands to run in interactive sessions can go here
end
starship init fish | source
=======
# ~/.config/fish/config.fish

# -----------------------------
# aliases (fish: alias/abbr)
# -----------------------------
alias ls "eza -l --icons"
alias r "sudo rm -r"
alias j "joshuto"
alias dr "dir"
alias nv "nvim"
alias gp "git push"
alias px "pnpm dlx"
alias hg "env HYGEN_TMPLS=~/.hygen/_templates hygen"
alias prd "pnpm run dev"
alias pd "cd /mnt/d/project"
alias bx "bunx"
alias tgo "/home/tree/study/typescript-go/built/local/tsgo tsc"
alias sup "$HOME/.config/script/update.sh"
alias gcr 'cd (git rev-parse --show-toplevel); and git add .; and git commit'
alias hx "helix"
alias zed "env WAYLAND_DISPLAY= zed"
alias mygen "bun ~/config/scripts/gen.ts"
alias onecode "/home/tree/project/oneMono/app/script/projectManager/scripts/run-one-project.sh"
alias onegrist "/home/tree/project/oneMono/app/script/projectManager/scripts/list-grist-rows.sh table13"

# zsh에서 <commit> 자리 채우는 형태는 fish 함수로 구현
function gsho
  git show $argv --stat
end

# zsh의 복잡한 포맷은 fish에서 따옴표/이스케이프만 정리
alias glo 'git log --graph --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)" --all'

# tmux helpers
alias tmn "tmux new -s"
alias tmg "tmux attach-session -t"
alias tmk "tmux kill-session -t"
alias tmc "tmux switch-client -t"

function tmcc
  if tmux has-session -t claude 2>/dev/null
    tmux attach -t claude
  else
    tmux new -s claude
  end
end

# -----------------------------
# env / PATH
# -----------------------------
set -gx LANG ko_KR.UTF-8
set -gx LC_ALL ko_KR.UTF-8

# DISPLAY (WSL)
set -gx DISPLAY (ip route | awk '/^default/{print $3}'):0.0

# ZED
set -gx ZED_ALLOW_EMULATED_GPU 1

# ANDROID / JAVA
set -gx ANDROID_HOME $HOME/Android
set -gx JAVA_HOME /usr/lib/jvm/java-8-openjdk
set -gx PATH $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin \
            $ANDROID_HOME/cmdline-tools/latest $ANDROID_HOME/cmdline-tools/latest/bin \
            $ANDROID_HOME/platform-tools $PATH

# PNPM
set -gx PNPM_HOME /home/tree/.local/share/pnpm
if not contains $PNPM_HOME $PATH
  set -gx PATH $PNPM_HOME $PATH
end

# DENO
set -gx DENO_INSTALL /home/tree/.deno
set -gx PATH $DENO_INSTALL/bin $PATH

# NVM (fish용: bass/fnm 미사용 상태라 최소 이식)
set -gx NVM_DIR $HOME/.nvm

# ENCORE
set -gx ENCORE_INSTALL /home/tree/.encore
set -gx PATH $ENCORE_INSTALL/bin $PATH

# Cargo / extra PATH들
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH /home/tree/.local/share/bob/nvim-bin $PATH
set -gx PATH /home/tree/project/git_date_Change/src/ $PATH

# -----------------------------
# external init (starship / zoxide / atuin / conda)
# -----------------------------
# starship
starship init fish | source

# zoxide
zoxide init fish | source

# atuin (fish init)
atuin init fish | source

# conda (fish hook)
if test -f /home/tree/miniconda3/bin/conda
  /home/tree/miniconda3/bin/conda "shell.fish" "hook" 2>/dev/null | source
end

# -----------------------------
# automate my process (function)
# -----------------------------
function autoUpdate
  cd ~/config; and git pull
  cd ~/study/myNote; and git pull
  cd ~/project/tenderMono; and git pull
  cd ~
end

# zsh의 up='eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa && autoUpdate'
function up
  eval (ssh-agent -c) >/dev/null 2>&1
  ssh-add ~/.ssh/id_rsa
  autoUpdate
end

# -----------------------------
# ollama auto-start
# -----------------------------
if not pgrep -f "ollama serve" >/dev/null
  nohup ollama serve > ~/.ollama.log 2>&1 &
end


