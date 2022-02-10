if !exists('g:os')
  if has('win32') || has('win16')
    let g:os = 'Windows'
  else
    let g:os = substitute(system('uname'), '\n', '', '')
  endif
endif

" Disable GUI based tabline in order to use TUI based tabline
GuiTabline 0

" Set font
if exists(':GuiFont')
  if g:os == 'Windows'
    " Windows compatible version of FiraCode Nerd Font Mono
    GuiFont! FiraCode NF:h9
  else
    GuiFont! FiraCode Nerd Font Mono:h12
  endif
endif

"if g:os == 'Windows'
  " Setting terminal to bash breaks toggle term, doesn't seem like the plugin was
  " tested with windows
   "let &shell='bash'
   "let &shellcmdflag = '-c'
   "let &shellredir = '>%s 2>&1'
   "set shellquote= shellxescape=
    "set noshelltemp
   "set shellxquote=
   "let &shellpipe='2>&1| tee' "set shellquote= shellxquote=
   "let $TMP="/tmp"
"endif

