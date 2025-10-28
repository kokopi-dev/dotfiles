# base commands to be copied

# basic
alias ls='ls --color=auto'
alias ll='ls -l'
alias lll='ls -la'
alias v='nvim'
alias ..='cd ..'
alias ux='chmod u+x'
alias venva='source venv/bin/activate'
alias mkdir='mkdir -p'
function fsize() {
  du -sh "$1"
}

# basic enhanced
alias ll='exa -lg --icons'
alias lll='exa -lga'
alias cat='bat --style=header,grid'

# git
alias gadd='git add'
alias gdiff='git diff'
alias mpush='git push origin master'
alias gstat='git status'
function gcom() {
    GITMESSAGE="$*"
    git commit -m "$GITMESSAGE"
}
