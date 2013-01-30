PATH=$PATH:$HOME/bin

export PATH
export PATH=$PATH:/sbin/
alias ll='ls -la'
alias lld='ll -F | grep /'
alias vi='vim'

alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -a -m'
alias gci='git commit -a'
alias gco='git checkout'
alias gl='git log'
alias gd='git diff'

#source ~/perl5/perlbrew/etc/bashrc
#PATH="$PATH":/usr/local/bin/vim:~/src/ruby:/home/hane/.nvm/v0.6.7/bin/


# 補間
autoload -U compinit
compinit
setopt correct

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


#その他
#キーバインド
bindkey -e

#ビープ音ならなさない
setopt nobeep


#改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr

#個別設定を読み込む
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

#export MANPATH=/opt/local/man:$MANPATH
#export APXS2=/opt/local/apache2/bin/apxs


#alias mysql=/usr/local/mysql/bin/mysql
#alias mysqladmin=/usr/local/mysql/bin/mysqladmin

#[[ -s "/home/hane/.rvm/scripts/rvm" ]] && source "/home/hane/.rvm/scripts/rvm"

#ruby
#rvm use 1.9.2-p180
#rvm gemset use rails313
#"alias rails3='rvm use ruby-1.9.2-p180@rails3_1'
#rails3
#alias r='rails'
#alias rgu='rvm gemset use'

#source $HOME/perl5/perlbrew/etc/bashrc
#source $HOME/perl5/perlbrew/etc/zshrc
#export PERL5LIB=$HOME/perl5/lib/perl5


function cpanv (){
  perl -M$1 -le "print \$$1::VERSION"
}

#. ~/.nvm/nvm.sh
#nvm use v0.6.7


# hub tab-completion script for zsh.
# # This script complements the completion script that ships with git.
# #
# # vim: ft=zsh sw=2 ts=2 et
# 

#Autoload _git completion functions
#if declare -f _git > /dev/null; then
#  _git
#fi

#if declare -f _git_commands > /dev/null; then
#  _hub_commands=(
#  'alias:show shell instructions for wrapping git'
#  'pull-request:open a pull request on GitHub'
#  'fork:fork origin repo on GitHub'
#  'create:create new repo on GitHub for the current project'
#  'browse:browse the project on GitHub'
#  'compare:open GitHub compare view'
#  )
#  # Extend the '_git_commands' function with hub commands
#  eval "$(declare -f _git_commands | sed -e 's/base_commands=(/base_commands=(${_hub_commands} /')"
#fi

#alias git='hub'

alias pry='nocorrect pry'
export TERM=xterm-256color
