#!/bin/bash

#PS1="[\u@\h \W]\$ "
# very simple:
export PS1="[\u:\W]\$ "
# newline with full:
export PS1="\r\n[\D{%F} \t \u@\H job#\j/his#\!/com#\# \w]\r\n\$ "
# newline normal:
export PS1="\r\n[\D{%F} \t \u:\w]\r\n\$ "

# ヒストリ履歴の個数は99,999個まで上げておく。
export HISTSIZE=99999
# ファイルに保存する履歴の数も、同じ個数に上げておく。
export HISTFILESIZE=99999
# 時間も記録する。
export HISTTIMEFORMAT='%F %T '
# 全ての履歴を記録するため、重複排除設定などのHISTCONTROLをクリアする。
unset HISTCONTROL
# 履歴から無視するコマンドの例
export HISTIGNORE='ls:pwd:exit:history'

# 参考
# bash(1)
# https://nkmk.github.io/blog/shell-history/
# http://www.denet.ad.jp/technology/2013/05/vol1-history.html

# ls の alias はお好みに応じてオプション調整
# with-color
alias ls='ls -FG --color'
alias ll='ls -lFG --color'
# or
#alias ll='ls -ltrFG --color'
alias la='ls -aFG --color'
# no-color
#alias ls='ls -FG'
#alias ll='ls -lFG'
# or
#alias ll='ls -ltrFG'
#alias la='ls -aFG'

# clear screen
alias cls='echo -ne "\ec\e[3J"'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias od='/usr/bin/od -Ax -tx1z -v'
alias hexdump='/usr/bin/hexdump -C -v'
alias xxd='/usr/bin/xxd -g 1'

export EDITOR=/usr/bin/vim

# お好みに応じたビルドイン関数のカスタマイズ
function settitle ()
{
  t="[$@]@`hostname`"
  echo -ne "\e]2;$t\007"
}

function cd()
{
   builtin cd $@ && settitle `builtin pwd`
}

function pwd()
{
  settitle `builtin pwd`
  builtin pwd $@
}

#export PAGER=/usr/bin/lv
# modern less:
alias less='/usr/bin/less -MN'
export LESSCHARSET=utf-8
export PAGER=/usr/bin/less
