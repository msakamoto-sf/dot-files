" vim: expandtab fenc=utf-8 ff=unix ft=vim ts=2 sw=2 sts=0
" about 'mode line', see: http://nanasi.jp/articles/howto/file/modeline.html

if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
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
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

set fileformats=unix,dos,mac
if exists('&ambiwidth')
  set ambiwidth=double
endif

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
set number
set showmatch
set showmode
set complete+=k

let &titleold=expand("%:p:h")
set title

map Q gq

if has("autocmd")

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
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd BufNewFile,BufRead *.gradle setlocal expandtab tabstop=4 shiftwidth=4

endif " has("autocmd")


set ignorecase
set smartcase
set wrapscan
syntax on
set list
set hlsearch
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>
nnoremap j gj
nnoremap k gk
map <kPlus> <C-W>+
map <kMinus> <C-W>-

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
set fdm=marker

"see:
" http://qiita.com/items/019250dbca167985fe32
" http://blogaomu21.blog91.fc2.com/blog-entry-190.html
"set paste
" ... oops, 'set paste' disables 'set autoindent'!!

"colorscheme blue

"Classic Vundle/Bundle {{{
"filetype off
"set rtp+=~/.vim/vundle.git/
"call vundle#rc()

"" original repos on github
""Bundle '...'
"Bundle 'https://github.com/Shougo/unite.vim.git'
"Bundle 'https://github.com/Shougo/vimfiler.git'
"Bundle 'https://github.com/Shougo/vimproc.git'
"Bundle 'https://github.com/Shougo/vimshell.git'
"Bundle 'surround.vim'
"Bundle 'https://github.com/mattn/emmet-vim'
"Bundle 'JavaScript-syntax'
"Bundle "pangloss/vim-javascript"
"Bundle 'basyura/jslint.vim'

""sudo.vim :
""https://github.com/vim-scripts/sudo.vim
""http://nanasi.jp/articles/vim/sudo_vim.html
""http://nob-log.info/2012/04/04/sudo-vim/
"Bundle 'https://github.com/vim-scripts/sudo.vim.git'
"" -> 'vim sudo:/etc/xxxx' or ':e sudo:%'

"" vim-scripts repos
""Bundle '...vim'

"" non github repos
""Bundle 'git://git.....com/foo.git'

"filetype plugin indent on
"}}}

"NeoBundle {{{
filetype plugin indent off
" https://github.com/Shougo/neobundle.vim
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'tpope/vim-surround'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'pangloss/vim-javascript'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"}}}

"vimfiler {{{
" open new tab
let g:vimfiler_edit_action = 'tabopen'
" disable netrw
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
" open directory for current buffer
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
" open direcotry (like IDE side bar control)
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>

augroup VimFiler
  autocmd FileType vimfiler call s:vimfiler_my_settings()
augroup END
function! s:vimfiler_my_settings()
" customize keymappings
nunmap <buffer> j
nunmap <buffer> k
"  unmap <buffer> t
"  unmap <buffer> T
"  nnoremap <buffer> zR <Plug>(vimfiler_expand_tree_recursive)
"  nnoremap <buffer> zo <Plug>(vimfiler_expand_tree)
"  nmap <buffer> q <Plug>(vimfiler_exit)
"  nmap <buffer> Q <Plug>(vimfiler_hide)
endfunction
"}}}
"zencoding-vim {{{
let g:user_zen_settings = {
\  'lang' : 'ja',
\  'html' : {
\    'filters' : 'html',
\    'snippets' : {
\      'jq' : "<script src=\"//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js\"></script>\n<script>\n\\$(function() {\n\t|\n})()\n</script>",
\      'cd' : "<![CDATA[|]]>",
\    },
\  },
\  'php' : {
\    'extends' : 'html',
\    'filters' : 'html,c',
\  },
\  'xml' : {
\    'extends' : 'html',
\  },
\  'haml' : {
\    'extends' : 'html',
\  },
\ 'javascript' : {
\    'snippets' : {
\      'jq' : "\\$(function() {\n\t\\${cursor}\\${child}\n});",
\      'jq:json' : "\\$.getJSON(\"${cursor}\", function(data) {\n\t\\${child}\n});",
\      'jq:each' : "\\$.each(data, function(index, item) {\n\t\\${child}\n});",
\      'fn' : "(function() {\n\t\\${cursor}\n})();",
\      'tm' : "setTimeout(function() {\n\t\\${cursor}\n}, 100);",
\    },
\    'use_pipe_for_cursor' : 0,
\  },
\}
"}}}

" jslint.vim
function! s:javascript_filetype_settings()
  autocmd BufLeave <buffer> call jslint#clear()
  autocmd BufWritePost <buffer> call jslint#check()
  autocmd CursorMoved  <buffer> call jslint#message()
endfunction
autocmd FileType javascript call s:javascript_filetype_settings()


