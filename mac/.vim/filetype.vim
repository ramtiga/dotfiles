if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au BufNewFile,BufRead *.rb setlocal tabstop=2 shiftwidth=2
  au BufNewFile,BufRead *.go setlocal tabstop=8 shiftwidth=8
  au BufNewFile *.js set ft=javascript fenc=utf-8 tabstop=4 shiftwidth=4
augroup END

