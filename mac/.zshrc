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

# svn
alias sb='svnbr'
alias sl='svnbr log'



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
export EDITOR=/usr/bin/vim

#改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr

#個別設定を読み込む
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

autoload -Uz select-word-style
select-word-style bash
#export PATH=/usr/local/bin:/usr/local/share:/Users/dhane31/.rbenv/bin:$PATH
#export PATH=$HOME/.nodebrew/current/bin:$PATH
# eval "$(rbenv init -)"

#alias php4=/usr/local/lib/php-4.4.9/bin/php
# ADDED BY npm FOR NVM
#. /usr/local/lib/node/.npm/nvm/0.1.0/package/nvm.sh
# END ADDED BY npm FOR NVM
#. ~/.nvm/nvm.sh
#nvm use v0.6.7

#source $HOME/perl5/perlbrew/etc/bashrc
#source $HOME/perl5/perlbrew/etc/zshrc
#export PERL5LIB=$HOME/perl5/lib/perl5

#source .zsh/plugin/incr*.zsh

#function cpanv (){
#  perl -M$1 -le "print \$$1::VERSION"
#}

export GISTY_DIR="$HOME/dev/gists"

#export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
# alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
# alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
#alias vi='/usr/local/bin/vim'

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
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
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

### Added by the Heroku Toolbelt
#export PATH="/usr/local/heroku/bin:$PATH"
#
#if which pyenv > /dev/null; then
#    export PYENV_ROOT="${HOME}/.pyenv"
#    export PATH=${PYENV_ROOT}/shims:${PATH}
#    eval "$(pyenv init -)";
#fi

#export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
#pyenv virtualenvwrapper

alias ctags="`brew --prefix`/bin/ctags"

alias rs='rails server'
alias rc='rails console'
#export PATH="/usr/local/opt/php@7.2/bin:$PATH"
#export PATH="/usr/local/opt/php@7.2/sbin:$PATH"
#export PATH="/Users/dhane31/opt/anaconda3/bin:$PATH"
#export PATH="/Users/dhane31/Library/Android/sdk/platform-tools:$PATH"
#export PATH="/Users/dhane31/flutter/flutter/bin:$PATH"
#
#export PATH="/usr/local/opt/php@7.3/bin:$PATH"
#export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
#export LDFLAGS="-L/usr/local/opt/php@7.3/lib"
#export CPPFLAGS="-I/usr/local/opt/php@7.3/include"
#export PATH="/usr/local/opt/openssl@1.0/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/openssl@1.0/lib"
#export CPPFLAGS="-I/usr/local/opt/openssl@1.0/include"
#export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.0/lib/pkgconfig"
#export PATH="/usr/local/opt/apr-util/bin:$PATH"
#export PATH="/usr/local/opt/openldap/bin:$PATH"
#export PATH="/usr/local/opt/openldap/sbin:$PATH"
#export LDFLAGS="-L/usr/local/opt/openldap/lib"
#export CPPFLAGS="-I/usr/local/opt/openldap/include"
#
#export PATH="/usr/local/opt/curl-openssl/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/curl-openssl/lib"
#export CPPFLAGS="-I/usr/local/opt/curl-openssl/include"
#export PKG_CONFIG_PATH="/usr/local/opt/curl-openssl/lib/pkgconfig"
#
#export LDFLAGS="-L/usr/local/opt/readline/lib"
#export CPPFLAGS="-I/usr/local/opt/readline/include"
#export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"
#export PATH="/usr/local/opt/sqlite/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/sqlite/lib"
#export CPPFLAGS="-I/usr/local/opt/sqlite/include"
#export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
#
#export PATH="/usr/local/opt/libpq/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/libpq/lib"
#export CPPFLAGS="-I/usr/local/opt/libpq/include"
#export PKG_CONFIG_PATH="/usr/local/opt/libpq/lib/pkgconfig"
#
#export PATH="$PATH":"$HOME/.pub-cache/bin"
# export PATH="/Users/dhane31/.nodebrew/node/v16.13.2/bin:$PATH"

