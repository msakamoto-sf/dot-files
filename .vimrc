" vim: expandtab fenc=utf-8 ff=unix ft=vim ts=2 sw=2 sts=0
" about 'mode line', see: http://nanasi.jp/articles/howto/file/modeline.html

" NOTE: .vimrc をロードせずにvimを起動したい場合は、vim -u NONE など存在しない
" 適当なファイル名を .vimrc と指定して編集する。
" (.vimrc自体を色々試行錯誤したり、オプションのデフォルト値を確認したい場合向け)

" vim script リファレンス:
" https://vim-jp.org/vimdoc-ja/usr_41.html
" https://vim-jp.org/vimdoc-ja/eval.html

" 日本語ファイルの文字コード判別
" see:
" http://www.ksknet.net/vi/vim_1.html
" https://www.ht.sfc.keio.ac.jp/~katsuya/blog2/2008/02/vimrc.html
" ref:
" https://vim-jp.org/vimdoc-ja/options.html#'encoding'
" -> vim内部で使われる文字エンコーディング
" https://vim-jp.org/vimdoc-ja/options.html#'fileencoding'
" -> カレントバッファの文字エンコーディング
" https://vim-jp.org/vimdoc-ja/options.html#'fileencodings'
" 既存のファイルの編集を開始するときに考慮される文字エンコーディングのリスト
if &encoding !=# 'utf-8'
  " vim内部の文字エンコードがutf-8でない場合は文字コードのエイリアスを設定する。
  " see: https://vim-jp.org/vimdoc-ja/mbyte.html#encoding-names
  " (プラットフォームに応じた日本語用の文字コードとなる)
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " ﾄﾝ(U+3327)㌦(U+3326) の cp932 表記を euc-jp の派生型に変換してみて、
  " 対応状況に応じたeuc/jis用文字コードの微調整を行う。
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  " vim内部の文字エンコーディングに応じて、fileencodingsを日本語用に調整
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  unlet s:enc_euc
  unlet s:enc_jis
endif

if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      " もしカレントバッファの文字エンコーディングがiso-2022-jpで、かつ、
      " 0x01 - 0x7e 以外の文字が見つからなかった場合は、
      " vim内部の文字エンコーディングにfallbackする。
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" 使用する改行コードの一覧と優先順位の設定
" see: https://vim-jp.org/vimdoc-ja/options.html#'fileformats'
set fileformats=unix,dos,mac

if exists('&ambiwidth')
  " UTF-8のときCJKの記号文字を全角表示にする(半角表示で重なるのを防ぐ)
  " see: https://vim-jp.org/vimdoc-ja/options.html#'ambiwidth'
  " see: https://maku77.github.io/vim/settings/ambiwidth.html
  set ambiwidth=double
endif

" vi互換をoffにして、vim専用とする
set nocompatible

set history=999
" show the cursor position all the time
set ruler
" display incomplete commands
set showcmd
" do incremental searching
set incsearch
" about tabstop, shiftwiddth, softtabstop, see:
" http://d.hatena.ne.jp/waku_52/20110325/1301039968
" http://peacepipe.toshiville.com/2006/05/vimrc-vim.html
set tabstop=4
set shiftwidth=4
set softtabstop=0
" dont replace TAB to spaces by default
"set expandtab
set backspace=2
set shortmess+=I
set visualbell
" display special chars
set listchars=tab:>-,extends:<,trail:-
"set listchars=eol:$,tab:>--
"set listchars=eol:$,tab:>-
" NOTICE : if enable this, TABs are NOT displayed. (anti-pattern)
"set grepprg=search\ $*

" デフォルトで行数を表示
set number
" 対応する括弧を表示
set showmatch
" 現在のモードを表示
set showmode

" キーワード補完でdictionary指定があればそれも使う
" see: https://vim-jp.org/vimdoc-ja/options.html#'complete'
set complete+=k

" vim終了時に元のウインドウタイトルが復元できない場合に、
" 現在ファイルのディレクトリ名に暫定で戻す。
" (titlestring未設定だと無効のようだけど動くのか?)
" see: https://vim-jp.org/vimdoc-ja/options.html#'titleold'
let &titleold=expand("%:p:h")
" ターミナルが対応していればウインドウタイトルを更新させる
" see: https://vim-jp.org/vimdoc-ja/options.html#'title'
set title

