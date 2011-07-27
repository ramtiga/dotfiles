"leader 設定
""let mapleader = '<C-m>'

set runtimepath+=$VIMRUNTIME/after
set runtimepath+=$VIMRUNTIME/after
"vi互換の動きにしない
set nocompatible

filetype off
set rtp+=~/.vim/vundle.git/
call vundle#rc()
 
" 利用中のプラグインをBundle
Bundle 'rails.vim'
Bundle 'bufexplorer.vim'
Bundle 'neocomplcache.vim'
Bundle 'unite.vim'
Bundle 'Perldoc.vim'
Bundle 'snipMate.vim'
Bundle "tpope/vim-fugitive"

filetype plugin indent on


"カーソルキーで行末／行頭の移動可能に設定。
set whichwrap=b,s,[,],<,>
nnoremap h <Left>
nnoremap l <Right>

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

" 見た目で行移動
nnoremap j gj
nnoremap k gk

" 削除でレジスタに格納しない(ビジュアルモードでの選択後は格納する)
nnoremap x "_x
""nnoremap dd "_dd
nnoremap diw "_diw
nnoremap dw "_dw

"タブを空白で入力する
set expandtab

"標準タブは2
set tabstop=2
set softtabstop=2

"自動的にインデントする
set autoindent

"インクリメンタルサーチを行う
set incsearch

" 文字コード関連
" 文字コードの自動解釈の優先順位
set fileencodings=utf-8,cp932,euc-jp

" 内部の解釈の文字コード　設定ファイルもこのコードで書け
set encoding=utf-8

" ヤンクをクリップボードへ送り込む
set clipboard+=unnamed

"ルーラーを表示
set ruler
set title

" 矩形選択で行末を超えてブロックを選択できるようにする
set virtualedit+=block

"escでハイライトをオフ
"nnoremap <ESC> <ESC>:noh<CR>

" ノーマルモード中でもエンターキーで改行挿入でノーマルモードに戻る
"noremap <CR> i<CR><ESC>

"inoremap { {}<LEFT><CR><ESC>O<Tab>
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

" gvim用
"nmap <M-h> <C-w><C-h>
""nmap <d-j> <C-w><C-j>
nmap <Down> <C-w><C-j>
nmap <Up> <C-w><C-k>
nmap <d-n> :bn<CR>
nmap <d-p> :bN<CR>

nmap > $a
nmap , 0

"プラグインを有効にする
""filetype plugin indent on

" hilight cursor line
autocmd WinEnter *  setlocal cursorline
autocmd WinLeave *  setlocal nocursorline
set cursorline

"MRU設定
"":let MRU_Auto_Close=0
"":let MRU_Max_Entries=50
"":let MRU_Window_Height=10

"ウィンドウ位置
":winpos 318 1

"変更中のファイルでも、保存しないで他のファイルを表示
"set hidden

"独自キーバインド
""nnoremap <Space>m :MRU<CR>
"inoremap <Space>a <Esc>
"inoremap <Space>w <Esc>:w<CR>
"nnoremap <Space>e :Explore<CR>
"nnoremap <Space>q :q!<CR>
"nnoremap <Space>vi vipy
"nnoremap <Space>s :%s/
"nnoremap <Space>gr :vimgrep // **/*.rb |cw
"nnoremap <Space>w :w<CR>
"nnoremap <Space>w :w<CR>
"nnoremap <Space>d :cd %:h<CR>
"nnoremap <Space>c :bd<CR>
"nnoremap <Space>/ /<C-r>*<CR>

cnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
inoremap <Space>w <Esc>:w<CR>
nnoremap <Space>w :w<CR>
nnoremap <C-k>e :Explore<CR>
nnoremap <C-k>q :q!<CR>
nnoremap <C-k>vi vipy
noremap  <C-k>s :%s/
nnoremap <C-k>gr :vimgrep // **/*.rb |cw
""nnoremap <C-k>d :cd %:h<CR>
nnoremap <C-k>/ /<C-r>*<CR>
nnoremap <C-k>d :Perldoc 
nnoremap <C-k>3 0i#<ESC>
nnoremap <C-k>@ :bd<CR>
nnoremap <C-k>r :!ruby %<CR>
nnoremap <C-k>x :!perl %<CR>

inoremap <<Tab> <% %><Left><Left><Left>
inoremap b<Tab> <br /><Esc> 
inoremap ><Tab> <Space>=><Space>''<Left>
inoremap =0 <Space>=<Space>
""nnoremap <C-l> :BufExplorer<CR>
""nnoremap <leader>m :Unite file_mru<CR>
nnoremap <C-m>m :Unite file_mru<CR>
nnoremap <C-l> :Unite buffer<CR>
nnoremap <C-k>u :Unite buffer file_mru<CR>
nnoremap <C-k>uf :Unite file<CR>
nnoremap <C-k>ud :UniteWithCurrentDir file<CR>
let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 200

let g:neocomplcache_enable_at_startup = 1

nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

"ステータスラインを表示
set laststatus=2

"":au BufEnter *.php,*.ctp,*.m,*.h execute ":lcd " . expand("%:p:h")
"neocomplcache
"let g:NeoComplCache_EnableAtStartup               = 1 
let g:NeoComplCache_MaxList                       = 20
let g:NeoComplCache_KeywordCompletionStartLength  = 2 
let g:NeoComplCache_MinKeywordLength              = 2 
let g:NeoComplCache_MinSyntaxLength               = 2 
let g:NeoComplCache_SmartCase                     = 1 
let g:NeoComplCache_EnableCamelCaseCompletion     = 1
let g:NeoComplCache_EnableUnderbarCompletion      = 1

""let g:NeoComplCache_SnippetsDir = '~/.vim/snippets'

" neocon keybindings
"------------------
" <TAB> completion.
""inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" snippets expand key
"imap <silent> <CR> <Plug>(neocomplcache_snippets_expand)
"smap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)

au FileType javascript set ts=2 sw=2 expandtab
au BufNewFile *.js set ft=javascript fenc=utf-8
autocmd BufNewFile,BufRead *.psgi set filetype=perl fenc=utf-8

""if has('gui_macvim') && has('kaoriya')
""  let s:ruby_libdir = system("ruby -rrbconfig -e 'print Config::CONFIG[\"libdir\"]'")
""  let s:ruby_libruby = s:ruby_libdir . '/libruby.dylib'
""  if filereadable(s:ruby_libruby)
""    let $RUBY_DLL = s:ruby_libruby
""  endif
""endif

