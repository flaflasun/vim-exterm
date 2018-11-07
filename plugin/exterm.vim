scriptencoding utf-8

if exists('g:loaded_exterm') || v:version < 800
  finish
endif
let g:loaded_exterm = 1

let s:save_cpo = &cpo
set cpo&vim

augroup exterm
  autocmd!
  autocmd BufNew * call timer_start(0, { -> exterm#bufnew() })
  autocmd FileType terminal call exterm#filetype()
augroup END

command! -nargs=* Tnew call exterm#new(<q-args>)

command! Ttoggle call exterm#toggle()

let &cpo = s:save_cpo
unlet s:save_cpo
