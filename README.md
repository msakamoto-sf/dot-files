# dot-files
my dot files

## .bashrc vs .bash_profile

bashの日本語manページより抜粋＆まとめ。

### `"~/.bash_profile"` を読み込む場合

bashが対話的なログインシェルとして起動されるか、 --login オプション付きの非対話的シェルとして起動されると、`/etc/profile` からコマンドを読み込んで実行した後、以下の順番でファイルを探し、最初に見つかった読み込み可能なファイルからコマンドを実行する。

```
~/.bash_profile
~/.bash_login
~/.profile
```

### `"~/.bashrc"` を読み込む場合

ログインシェルでない対話的シェルとして起動されると、 `~/.bashrc` ファイルがあれば、 bash はここからコマンドを読み込み、実行する。

### よく見かける .bash_profile と .bashrc の組み合わせ

以下のように .bash_profile 内で .bashrc を読み込ませる。
こうしておけば、ログインシェルか否かにかかわらず .bashrc を読み込んでくれる。
大半のLinuxディストリビューションやCygwin/MinGW系ツールがこの流儀に従っているので、日常的なシェル環境の設定は .bashrc の方に書いておけば良い。

`~/.bash_profile`:

```
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
```

`~/.bashrc`:

```
(対話環境 = terminal アプリでSSHログインなどして接続するCLI環境用設定)
PS1="[\u@\h \W]\$ "
export PS1
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
...
```

### 参考URL

- `技術/shell/".bash_profile"と".bashrc"の使い分け - Glamenv-Septzen.net`
  - https://www.glamenv-septzen.net/view/383
- `本当に正しい .bashrc と .bash_profile の使ひ分け - Qiita`
  - https://qiita.com/magicant/items/d3bb7ea1192e63fba850
- `.bash_profileと.bashrcなんて使い分けなくてよかったんや！ - Qiita`
  - https://qiita.com/dark-space/items/cf25001f89c41341a9fd
- `.bash_profileと.bashrcのまとめ - Qiita`
  - https://qiita.com/takutoki/items/021b804b9957fe65e093
- `Linux: .bashrcと.bash_profileの違いを今度こそ理解する｜TechRacho（テックラッチョ）〜エンジニアの「？」を「！」に〜｜BPS株式会社`
  - https://techracho.bpsinc.jp/hachi8833/2019_06_06/66396
