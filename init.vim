" WhichKey is bound to <space>

" TODO:
" - debugging with 'puremourning/vimspector'
" - testing with 'vim-test/vim-test'
" - editing with neovims built in lsp
"   - node + react
"   - java
"     - lombok?
"   - python
" - open a new window by default when fuzzy searching for a file with ctrl+p extension
" - custom display with 'sidebar-nvim/sidebar.nvim'

" - autoload seperate config for different languages (could this be set session level?)

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

"Themes
Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'

" Show custom hotkeys
Plug 'folke/which-key.nvim'

" Libraries
Plug 'nvim-lua/plenary.nvim' "vgit depends on plenary

" Smooth scroll with ctrl+[ud]
Plug 'yuttie/comfortable-motion.vim'

" Start screen for vim
Plug 'mhinz/vim-startify' 

" Pretty status line
Plug 'itchyny/lightline.vim'

" Tab numbers
Plug 'mkitt/tabline.vim'

" Improved Java syntax highlighting
Plug 'uiiaoo/java-syntax.vim'

" Language server for neovim
Plug 'mfussenegger/nvim-jdtls'

" Scrollbar for vim
Plug 'dstein64/nvim-scrollview'

" Minimap -> doesn't work atm?
Plug 'severin-lemaignan/vim-minimap'

" Pretty error panel
" Plug 'folke/trouble.nvim'
" 

" Ability to create a personal wiki in vim?
"Plug 'alok/notational-fzf-vim' " TODO: Needs a little setup

" Windows that are focused on particular lines of code?
"Plug 'hoschi/yode-nvim' " TODO: I have no idea how to use this yet

" File list
Plug 'scrooloose/nerdtree'
Plug 'tsony-tsonev/nerdtree-git-plugin'

" Fuzzy file search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Needed for *nix, but I don't think this does anything for windows, see below.

Plug 'junegunn/fzf.vim'
" fzf needs to be runnable via cmd prompt for windows usage. choco install fzf
" ripgrep needs to be runnable via cmd propmpt for windows usage. choco
" install ripgrep

" Toggle line comment with ctrl+/ in command mode
Plug 'scrooloose/nerdcommenter'

" Git diff and integrated git tooling
Plug 'tpope/vim-fugitive'

" Show git blame for the current line (gitlens style), and highlight modified lines in the
" sidebar (vscode style)
Plug 'tanvirtin/vgit.nvim'

" single command: ctrl+[hjkl] to jump between windows instead of default key chord ctrl+w [hjkl]
Plug 'christoomey/vim-tmux-navigator'

" Ability to toggle terminal vscode style
Plug 'akinsho/toggleterm.nvim'

" Linting
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" Icons
Plug 'ryanoasis/vim-devicons'

" React, nodejs and jsx
Plug 'mxw/vim-jsx'

Plug 'pangloss/vim-javascript'

Plug 'w0rp/ale' "Linting

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Autocomplete

call plug#end()

" Setup required for vgit to work
lua << EOF
require('vgit').setup()
EOF

lua << EOF
  require("which-key").setup {
            presets = {
              operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        }
      }
EOF

let g:deoplete#enable_at_startup = 1

let g:ale_linters = {
\ 'javascript': ['eslint'],
\}

let g:ale_fixers = {
\ 'javascript': ['prettier', 'eslint']
\ }

let g:ale_fix_on_save = 1

" Custom global variables
if !exists('g:oneWinShown')
  let g:oneWinShown = 0
endif
let g:ReopenNERDTree = exists('g:NERDTree') && g:NERDTree.IsOpen()

" Save global variables that start with a capital to the current session
:set sessionoptions+=globals

" Allow mouse scrolling and selection
set mouse=a

" Hide the preview window in fzf
let g:fzf_preview_window = []

" Make ripgrep ignore files in .gitignore
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

" Set scroll bar width to 10 characters
let g:scrollview_on_startup = 0
let g:scrollview_current_only = 1

" Prevent :qa from closing neovim, instead offer to save session, and then
" return to Startify. Neovim can then be exited from Startify by pressing q.
" Enter blank name to not save.
" Close nerd tree first to prevent issues with loading session.
" lcd %:p:h will write cwd to buffer level, which allows NERDTree to open to
" the correct cwd after opening a session.
function ExitSession()
 :ScrollViewDisable
 :set showtabline=1
 :let g:ReopenNERDTree = g:NERDTree.IsOpen()
 :let g:SessionCwd = getcwd()
 :NERDTreeClose
 :SSave!
 :SClose
endfunction

" Save and return to startify
cabbrev qa :call ExitSession()

" Save and exit Neovim
cabbrev qaq :call ExitSession() <bar> :exit

function QuitButDontExit()
  let winCount = winnr('$')
  let tabCount = tabpagenr('$')
