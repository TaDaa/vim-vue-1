if exists('b:did_indent')
  finish
endif

let s:languages = ['html', 'pug', 'javascript', 'css', 'scss', 'stylus', 'typescript', 'coffee']
let s:indentexpr = {}

for s:language in s:languages
  unlet! b:did_indent

  let path = ''
  if exists('g:vim_vue_indent_paths') && has_key(g:vim_vue_indent_paths, s:language)
    let path = g:vim_vue_indent_paths[s:language]
  else
    let path = 'indent/' . s:language . '.vim'
  endif
  execute 'runtime! ' .path

  let s:indentexpr[s:language] = &indentexpr
endfor

let b:did_indent = 1

setlocal indentexpr=vue#GetVueIndent()
setlocal indentkeys=o,O,*<Return>,0],0),0},!^F

if exists("*vue#GetVueIndent")
  finish
endif

function! vue#GetVueIndent()
  let g:last_indentexpr = vue#IndentifySyntaxRegion()
  execute 'let l:indent = ' . get(s:indentexpr, vue#IdentifySyntaxRegion())

  return l:indent
endfunction
