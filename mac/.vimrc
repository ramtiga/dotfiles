syntax on

"leader 設定
let mapleader = ';'

set runtimepath+=$VIMRUNTIME/after
set runtimepath+=$VIMRUNTIME/after
set rtp+=$GOROOT/misc/vim

exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")

"vi互換の動きにしない
set nocompatible

filetype off
if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim.git
  call neobundle#rc(expand('~/.vim/bundle'))
endif
 
"" 利用中のプラグインをBundle
NeoBundle 'gmarik/vundle'
NeoBundle 'tpope/vim-rails'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/vimproc.git'
NeoBundle 'rails.vim'
NeoBundle 'snipMate'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'ref.vim'
NeoBundle 'vtreeexplorer'
NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'vim-scripts/twilight'
NeoBundle 'jonathanfilip/vim-lucius'
NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'vim-scripts/Wombat'
NeoBundle 'tomasr/molokai'
NeoBundle 'vim-scripts/rdark'
NeoBundle 'mrkn256/mrkn256.vim'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'tomtom/tcomment_vim.git'
NeoBundle 'gregsexton/gitv'
NeoBundle 'bling/vim-airline'
NeoBundle 'mattn/vim-airline-weather'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/sonictemplate-vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'osyo-manga/vim-over'

filetype plugin on
filetype indent on

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

"検索大文字小文字区別なし
set ic

" 文字コード関連
" 文字コードの自動解釈の優先順位
set fileencodings=utf-8,cp932,euc-jp

" 内部の解釈の文字コード　設定ファイルもこのコードで書け
set encoding=utf-8

" ヤンクをクリップボードへ送り込む
"set clipboard+=unnamed

"ルーラーを表示
set ruler
set title

" 矩形選択で行末を超えてブロックを選択できるようにする
set virtualedit+=block

"escでハイライトをオフ
nnoremap <ESC><ESC> :noh<CR>

" ノーマルモード中でもエンターキーで改行挿入でノーマルモードに戻る
"noremap <CR> i<CR><ESC>

"enabled backspace
set backspace=start,eol,indent

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
nmap <C-n> <C-w><C-j>
nmap <C-p> <C-w><C-k>
nmap <d-n> :bn<CR>
nmap <d-p> :bN<CR>

nmap > $a
nmap , 0

" hilight cursor line
autocmd WinEnter *  setlocal cursorline
autocmd WinLeave *  setlocal nocursorline
set cursorline
" hi 

"ウィンドウ位置
":winpos 318 1

"変更中のファイルでも、保存しないで他のファイルを表示
"set hidden

"独自キーバインド
cnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
nnoremap <Leader>e :w<CR>
nnoremap <leader>t :VTreeExplore<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>vi vipy
nnoremap <leader>v vep
noremap  <leader>s :%s/
nnoremap <leader>gr :vimgrep //j **/*.rb |cw
nnoremap <leader>/ /<C-r>*<CR>
nnoremap <leader>d :Perldoc 
nnoremap <leader>3 0i#<ESC>
nnoremap <leader>@ :bd<CR>
nnoremap <leader>r :w<CR>:!ruby %<CR>
nnoremap <leader>ss :w<CR>:!rspec -fs -c %<CR>
nnoremap <leader>x :!perl %<CR>
nnoremap <leader>g :w<CR>:!go run %<CR>

inoremap <leader>r <ESC>:w<CR>:!ruby %<CR>
inoremap <Leader>e <ESC>:w<CR>
inoremap <leader>g <ESC>:w<CR>:!go run %<CR>
inoremap <<Tab> <% %><Left><Left><Left>
inoremap b<Tab> <br /><Esc> 
inoremap ><Tab> <Space>=><Space>
inoremap =0 <Space>=<Space>
nnoremap <C-m>m :Unite file_mru<CR>
nnoremap <C-l> :Unite buffer<CR>

let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 200
let g:unite_cursor_line_highlight = "TabLineSel"

let g:neocomplcache_enable_at_startup = 1

nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <Leader>q :TComment<CR>
vnoremap <Leader>q :TComment<CR>

"ステータスラインを表示
set laststatus=2

"":au BufEnter *.php,*.ctp,*.m,*.h execute ":lcd " . expand("%:p:h")
"neocomplcache
"let g:NeoComplCache_EnableAtStartup               = 1 
let g:NeoComplCache_MaxList                       = 20
""let g:NeoComplCache_KeywordCompletionStartLength  = 2 
let g:NeoComplCache_MinKeywordLength              = 2 
let g:NeoComplCache_MinSyntaxLength               = 2 
let g:NeoComplCache_SmartCase                     = 1 
let g:NeoComplCache_EnableCamelCaseCompletion     = 1
let g:NeoComplCache_EnableUnderbarCompletion      = 1

" neocon keybindings
"------------------
" <TAB> completion.
""inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" snippets expand key
imap <silent> <C-i> <Plug>(neocomplcache_snippets_expand)
smap <silent> <C-i> <Plug>(neocomplcache_snippets_expand)

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

"preview interpreter's output(Tip #1244)
function! Ruby_eval_vsplit() range
    if &filetype == "ruby"
        let src = tempname()
        let dst = "Ruby Output"
        " put current buffer's content in a temp file
        silent execute ": " . a:firstline . "," . a:lastline . "w " . src
        " open the preview window
        silent execute ":pedit! " . dst
        " change to preview window
        wincmd P
        " set options
        setlocal buftype=nofile
        setlocal noswapfile
        setlocal syntax=none
        setlocal bufhidden=delete
        " replace current buffer with ruby's output
        silent execute ":%! ruby " . src . " 2>&1 "
        " change back to the source buffer
        wincmd p
    endif
endfunction
"<F10>でバッファのRubyスクリプトを実行し、結果をプレビュー表示
vmap <silent> <F10> :call Ruby_eval_vsplit()<CR>
nmap <silent> <F10> mzggVG<F10>`z
map  <silent> <S-F10> :pc<CR>

colorscheme mrkn256

"powerline
let g:Powerline_symbols = 'fancy'
set t_Co=256

"VTreeExplore
let g:treeExplHidden = 1

"Neocomplete
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'
    
    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

