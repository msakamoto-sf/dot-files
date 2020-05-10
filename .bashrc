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

alias ll='ls -lFG --color'
alias la='ls -aFG --color'
alias ls='ls -FG --color'
# no-color
#alias ll='ls -lFG'
#alias la='ls -aFG'
#alias ls='ls -FG'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias od='/usr/bin/od -Ax -tx1z -v'
alias hexdump='/usr/bin/hexdump -C -v'
alias xxd='/usr/bin/xxd -g 1'

export EDITOR=/usr/bin/vim

#export PAGER=/usr/bin/lv
# modern less:
alias less='/usr/bin/less -MN'
export LESSCHARSET=utf-8
export PAGER=/usr/bin/less