#eval "$(anyenv init -)"

PATH="/Users/dhane31/.phpenv/bin:$PATH"
eval "$(phpenv init -)"

#export PATH="/opt/homebrew/opt/bzip2/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/bzip2/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/bzip2/include"

#export PATH="/opt/homebrew/opt/bison/bin:$PATH"
#export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"
#export PATH="/opt/homebrew/opt/bzip2/bin:$PATH"
#export PATH="/opt/homebrew/opt/curl/bin:$PATH"
#export PATH="/opt/homebrew/opt/libiconv/bin:$PATH"
#export PATH="/opt/homebrew/opt/krb5/bin:$PATH"
#export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
#export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
#export PATH="/opt/homebrew/opt/tidy-html5/lib:$PATH"
#
#export PKG_CONFIG_PATH="/opt/homebrew/opt/krb5/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/libedit/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/libjpeg/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/libpng/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/libxml2/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/libzip/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/oniguruma/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/tidy-html5/lib/pkgconfig:$PKG_CONFIG_PATH"
#
#export PHP_RPATHS="/opt/homebrew/opt/zlib/lib /opt/homebrew/opt/bzip2/lib /opt/homebrew/opt/curl/lib /opt/homebrew/opt/libiconv/lib /opt/homebrew/opt/libedit/lib"
#
#PHP_BUILD_CONFIGURE_OPTS="--with-bz2=$(brew --prefix bzip2) --with-iconv=$(brew --prefix libiconv) --with-tidy=$(brew --prefix tidy-html5) --with-external-pcre=$(brew --prefix pcre2) --with-zip --enable-intl --with-pear"

export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"

export PKG_CONFIG_PATH="/opt/homebrew/opt/krb5/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libedit/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libjpeg/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpng/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libxml2/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libzip/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/oniguruma/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/tidy-html5/lib/pkgconfig:$PKG_CONFIG_PATH"

export OPENSSL_CFLAGS=-I/opt/homebrew/opt/openssl@1.1/include
export OPENSSL_LIBS=-L/opt/homebrew/opt/openssl@1.1/lib

export PHP_RPATHS="/opt/homebrew/opt/zlib/lib /opt/homebrew/opt/bzip2/lib /opt/homebrew/opt/curl/lib /opt/homebrew/opt/libiconv/lib /opt/homebrew/opt/libedit/lib"
#export PHP_BUILD_CONFIGURE_OPTS="--with-bz2=$(brew --prefix bzip2) --with-iconv=$(brew --prefix libiconv) --with-tidy=$(brew --prefix tidy-html5) --with-external-pcre=$(brew --prefix pcre2) --with-zip --enable-intl --with-pear"

#export PHP_BUILD_CONFIGURE_OPTS="--with-bz2=$(brew --prefix bzip2) --with-iconv=$(brew --prefix libiconv) --with-openssl=$(brew --prefix openssl@1.1) --with-tidy=$(brew --prefix tidy-html5) --with-external-pcre=$(brew --prefix pcre2) --with-zip --enable-intl --with-pear" PKG_CONFIG_PATH="$(brew --prefix icu4c)/lib/pkgconfig"
export PHP_BUILD_CONFIGURE_OPTS="--with-bz2=$(brew --prefix bzip2) --with-iconv=$(brew --prefix libiconv) --with-openssl=$(brew --prefix openssl@1.1) --with-tidy=$(brew --prefix tidy-html5) --with-external-pcre=$(brew --prefix pcre2) --with-zip --enable-intl --with-pear"



alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

export PATH="/Users/dhane31/php/Mutual-Aid-Association/vendor/phpunit/phpunit:$PATH"

eval "$(nodenv init -)"


export PATH="/opt/homebrew/opt/php/bin:$PATH"
export PATH="/opt/homebrew/opt/php/sbin:$PATH"


source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
export PATH=~/.npm-global/bin:$PATH

cd ~/php/Mutual-Aid-Association
