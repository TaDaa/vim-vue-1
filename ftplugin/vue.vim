if exists('b:plugin_loaded')
  finish
endif

function! vue#IdentifySyntaxRegion()
  let l:line = search('<\(template\|script\|style\)[^>]*>', 'bn')
  let l:cline = line('.')
  let l:content = get(getbufline(bufnr('%'), l:line, l:line), '')

  if l:line == l:cline
    return 'html'
  elseif l:content =~ '<style \+lang="scss"[^>]*>'
    return 'scss'
  elseif l:content =~ '<style \+lang="stylus"[^>]*>'
    return 'stylus'
  elseif l:content =~ '<style[^>]*>'
    let g:css=1
    return 'css'
  elseif l:content =~ '<script \+lang="coffee"[^>]*>'
    return 'typescript'
  elseif l:content =~ '<script \+lang="typescript"[^>]*>'
    return 'typescript'
  elseif l:content =~ '<script[^>]*>'
    return 'javascript'
  elseif l:content =~ '<template \+lang="pug"[^>]*>'
    return 'pug'
  else
    return 'html'
  endif
endfunction

function! vue#SetConfigs()
  let l:type = vue#IdentifySyntaxRegion()
  let g:last_type = type
  let g:test = len(matchstr(l:type, 'javascript|typescript|coffee|scss|stylus'))
  let g:type_was_javascript=0
  if l:type == 'html' && &commentstring != '<!-- %s -->'
    setlocal commentstring=<!--\ %s\ -->
  elseif l:type =~ 'css' && &commentstring != '/* %s */'
    setlocal commentstring=/*\ %s\ */
  elseif l:type == 'pug' && &commentstring != '//- %s'
    setlocal commentstring=//-\ %s
  elseif match(l:type, 'javascript\|typescript\|coffee\|scss\|stylus') > -1 && &commentstring != '// %s'
    let g:type_was_javascript=1
    setlocal commentstring=//\ %s
  endif
endfunction

if exists('g:loaded_commentary')
  autocmd CursorMoved,CursorMovedI * call vue#SetConfigs()
endif


let b:plugin_loaded = 1
