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

# bash 参考
# bash(1)
# https://nkmk.github.io/blog/shell-history/
# http://www.denet.ad.jp/technology/2013/05/vol1-history.html
# bash history 参考
# https://qiita.com/bezeklik/items/56a597acc2eb568860d7

# ls の alias はお好みに応じてオプション調整
# with-color ("--color" for linux, "-G" for mac)
alias ls='ls -F --color'
alias ll='ls -lF --color'
# or
#alias ll='ls -ltrF --color'
alias la='ls -aF --color'
# no-color
#alias ls='ls -F'
#alias ll='ls -lF'
# or
#alias ll='ls -ltrF'
#alias la='ls -aF'

# NOTE: lsのcolor出力に関する linux と mac でのオプションの違い
# linux では "--color" オプションになるが、mac では "-G" オプションになる。
# linux で "-G" オプションを指定してしまうと、group情報を表示しないという意味となってしまうので注意。
# 参考: https://qiita.com/hitochan777/items/8e7a570e53d3a5d20bb1

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
