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
  execute "botright terminal" a:args
endfunction

function! exterm#toggle() abort
  if exterm#bufnr() < 0
    execute "botright terminal"
  elseif bufwinnr(exterm#bufnr()) > 0
    execute bufwinnr(exterm#bufnr()) . 'wincmd w'
    execute 'quit'
  else
    let l:term_height = term_getsize(exterm#bufnr())[0]
    let l:term_status = term_getstatus(exterm#bufnr())
    let l:cmd = printf('botright%s ', l:term_height)
    execute l:cmd . "new"
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