zsh:1: command not found: jj
  if !exists('b:NERDTree') && exists('g:NERDTree') && g:NERDTree.IsOpen()
    let winCount = winCount - 1
  endif

  if 1 == winCount
  " If there's two windows left, and the current window is not nerdtree
    if 1 == tabCount
      " if this is the last tab, close buffer and open a new one
      :enew
      if !g:NERDTree.IsOpen()
        " Open nerd tree if it's not open
        execute 'NERDTree' getcwd()
        :echo 'run :qa to save and end session, or :qaq to save session and exit vim'
      else
        " Jump to nerd tree if it is open
        :exe "normal 1\<C-w>w"
      endif
    else
      " if this isn't the last tab, close the current tab
      :tabclose
    endif
  else
    :q
  endif
endfunction

" if: closing the last buffer then: open startify, otherwise: send q as usual
cabbrev q call QuitButDontExit()
cabbrev wq w <bar> call QuitButDontExit()

" Highlight the current line
set cursorline

" Ignorecase while searching
set ignorecase

" set ruler for  line length of 80
set colorcolumn=80

" Open neovim rc
command Vimrc :e $MYVIMRC

nnoremap <space> :WhichKey <CR>

" Close nerd tree when doing a vertical diff using fugitive
nnoremap dv :NERDTreeClose<CR>

" Open fuzzy file search
nnoremap <C-p> :Files<CR>

" Open fuzzy search in files
nnoremap <C-f> :Rg<CR>

" Open marks menu
nnoremap ' :Marks<CR>

" Open fugitive (interactive equivalent of 'git status')
nnoremap <C-g> :tabnew<CR><bar>:Git<CR><bar><C-w>=<bar>:let g:oneWinShown=0<CR>5j
" Open fugitive git blame map (press 'o' to open version from that commit, you
" can then recursively call git blame on that commit)
nnoremap <C-b> :Git blame<CR>

" Show plugin messages
nnoremap <C-e> :messages<CR>

" ctrl+n to open nerdtree (n for nerdtree)
nnoremap <C-n> :execute 'NERDTreeToggle' getcwd()<CR> <bar> <C-w>=

" ctrl+= to open new tab
nnoremap <C-=> :tabnew<CR>

" ctrl+- to close current tab
nnoremap <C--> :tabclose<CR>

" Comment a list using ctrl+/ in command mode (save as VSCode with vim
" extension)
vmap <C-/> <plug>NERDCommenterToggle
nmap <C-/> <plug>NERDCommenterToggle

"autocmd TabNewEntered * NERDTree " Open nerdtree in new tabs
autocmd SessionLoadPost * :call SessionLoadPost() " Load nerdtree after loading a session (from startify for example)
"autoc TermOpen * TermExec 1 direction=float cmd="bash<CR>"<CR>

function SessionLoadPost()
    execute 'cd' g:SessionCwd
    let firstLineContents = getline(1)
    let winCount = winnr('$')
    let lineCount = line('$')

    let emptyWinOnly = 1 == winCount && 1 == lineCount && '' == firstLineContents

    " Open nerdtree if only file is empty
    if emptyWinOnly || g:ReopenNERDTree
        execute 'NERDTree' g:SessionCwd
    endif

    :set showtabline=2
    :ScrollViewEnable
endfunction

let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

let g:NERDTreeGitStatusWithFlags = 1

let g:NERDTreeIgnore = ['^node_modules$']

" ctrlp - exclusions
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Hybrid line number
set number relativenumber
set smarttab
set cindent
set tabstop=4
set shiftwidth=4
" always uses spaces instead of tab characters (...why?)
set expandtab

colorscheme gruvbox
"colorscheme oceanicnext
"
" Set gruvbox theme to darkest
"let g:gruvbox_contrast_dark="hard"


set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup .
set updatetime=10000 " This lags my work laptop. Much professional device.

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Only show sessions on the startify screen
let g:startify_lists = [
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ ]

" Make ctrlp use Nerd trees current root dir as the search dir
let g:NERDTreeChDirMode = 2
let g:ctrlp_working_path_mode = 'rw'

" Remap ^[ to exit insert mode for terminal
tnoremap <C-[> <C-\><C-n>

" Sync system clipboard and neovim clipboard
set clipboard+=unnamedplus

" Toggle terminal
nmap <C-'> :ToggleTerm 1 direction=float<CR>
tnoremap <C-'> <C-\><C-n>:ToggleTerm 1<CR>

" Toggle window to be maximized, or resize all windows
nnoremap <expr><C-,> g:oneWinShown == 1
      \ ? ':call ShowAllWin()<CR>'
      \ : ':call ShowOneWin()<CR>'

function ShowAllWin()
  :let g:oneWinShown = 0
  if 1 == g:ReopenNERDTree
      :NERDTree
      let g:ReopenNERDTree = 0
  endif
  :exe "normal \<C-w>="
endfunction

function ShowOneWin()
  if exists('g:NERDTree') && g:NERDTree.IsOpen()
    :NERDTreeClose
    let g:ReopenNERDTree = 1
  endif
  :exe "normal \<C-w>_"
  :exe "normal \<C-w>|"
  :let g:oneWinShown = 1
endfunction

" Make column gutter background color match theme when using VGit
highlight clear SignColumn

