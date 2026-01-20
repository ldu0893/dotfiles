alias nv="nvim"
alias tmr="tmux rename-window"
alias findf="find -type f -name"
rsd() { rsync -a --delete ~/.empty/ "$1" && rmdir "$1"; }

alias gpm='git pull --rebase origin main && git submodule update --init --recursive'
alias gpms='git pull --rebase origin main --autostash && git submodule update --init --recursive'
alias gsmu='git submodule update --init --recursive'
alias glo='git log --oneline'
alias gbn='git rev-parse --abbrev-ref HEAD'
alias gbs='git branch | grep larry'
alias gcl='git clean -dfx'
alias gst='git status'
alias gpo='git po'
alias gpof='git pof'
alias gpcr='pre-commit run'
alias gcan='git commit --amend --no-edit'
alias gadd='git add -A && gpcr'
