" ------------------------------------
" switch.vim
" ------------------------------------
let g:switch_custom_definitions =
    \ [
    \   ['if', 'unless'],
    \   ['while', 'until'],
    \   ['blank?', 'present?'],
    \   ['include', 'extend'],
    \   ['class', 'module'],
    \   ['.inject', '.delete_if'],
    \   ['.map', '.map!'],
    \   ['attr_accessor', 'attr_reader', 'attr_writer'],
    \   ['describe', 'context', 'specific', 'example'],
    \   ['before', 'after'],
    \   ['be_true', 'be_false'],
    \   ['get', 'post', 'put', 'delete'],
    \   ['==', 'eql', 'equal'],
    \   { '\.should_not': '\.should' },
    \   ['\.to_not', '\.to'],
    \   { '\([^. ]\+\)\.should\(_not\|\)': 'expect(\1)\.to\2' },
    \   { 'expect(\([^. ]\+\))\.to\(_not\|\)': '\1.should\2' },
    \ ]

"let g:switch_custom_definitions = {
"      \ '*': [
"      \   ['is', 'are']
"      \ ],
"      \ 'ruby,eruby,haml' : [
"      \   ['if', 'unless'],
"      \   ['while', 'until'],
"      \   ['.blank?', '.present?'],
"      \   ['include', 'extend'],
"      \   ['class', 'module'],
"      \   ['.inject', '.delete_if'],
"      \   ['.map', '.map!'],
"      \   ['attr_accessor', 'attr_reader', 'attr_writer'],
"      \ ],
"      \ 'Gemfile,Berksfile' : [
"      \   ['=', '<', '<=', '>', '>=', '~>'],
"      \ ],
"      \ 'erb,html,php' : [
"      \   { '<!--\([a-zA-Z0-9 /]\+\)--></\(div\|ul\|li\|a\)>' : '</\2><!--\1-->' },
"      \ ],
"      \ ],
"      \ 'rspec': [
"      \   ['describe', 'context', 'specific', 'example'],
"      \   ['before', 'after'],
"      \   ['be_true', 'be_false'],
"      \   ['get', 'post', 'put', 'delete'],
"      \   ['==', 'eql', 'equal'],
"      \   { '\.should_not': '\.should' },
"      \   ['\.to_not', '\.to'],
"      \   { '\([^. ]\+\)\.should\(_not\|\)': 'expect(\1)\.to\2' },
"      \   { 'expect(\([^. ]\+\))\.to\(_not\|\)': '\1.should\2' },
"      \ ],
"      \ 'markdown' : [
"      \   ['[ ]', '[x]']
"      \ ]
"      \ }
"

