syntax on

"vunlde.vimで管理してるpluginを読み込む

filetype off
set rtp+=~/.vim/bundle/vundle/
" call vundle#rc()

if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim.git
  call neobundle#rc(expand('~/.vim/neobundle'))
endif

NeoBundle 'gmarik/vundle' 
NeoBundle 'tpope/vim-rails'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
""NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimshell'
NeoBundle 'git://github.com/Shougo/vimproc.git'
NeoBundle 'rails.vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'ref.vim'
NeoBundle 'vtreeexplorer'
NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'tomtom/tcomment_vim.git'
NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/togetter-vim'
NeoBundle 'mattn/mkdpreview-vim'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'fugalh/desert.vim'
NeoBundle 'vim-scripts/Zenburn'
NeoBundle 'ujihisa/unite-colorscheme'

filetype plugin indent on

" Common -------------------------------
""set t_Co=256
set nocompatible
colorscheme desert

set t_Co=256
" set cursorline
hi CursorLine   term=reverse cterm=none ctermbg=242

"カーソルキーで行末／行頭の移動可能に設定。
set whichwrap=b,s,[,],<,>
nnoremap h <Left>
nnoremap l <Right>

"insertモードでのカーソル形状変更"
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" 検索を循環させない
set nowrapscan

" バックアップファイルを作成しない
set nobackup

"インデント
set shiftwidth=2

" スワップファイルを作成しない
set noswapfile

" 対応括弧の瞬間強調時間
set matchtime=3

" 行番号表示
set number

" leader設定
let mapleader = ";"

" 見た目で行移動
nnoremap j gj
nnoremap k gk

" 削除でレジスタに格納しない(ビジュアルモードでの選択後は格納する)

nnoremap diw "_diw
nnoremap dw "_dw
nnoremap D "_D

"タブを空白で入力する
set expandtab

set tabstop=2
set softtabstop=2

"自動的にインデントする
set autoindent

"インクリメンタルサーチを行う
set incsearch

"検索に大文字小文字区別しない
set ic

" 文字コード関連
" 文字コードの自動解釈の優先順位
set fileencodings=utf-8,cp932,euc-jp

" 内部の解釈の文字コード　設定ファイルもこのコードで書け
set encoding=utf-8

" ヤンクをクリップボードへ送り込む
set clipboard+=unnamed

"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

"ルーラーを表示
set ruler
set title

" 矩形選択で行末を超えてブロックを選択できるようにする
set virtualedit+=block

set hlsearch
"escでハイライトをオフ
nnoremap <silent> <ESC> <ESC>:noh<CR>
" ノーマルモード中でもエンターキーで改行挿入でノーマルモードに戻る
"noremap <CR> i<CR><ESC>

"insertモードでBackspaceを効かす
set backspace=indent,eol,start

inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap { {}<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
vnoremap v $h


"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#000099 guibg=#ccdc90
augroup END

" gvim用
nmap <M-n> :bn<CR>
nmap <M-p> :bN<CR>
"nmap <Down> <C-w><C-j>
nmap <C-n> <C-w><C-j>
nmap <C-p> <C-w><C-k>

"nmap > $a{
"nmap > $a;<CR>
nmap > $a
nmap , 0


nnoremap <Leader>t :VTreeExplore<CR>
"nnoremap <Leader>q :q!<CR>
nnoremap <Leader>vi vipy
nnoremap <Leader>s :%s/
nnoremap <Leader>gr :vimgrep // **/*.php \|cw<LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT>
"nnoremap <Leader>pri iprint_r($);exit();<CR><ESC>k<RIGHT><RIGHT><RIGHT><RIGHT><RIGHT><RIGHT><RIGHT><RIGHT><RIGHT>a
nnoremap <Leader>aa ggVGx
nnoremap <Leader>c :bd<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>e :w<CR>
inoremap <Leader>w <Esc>:w<CR>
inoremap <Leader>e <Esc>:w<CR>
nnoremap <Leader>, i<% %><Left><Left><Left>
inoremap <M-,> <% %><Left><Left><Left>
inoremap b<Tab> <br /><Esc> 
nnoremap <Leader>/ /<C-r>*<CR>
inoremap ><Tab> <Space>=><Space>
inoremap .<Tab> ->
inoremap <C-h> <BS>
"nnoremap <C-l> :BufExplorer<CR>
nnoremap <C-m>m :Unite file_mru<CR>
"nnoremap <Space>m :Unite file_mru<CR>
nnoremap <C-l> :Unite buffer<CR>
"nnoremap <Space>u :Unite buffer file_mru<CR>
"nnoremap <Space>uf :Unite file<CR>
"nnoremap <Space>ud :UniteWithCurrentDir file<CR>
map <Leader>x !python -m BeautifulSoup<CR>
nnoremap <Leader>q :TComment<CR>
vnoremap <Leader>q :TComment<CR>

let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 200

nnoremap <Leader>r :!ruby %<CR>
inoremap <C-k> <ESC>

"neocomplcache
let g:NeoComplCache_EnableAtStartup               = 1 
let g:NeoComplCache_MaxList                       = 20
let g:NeoComplCache_MinKeywordLength              = 2 
let g:NeoComplCache_MinSyntaxLength               = 2 
let g:NeoComplCache_SmartCase                     = 1 
let g:NeoComplCache_EnableCamelCaseCompletion     = 1
let g:NeoComplCache_EnableUnderbarCompletion      = 1
let g:neocomplcache_enable_at_startup = 1

imap <silent> <C-i> <Plug>(neocomplcache_snippets_expand)
smap <silent> <C-i> <Plug>(neocomplcache_snippets_expand)

let g:unite_cursor_line_highlight = 'TabLineSel'

" ------------------
" NERDTree
" ------------------
nmap <silent> <C-e>      :NERDTreeToggle<CR>
vmap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
omap <silent> <C-e>      :NERDTreeToggle<CR>
imap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=1
let g:NERDTreeMouseMode=3

