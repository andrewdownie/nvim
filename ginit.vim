if !exists('g:os')
  if has('win32') || has('win16')
    let g:os = 'Windows'
  else
    let g:os = substitute(system('uname'), '\n', '', '')
  endif
endif

" Set font
if exists(':GuiFont')
  if g:os == 'Windows'
    GuiFont! FiraCode NF:h9 " Windows compatible version of FiraCode Nerd Font Mono
  else
    GuiFont! FiraCode Nerd Font Mono:h12
  endif
endif

" Maximize neovim-qt on start (I'm still not sure how to make this work)
"call rpcnotify(0, 'Gui', 'WindowMaximized', 1)
"let g:GuiWindowFullScreen=1
"call GuiWindowMaximized(1)