" see: https://vim-jp.org/vimdoc-ja/filetype.html
filetype plugin indent on
" -> ファイル形式の検出 ON
" -> ファイル形式別プラグインロード(plugin) ON
" -> ファイル形式別インデントロード(indent) ON

if has("autocmd")
  " see: https://vim-jp.org/vimdoc-ja/autocmd.html
  " {{{

  " about FileType detection, see:
  " $RUNTIME/filetype.vim
  " http://blog.starbug1.com/archives/146
  " http://blog.monoweb.info/blog/2010/06/19/
  autocmd FileType text setlocal textwidth=78
  autocmd FileType vim setlocal expandtab tabstop=2 shiftwidth=2
  autocmd FileType c setlocal expandtab tabstop=4 shiftwidth=4
  autocmd FileType perl setlocal expandtab tabstop=4 shiftwidth=4
  autocmd FileType php  setlocal expandtab tabstop=4 shiftwidth=4
  autocmd FileType ruby setlocal expandtab tabstop=4 shiftwidth=4
  autocmd FileType python setlocal expandtab tabstop=2 shiftwidth=2
  autocmd FileType java setlocal expandtab tabstop=4 shiftwidth=4
  autocmd FileType groovy setlocal expandtab tabstop=4 shiftwidth=4
  autocmd FileType gsp setlocal expandtab tabstop=2 shiftwidth=2
  autocmd FileType javascript setlocal expandtab tabstop=2 shiftwidth=2
  autocmd FileType html setlocal expandtab tabstop=2 shiftwidth=2
  autocmd FileType css setlocal expandtab tabstop=2 shiftwidth=2
  autocmd FileType xml setlocal expandtab tabstop=2 shiftwidth=2
  autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2

"  autocmd FileType php setlocal dictionary+=~/.vim/php.dict

  " GradleファイルについてはFileTypeによらず、ファイル拡張子によって判断する。
  autocmd BufNewFile,BufRead *.gradle setlocal expandtab tabstop=4 shiftwidth=4
  " Gradleファイルについてsyntax highlitghtをgroovyにする。
  " see: https://kakakakakku.hatenablog.com/entry/2014/01/13/221203
  autocmd BufNewFile,BufRead *.gradle set filetype=groovy

  " 前回に編集した箇所を記憶して、次回起動時にその箇所に移動するようにする。
  " see: https://bi.biopapyrus.jp/os/linux/vim.html
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " }}}
endif


set ignorecase
set smartcase
set wrapscan
syntax on
set list
set hlsearch
set laststatus=2
" see: https://vim-jp.org/vimdoc-ja/options.html#'statusline'
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" ref:
" https://vim-jp.org/vimdoc-ja/vimindex.html
" https://vim-jp.org/vimdoc-ja/map.html
" https://vim-jp.org/vimdoc-ja/intro.html#keycodes
map Q gq
" バッファリストの前のバッファを開く(:bp) -> F2
map <F2> <ESC>:bp<CR>
" バッファリストの次のバッファを開く(:bn) -> F3
map <F3> <ESC>:bn<CR>
" バッファの一行を削除する(:bw) -> F4
map <F4> <ESC>:bw<CR>
" カレントウィンドウの高さを N 行高くする。-> テンキー plus
map <kPlus> <C-W>+
" カレントウィンドウの高さを N 行低くする。-> テンキー minus
map <kMinus> <C-W>-
" 行が折り返された時に、j/kのカーソル上下移動を折り返された行にも移動させる。
" = カーソル移動を表示行単位の移動にする。
" see: https://thata.hatenadiary.org/entry/20100606/1275796513
" see: https://qiita.com/t_uda/items/407220bfc989f901baf5
nnoremap j gj
nnoremap k gk

"set tags+=~/tags/tags
"set tags+=~/.ctags/symfony

hi Comment ctermfg=lightred
hi Function ctermfg=cyan
" always set autoindenting on
set autoindent

" disable autochdir for VimFiler works.
"set autochdir

"set nocp
set nobackup
set backupcopy=yes

