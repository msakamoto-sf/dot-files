#alias la='ls -aF'
#alias ll='ls -ltr'
#alias ls='ls -hF --color=tty'
# Cygwin の mintty でも、2018年頃になると普通の --color 指定だけで問題ない状況。
alias ls='ls -FG --color'
alias ll='ls -ltrFG --color'
alias la='ls -aFG --color'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# for mintty scroll buffer clear
# see: http://www.glamenv-septzen.net/view/1113

alias cls='echo -ne "\ec\e[3J"'

# for "lv" pager UTF-8 "OOPS" message
# see: http://www.glamenv-septzen.net/view/1108
export TERM=cygwin
# 2018年ごろになれば、lvでなくless + LESSCHARSET=utf-8でほぼ問題ない状況。
# modern less:
alias less='/usr/bin/less -MN'
export LESSCHARSET=utf-8
#export PAGER=lv
export PAGER=less

# for mintty title string updates
# see: http://www.glamenv-septzen.net/view/1107

function settitle ()
{
  t="[$@]@`hostname`"
  # "\e]2;"までがウインドウタイトル変更開始の制御コード
  # "\007"が変更終了・・・らしい、です。
  echo -ne "\e]2;$t\007"
}

function cd()
{
   builtin cd $@ && settitle $(cygpath -m `/usr/bin/pwd`)
}

function pwd()
{
  settitle $(cygpath -m `/usr/bin/pwd`)
  builtin pwd $@
}

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

# cygwinなら改行プロンプトでこのくらいがちょうど良さそう
export PS1="\r\n[\D{%F} \t \u:\w]\r\n\$ "
