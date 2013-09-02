source $HOME/perl5/perlbrew/etc/bashrc

#=============================
# rbenv
#=============================
if [ -d ${HOME}/.rbenv ] ; then
  PATH=${HOME}/.rbenv/bin:${PATH}
  export PATH
  eval "$(rbenv init -)"
fi