" ref:
" https://vim-jp.org/vimdoc-ja/options.html#'fdm'
" https://vim-jp.org/vimdoc-ja/fold.html
set fdm=marker
" 折り畳みの標準コマンドキーについては以下参照:
" https://vim-jp.org/vimdoc-ja/fold.html#fold-commands
" {{{ folding default command cheat sheet
" カーソル下の折り畳みを開く
" :zo
"
" カーソル下の折り畳みを再帰的に全て開く
" :zO
"
" カーソル下の折り畳みを閉じる
" :zc
" :zm
"
" カーソル下の折り畳みを再帰的に全て閉じる
" :zC
" :zM
" }}}

"see:
" http://qiita.com/items/019250dbca167985fe32
" http://blogaomu21.blog91.fc2.com/blog-entry-190.html
"set paste
" ... oops, 'set paste' disables 'set autoindent'!!

" see: https://vim-jp.org/vimdoc-ja/syntax.html#:colorscheme
"colorscheme blue

" cheat sheet and references:
" {{{ file encoding/newline cheat sheet
" 文字コードの変更
" :set fileencoding=文字コード
" :set fenc=文字コード (上のコマンドの短い形式。こちらでも良い。)
" :set fileencoding=euc-jp (エンコーディングEUC-JPに変更。)
" :set fileencoding=shift_jis (エンコーディングSHIFT_JISに変更。)
" :set fileencoding=utf-8 (エンコーディングUTF-8に変更。)
"
" ファイルフォーマット(=改行コード)の変更
" :set fileformat=ファイルフォーマットの種類
" :set ff=ファイルフォーマットの種類
" (上のコマンドの短い形式。こちらでも良い。)
" :set fileformat=dos (改行をWindowsの形式に変更。)
" :set fileformat=mac (改行をMacの形式に変更。)
" :set fileformat=unix (改行をUnixの形式に変更。)
"
" ファイルが文字化けしている場合のエンコーディングの修正の手順
" (1) ファイルを文字化けしない、正しいエンコーディングで開き直します。
" :e ++enc=utf-8 ...
" (2) 変更したいファイルのエンコーディングをセットします。
" :set fileencoding=euc-jp ...
" (3) 最後にファイルの保存を行います。
" :w ...
" }}}
" {{{ buffer list/switch
" ref: https://vim-jp.org/vimdoc-ja/usr_22.html#22.4
"
" バッファ一覧
" :ls
"
" バッファ一覧で確認出来たバッファ番号を使って、バッファを切替
" :b バッファ番号
"
" 非表示のバッファも含めて全て表示する。
" :buffers!
"
" バッファを完全に解放する。
" :bwipe
" }}}
" {{{ window split/move
" ref: https://vim-jp.org/vimdoc-ja/usr_08.html
"
" 編集中のウインドウを分割
" C-w s -> 垂直方向
" C-w v -> 水平方向
"
" 新しいファイルを開く時にウインドウを分割したい。
" 垂直方向
" :new ファイル名
" 水平方向
" :vnew ファイル名
"
" 空っぽのウインドウで分割したい。
" C-w n
" (個人的には「空っぽ」よりかは、":new ."でディレクトリ(Netrw)を開く方が好み。)
"
" ウインドウを移動
" C-w h/j/k/l
" C-w w 次のウインドウに移動
"
" 現在のウインドウを最大化
" C-w _
"
" 全てのウインドウサイズを揃える
" C-w =
" }}}
" {{{ tab split/move
" ref:
" https://vim-jp.org/vimdoc-ja/usr_08.html#08.9
" https://vim-jp.org/vimdoc-ja/tabpage.html
"
" 新しいタブを開く
" :tabnew (ファイル名)
" :tabedit (ファイル名)
"
" タブ切替
" :tabnext or "gt"
" :tabprevious or "gT"
" :tabfirst
" :tablast
"
" タブ一覧と移動
" :tabs
" :tabmove タブ番号
" }}}
" {{{ netrw reference url
" ref:
" https://vim-jp.org/vimdoc-ja/pi_netrw.html
"
" キーマップ:
" https://vim-jp.org/vimdoc-ja/pi_netrw.html#netrw-browse-maps
" }}}
"
