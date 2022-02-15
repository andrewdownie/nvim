" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

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

" Code completion (how do I setup language servers tho?)
" If you get coc errors on start up, you may need to go to ~\.vim\plugged\coc.nvim, and then run npm install
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

" Scrollbar for vim
Plug 'dstein64/nvim-scrollview'

" Ability to create a personal wiki in vim?
"Plug 'alok/notational-fzf-vim' " TODO: Needs a little setup

" Windows that are focused on particual lines of code?
"Plug 'hoschi/yode-nvim'

" File list
Plug 'scrooloose/nerdtree'
Plug 'tsony-tsonev/nerdtree-git-plugin'
"Plug 'tiagofum/vimnerdtree-syntax-highlight' " For some reason this now
"refuses to download

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

" Themes
Plug 'morhetz/gruvbox'

" Syntax
"Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

call plug#end()

" Setup required for vgit to work
lua << EOF
require('vgit').setup()
EOF

" Custom global variables
if !exists('g:oneWinShown')
  let g:oneWinShown = 0
endif
let g:ReopenNERDTree = exists('g:NERDTree') && g:NERDTree.IsOpen()

" Save global variables that start with a capital to the current session
:set sessionoptions+=globals

" Always show tabline
set showtabline=2

" Allow mouse scrolling and selection
set mouse=a

" Set gruvbox theme to darkest
let g:gruvbox_contrast_dark="hard"

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

  " If the current window is not NERDTree, but nerd tree is open
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

" Close nerd tree when doing a vertical diff using fugitive
nnoremap dv :NERDTreeClose

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

    :ScrollViewEnable
endfunction

let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

let g:NERDTreeGitStatusWithFlags = 1
"let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"let g:NERDTreeGitStatusNodeColorization = 1
"let g:NERDTreeColorMapCustom = {
    "\ "Staged"    : "#0ee375",  
    "\ "Modified"  : "#d9bf91",  
    "\ "Renamed"   : "#51C9FC",  
    "\ "Untracked" : "#FCE77C",  
    "\ "Unmerged"  : "#FC51E6",  
    "\ "Dirty"     : "#FFBD61",  
    "\ "Clean"     : "#87939A",   
    "\ "Ignored"   : "#808080"   
    "\ }                         


let g:NERDTreeIgnore = ['^node_modules$']

" vim-prettier
"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" run prettier on save
"let g:prettier#autoformat = 0
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" j/k will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Hybrid number mode
set number relativenumber

set smarttab
set cindent
set tabstop=4
set shiftwidth=4
" always uses spaces instead of tab characters
set expandtab

colorscheme gruvbox

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
"autocmd BufEnter * call SyncTree() " TODO: I think there are causing issues
"for me
"autocmd BufRead * call SyncTree()

"\ 'coc-snippets', " causes python errors and I don't really care about
" snippets

" coc config
let g:coc_global_extensions = [
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ ]
" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=10000 " This lags my work laptop. Much professional device.

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Only show sessions on the startify screen
let g:startify_lists = [
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ ]

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight') 

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"nmap <silent> <C-d> <Plug>(coc-range-select) " ctrl+d is jump up half a page
"in default vim
"xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
" I don't think this is needed with light line
"set statusline=
"set statusline+=%t                          " File name
"set statusline+=\                           " Space
"set statusline+=%{FugitiveStatusline()}     " Git branch
"set statusline+=%=                          " Right align
"set statusline+=%10((%l,%c)%)               " Line and column
"set statusline+=\                           " Space
"set statusline+=%-3P                        " Percentage
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Stop space bar from moving cursor in normal mode to make it more comfortable
" to use space bar as a modifier key for coc commands
nnoremap <space> <nop>

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent> <C-o>  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

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

