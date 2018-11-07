scriptencoding utf-8

if !exists('g:loaded_exterm')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:exterm_close')
  let g:exterm_close = 0
endif

if !exists('g:exterm_shell')
  let g:exterm_shell = ""
endif

let s:terminal_option = g:exterm_close == 1 ? "++close" : ""
let s:terminal_shell = g:exterm_shell
let s:terminal_cmd = "botright terminal" . s:terminal_option . " " . s:terminal_shell

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
  let l:terminal_cmd = s:terminal_cmd
  if a:args != "" && g:exterm_close
    let l:terminal_cmd = "botright terminal"
  endif
  execute l:terminal_cmd a:args
endfunction

function! exterm#close()
  let l:current_buf_num = winnr()
  let l:terminal_buf_num = bufwinnr(exterm#bufnr())
  if l:terminal_buf_num < 0
    return -1
  endif
  execute l:terminal_buf_num . 'wincmd w'
  execute 'quit'
  if l:current_buf_num != l:terminal_buf_num
    execute l:current_buf_num . 'wincmd w'
  endif
  return 0
endfunction

function! exterm#toggle() abort
  if exterm#bufnr() < 0
    execute s:terminal_cmd
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
