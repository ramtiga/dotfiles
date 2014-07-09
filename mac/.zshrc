# 補間
autoload -U compinit
compinit

setopt nonomatch

#文字コード
export LANG=ja_JP.UTF-8

#プロンプト
autoload colors
colors

PROMPT="
 %{${fg[yellow]}%}%~%{${reset_color}%} 
[%n]$ "

PROMPT2='[%n]> ' 

#履歴
#履歴を保存するファイル指定
HISTFILE="$HOME/.zsh_history"

#履歴の件数
HISTSIZE=100000
SAVEHIST=100000

#重複した履歴を保存しない
setopt hist_ignore_dups

#履歴を共有する
setopt share_history

#先頭にスペースを入れると履歴に残さない
setopt hist_ignore_space

#履歴の検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end 

#cdの設定
#ディレクトリ名だけで移動する。
setopt auto_cd

#自動でpushdする
setopt auto_pushd

#pushdの履歴は残さない。
setopt pushd_ignore_dups

#ターミナルのタイトル
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST}\007"
    }
    ;;
esac 

#色の設定
export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'

#alias
case "${OSTYPE}" in
freebsd*|darwin*)
  alias ls="ls -GF"
  ;;
linux*)
  alias ls="ls -F --color"
  ;;
esac

alias la='ls -a'
alias ll='ls -la'
alias lld='ll -F | grep /'
alias ram='cd ~/go/src/github.com/ramtiga'

# git関連
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -a -m'
alias gci='git commit -a'
alias gco='git checkout'
alias gl='git log'
alias gd='git diff'
alias gb='git branch'

#w3mでALC検索
function alc() {
  if [ $# != 0 ]; then
    w3m "http://eow.alc.co.jp/$*/UTF-8/?ref=sa"
  else
    w3m "http://www.alc.co.jp/"
  fi
}

#その他
#キーバインド
bindkey -e

#ビープ音ならなさない
setopt nobeep

#エディタ
export EDITOR=vi

#改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr

#個別設定を読み込む
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

autoload -Uz select-word-style
select-word-style bash
export PATH=/usr/local/bin:/usr/local/share:/Users/dhanegm731/.rbenv/bin:$PATH
# eval "$(rbenv init -)"

alias php4=/usr/local/lib/php-4.4.9/bin/php
# ADDED BY npm FOR NVM
#. /usr/local/lib/node/.npm/nvm/0.1.0/package/nvm.sh
# END ADDED BY npm FOR NVM
#. ~/.nvm/nvm.sh
#nvm use v0.6.7

source $HOME/perl5/perlbrew/etc/bashrc
#source $HOME/perl5/perlbrew/etc/zshrc
#export PERL5LIB=$HOME/perl5/lib/perl5

#source .zsh/plugin/incr*.zsh

function cpanv (){
  perl -M$1 -le "print \$$1::VERSION"
}

export GISTY_DIR="$HOME/dev/gists"

export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
# alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
# alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vi='/usr/local/bin/vim'

# VCS settings
autoload -Uz vcs_info
precmd() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  psvar[1]=$vcs_info_msg_0_
}
# PROMPT=$'%2F%n@%m%f %3F%~%f%1v\n%# '
PROMPT=$'%2F%n %3F%~%f%1v\n%# '
export DYLD_LIBRARY_PATH=/usr/local/Cellar/libxml2/2.9.1/lib:$DYLD_LIBRARY_PATH

# golang
export GOROOT=/usr/local/Cellar/go/1.2/libexec
export GOPATH=$HOME/go
# export GOROOT=/usr/local/opt/go/libexec
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# typeset -U name_of_the_variable
unset LD_LIBRARY_PATH
unset DYLD_LIBRARY_PATH

# peco
function peco_select_history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER             # move cursor
  zle -R -c                   # refresh
}
zle -N peco_select_history
bindkey '^R' peco_select_history

function peco-src() {
  local selected_dir=$(ghq list -p| peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
stty -ixon
bindkey '^s' peco-src
