# 補間
autoload -U compinit
compinit

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
alias ll='ls -l'
alias lla='ls -al'
alias lld='ll -F | grep /'

# git関連
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -a -m'
alias gci='git commit -a'
alias gco='git checkout'
alias gl='git log'
alias gd='git diff'

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
export EDITOR=emacs

#改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr

#個別設定を読み込む
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

autoload -Uz select-word-style
select-word-style bash

export PATH=/opt/local/bin:/opt/local/apache2/bin:/opt/local/sbin:~/bin:/Users/dhanegm731/.rvm/gems/ruby-1.8.7-p302@rails2/bin:$PATH
export MANPATH=/opt/local/man:$MANPATH
export APXS2=/opt/local/apache2/bin/apxs


#alias mysql=/usr/local/mysql/bin/mysql
alias mysql=/opt/local/lib/mysql5/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

if [[ -s /Users/dhanegm731/.rvm/scripts/rvm ]] ; then source /Users/dhanegm731/.rvm/scripts/rvm ; fi

alias rails2='rvm use ruby-1.8.7-p302@rails2'
alias rails3='rvm use ruby-1.9.2-p180@rails3_1'
rails3
alias r='rails'
alias php4=/usr/local/lib/php-4.4.9/bin/php
# ADDED BY npm FOR NVM
#. /usr/local/lib/node/.npm/nvm/0.1.0/package/nvm.sh
# END ADDED BY npm FOR NVM
#. ~/.nvm/nvm.sh
#nvm use v0.6.7

source $HOME/perl5/perlbrew/etc/bashrc
#source $HOME/perl5/perlbrew/etc/zshrc
#export PERL5LIB=$HOME/perl5/lib/perl5

source .zsh/plugin/incr*.zsh

function cpanv (){
  perl -M$1 -le "print \$$1::VERSION"
}

export GISTY_DIR="$HOME/dev/gists"

export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

