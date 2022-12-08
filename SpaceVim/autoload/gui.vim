function! gui#before() abort
  if has("gui_running")
    set guifont=JetBrainsMono\ Nerd\ Font\ Mono
		win 108 48
  endif
endfunction
