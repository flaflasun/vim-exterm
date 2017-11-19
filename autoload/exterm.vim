scriptencoding utf-8

if !exists('g:loaded_exterm')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

function! exterm#bufnew()
  if &buftype == "terminal" && &filetype == ""
    set filetype=terminal
  endif
endfunction

function! exterm#filetype()
  set nonumber
  set conceallevel=0
  set colorcolumn=""
endfunction

function! exterm#new(args) abort
  call exterm#close()
  execute "botright terminal" a:args
endfunction

function! exterm#close()
  if bufwinnr(exterm#bufnr()) > 0
    execute bufwinnr(exterm#bufnr()) . 'wincmd w'
    execute 'quit'
    return 0
  endif
  return -1
endfunction

function! exterm#toggle() abort
  if exterm#bufnr() < 0
    execute "botright terminal"
  elseif exterm#close() < 0
    let l:term_height = term_getsize(exterm#bufnr())[0]
    let l:term_status = term_getstatus(exterm#bufnr())
    let l:cmd = printf('botright%s ', l:term_height)
    execute l:cmd . "split"
    execute "buffer + " exterm#bufnr()

    if l:term_status == "running,normal"
      call feedkeys('i')
    endif
  endif
endfunction

function! exterm#bufnr()
  if empty(term_list())
    return -1
  else
    return term_list()[0]
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
