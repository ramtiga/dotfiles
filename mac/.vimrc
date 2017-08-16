syntax on

"leader 設定
let mapleader = ';'

set runtimepath+=$VIMRUNTIME/after

if $GOROOT != ''
  set rtp+=$GOROOT/misc/vim
endif

exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")

"vi互換の動きにしない
set nocompatible

filetype off
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  "  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
"call neobundle#begin(expand('~/.vim/bundle/'))

" dein
" Vim起動完了時にインストール
augroup PluginInstall
  autocmd!
  autocmd VimEnter * if dein#check_install() | call dein#install() | endif
augroup END

if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" 各プラグインをインストールするディレクトリ
let s:plugin_dir = expand('~/.vim/')

" dein.vimをインストールするディレクトリをランタイムパスへ追加
let s:dein_dir = s:plugin_dir . 'repos/github.com/Shougo/dein.vim'
execute 'set runtimepath+=' . s:dein_dir

"dein plugin settings
if dein#load_state(s:plugin_dir)
  call dein#begin(s:plugin_dir)
endif

"利用中のプラグインをBundle
" call dein#begin(expand('~/.vim/dein'))
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})

"call dein#add('Shougo/neomru.vim')
"call dein#add('Shougo/neosnippet')
call dein#add('gmarik/vundle')
call dein#add('tpope/vim-rails')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/neomru.vim')
"call dein#add('rails.vim')
"call dein#add('snipMate')
call dein#add('thinca/vim-ref')
call dein#add('thinca/vim-quickrun')
"call dein#add('ref.vim')
call dein#add('scrooloose/nerdcommenter.git')
call dein#add('tpope/vim-fugitive')
call dein#add('nanotech/jellybeans.vim')
call dein#add('w0ng/vim-hybrid')
call dein#add('vim-scripts/twilight')
call dein#add('jonathanfilip/vim-lucius')
call dein#add('jpo/vim-railscasts-theme')
call dein#add('altercation/vim-colors-solarized')
call dein#add('vim-scripts/Wombat')
call dein#add('tomasr/molokai')
call dein#add('vim-scripts/rdark')
call dein#add('mrkn/mrkn256.vim')
call dein#add('ujihisa/unite-colorscheme')
call dein#add('tomtom/tcomment_vim.git')
call dein#add('bling/vim-airline')
call dein#add('mattn/emmet-vim')
call dein#add('osyo-manga/vim-over')
call dein#add('Shougo/vimfiler')
call dein#add('scrooloose/nerdtree')
call dein#add('vim-scripts/ruby-matchit')
call dein#add('kmnk/vim-unite-giti.git')
call dein#add('Shougo/neocomplcache.vim')
call dein#add('Shougo/neocomplcache-rsense.vim')
call dein#add('tpope/vim-endwise')

" call dein#end()
"neocomplete.vim
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1

" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

" Rsense用の設定
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

"rsenseのインストールフォルダがデフォルトと異なるので設定
let g:rsenseHome = expand("/Users/dhane31/.rbenv/shims/rsense")
let g:rsenseUseOmniFunc = 1



filetype plugin on
filetype indent on

" if dein#check_install()
"   call dein#install()
" endif

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
" set tabstop=2
" set softtabstop=2

"自動的にインデントする
set autoindent

"インクリメンタルサーチを行う
set incsearch
set hlsearch

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
nnoremap <C-k><C-k> :noh<CR>

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
" autocmd WinEnter *  setlocal cursorline
" autocmd WinLeave *  setlocal nocursorline
" set cursorline
set ttyfast
set lazyredraw
set synmaxcol=200

"ウィンドウ位置
":winpos 318 1

"変更中のファイルでも、保存しないで他のファイルを表示
"set hidden

"独自キーバインド
cnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
nnoremap <Leader>e :w<CR>
" nnoremap <leader>t :VTreeExplore<CR>
nnoremap <leader>t :VimFiler<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>vi vipy
nnoremap <leader>v vep
noremap  <leader>s :%s/
nnoremap <leader>gr :vimgrep //j **/*rb |cw
nnoremap <leader>/ /<C-r>*<CR>
nnoremap <leader>d :Perldoc
nnoremap <leader>3 0i#<ESC>
nnoremap <leader>@ :bd<CR>
nnoremap <leader>r :w<CR>:!ruby %<CR>
"nnoremap <leader>ss :w<CR>:!bundle exec rspec -fd -c %<CR>
nnoremap <leader>ss :w<CR>:!rspec -fd -c<CR>
""nnoremap <leader>ss :w<CR>:!spec -cfs %<CR>
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
nnoremap <C-]> g<C-]>

inoremap bi<Tab> require 'pry'; binding.pry<ESC>
inoremap de<Tab> require 'ruby-debug'; debugger<ESC>

" vim-unite-giti
" nnoremap gl :Unite giti/log<CR>
" nnoremap gP :Unite giti/pull_request/base<CR>
" nnoremap gs :Unite giti/status -no-start-insert -horizontal<CR>
" nnoremap gh :Unite giti/branch_all<CR>
" nnoremap gb :Unite giti/branch<CR>

let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 200
let g:unite_cursor_line_highlight = "TabLineSel"


nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <Leader>q :TComment<CR>
vnoremap <Leader>q :TComment<CR>

"ステータスラインを表示
set laststatus=2

"":au BufEnter *.php,*.ctp,*.m,*.h execute ":lcd " . expand("%:p:h")
"neocomplcache
"let g:NeoComplCache_EnableAtStartup               = 1
" let g:NeoComplCache_MaxList                       = 20
" ""let g:NeoComplCache_KeywordCompletionStartLength  = 2
" let g:NeoComplCache_MinKeywordLength              = 2
" let g:NeoComplCache_MinSyntaxLength               = 2
" let g:NeoComplCache_SmartCase                     = 1
" let g:NeoComplCache_EnableCamelCaseCompletion     = 1
" let g:NeoComplCache_EnableUnderbarCompletion      = 1

" neocon keybindings
"------------------
" <TAB> completion.
""inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" snippets expand key
" imap <silent> <C-i> <Plug>(neocomplcache_snippets_expand)
" smap <silent> <C-i> <Plug>(neocomplcache_snippets_expand)

" au FileType javascript set ts=2 sw=2 expandtab
" au BufNewFile *.js set ft=javascript fenc=utf-8
autocmd BufNewFile,BufRead *.psgi set filetype=perl fenc=utf-8
auto BufWritePre *.go Fmt

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

autocmd ColorScheme * highlight Search term=reverse cterm=reverse ctermfg=66 ctermbg=222 gui=reverse guifg=#708090 guibg=#f0e68c
colorscheme mrkn256

"powerline
let g:Powerline_symbols = 'fancy'
set t_Co=256

"VTreeExplore
let g:treeExplHidden = 1



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

"rbtnn/rabbit-ui.vim
function! s:edit_csv(path)
  call writefile(map(rabbit_ui#gridview(map(readfile(a:path),'split(v:val,",",1)')), "join(v:val, ',')"), a:path)
endfunction

command! -nargs=1 EditCSV  :call <sid>edit_csv(<q-args>)

"TwitVim
let twitvim_browser_cmd = 'open'
let twitvim_force_ssl = 1
let twitvim_count = 40

if filereadable(expand('~/.vimrc.sw'))
  source ~/.vimrc.sw
endif

"NERDdTree
nnoremap <silent><C-e> :NERDTreeToggle<CR>
nnoremap <silent> ,,f :<C-u>NERDTreeFind<CR>

if !exists('loaded_matchit')
" matchitを有効化
  runtime macros/matchit.vim
endif

" ----------------------------------------
" Uniteの設定
" Uniteは要素の絞り込み、要素へのアクションができるプラグインです
" 例えば`:Unite file`ではファイルへ操作を行うことができます
" 詳しい使い方については下記を参照してください
" http://d.hatena.ne.jp/osyo-manga/20130307/1362621589
let g:giti_git_command = executable('hub') ? 'hub' : 'git'
nnoremap <silent>gm :Gcommit<CR>
nnoremap <silent>gM :Gcommit --amend<CR>
nnoremap <silent>gb :Gblame<CR>
nnoremap <silent>gB :Gbrowse<CR>

let g:fugitive_git_executable = executable('hub') ? 'hub' : 'git'
nnoremap <silent>gs :Unite giti/status -horizontal<CR>
nnoremap <silent>gl :Unite giti/log -horizontal<CR>
nnoremap <silent>gs :Unite giti/status -horizontal<CR>
nnoremap <silent>gh :Unite giti/branch_all<CR>

" vim-unite-giti {{{
" `:Unite giti/status`, `:Unite giti/branch`, ` :Unite giti/log`などを起動した
" 後に、各コマンドに合わせた設定を反映します
augroup UniteCommand
  autocmd!
  autocmd FileType unite call <SID>unite_settings()
augroup END

function! s:unite_settings() "{{{
  for source in unite#get_current_unite().sources
    let source_name = substitute(source.name, '[-/]', '_', 'g')
    if !empty(source_name) && has_key(s:unite_hooks, source_name)
      call s:unite_hooks[source_name]()
    endif
  endfor
endfunction"}}}

let s:unite_hooks = {}

function! s:unite_hooks.giti_status() "{{{
  nnoremap <silent><buffer><expr>gM unite#do_action('ammend')
  nnoremap <silent><buffer><expr>gm unite#do_action('commit')
  nnoremap <silent><buffer><expr>ga unite#do_action('stage')
  nnoremap <silent><buffer><expr>gc unite#do_action('checkout')
  nnoremap <silent><buffer><expr>gd unite#do_action('diff')
  nnoremap <silent><buffer><expr>gu unite#do_action('unstage')
endfunction"}}}

function! s:unite_hooks.giti_branch() "{{{
  nnoremap <silent><buffer><expr>d unite#do_action('delete')
  nnoremap <silent><buffer><expr>D unite#do_action('delete_force')
  nnoremap <silent><buffer><expr>rd unite#do_action('delete_remote')
  nnoremap <silent><buffer><expr>rD unite#do_action('delete_remote_force')
endfunction"}}}

function! s:unite_hooks.giti_branch_all() "{{{
  call self.giti_branch()
endfunction"}}}
"}}}
"
autocmd BufWritePre * :%s/\s\+$//ge

