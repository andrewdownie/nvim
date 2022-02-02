" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Libraries
Plug 'nvim-lua/plenary.nvim' " vgit and vim-nerd-tree-tabs depend on plenary

" Code completion (how do I setup language servers tho?)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" File list
Plug 'scrooloose/nerdtree'
Plug 'tsony-tsonev/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'jistr/vim-nerdtree-tabs' " Persistant nerd tree between tabs, to make it feel like a single panel

"Plug 'Xuyuanp/nerdtree-git-plugin'
"
" Fuzzy file search (why it doesn't find some files when I type the exact name tho?)
Plug 'ctrlpvim/ctrlp.vim' 

" Toggle line comment with ctrl+/ in command mode
Plug 'scrooloose/nerdcommenter'

" Git diff (can't seem to get it to list all modified files project wide? need
" to add config to define what 'project wide' means maybe?)
"Plug 'tpope/vim-fugitive'
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
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

call plug#end()

cd ~/Documents/Development

lua << EOF
  require('vgit').setup()
EOF

inoremap jk <ESC>
nmap <C-m> :NERDTreeToggle ~/Documents/Development<CR>
vmap <C-/> <plug>NERDCommenterToggle
nmap <C-/> <plug>NERDCommenterToggle

" Open nerd tree on start
autocmd VimEnter * NERDTree


" open NERDTree automatically
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * NERDTree

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

set relativenumber

set smarttab
set cindent
set tabstop=2
set shiftwidth=2
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
"autocmd BufEnter * call SyncTree()
autocmd BufRead * call SyncTree()

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
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

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
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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

" Add name of file to bottom of every window
set statusline+=%t

" Minimize all windows in current tabs
nmap <C-,> :NERDTreeClose<CR><bar><C-w>_<bar><C-w>\|
" Open and auto size all windows in current tab
nmap <C-.> :NERDTree<CR><bar><C-w>=<bar>:wincmd p<CR>

" Allow ctrl+[hjkl] to move between windows even when the cursor is captured
" by a terminal
"tnoremap <C-h> <C-\><C-n><C-w>h
"tnoremap <C-j> <C-\><C-n><C-w>j
"tnoremap <C-k> <C-\><C-n><C-w>k
"tnoremap <C-l> <C-\><C-n><C-w>l

" Toggle terminal

nmap <C-'> :ToggleTerm 1 direction=float<CR>
tnoremap <C-'> <C-\><C-n>:ToggleTerm 1<CR>

" I'd rarther use the ToggleTerm plugin for one termainl, and then open other
" terminals in new tabs / windows manually as needed
"nmap <C-`> :ToggleTermToggleAll<CR>
"tnoremap <C-`> <C-\><C-n>:ToggleTermToggleAll<CR>
"
"nmap <C-1> :ToggleTerm 1<CR>
"tnoremap <C-1> <C-\><C-n>:ToggleTerm 1<CR>

"nmap <C-2> :ToggleTerm 2<CR>
"tnoremap <C-2> <C-\><C-n>:ToggleTerm 2<CR>

"nmap <C-3> :ToggleTerm 3<CR>
"tnoremap <C-3> <C-\><C-n>:ToggleTerm 3<CR>

"nmap <C-4> :ToggleTerm 4<CR>
"tnoremap <C-4> <C-\><C-n>:ToggleTerm 4<CR>

"nmap <C-5> :ToggleTerm 5<CR>
"tnoremap <C-5> <C-\><C-n>:ToggleTerm 5<CR>

"nmap <C-6> :ToggleTerm 6<CR>
"tnoremap <C-6> <C-\><C-n>:ToggleTerm 6<CR>

"nmap <C-7> :ToggleTerm 7<CR>
"tnoremap <C-7> <C-\><C-n>:ToggleTerm 7<CR>

"nmap <C-8> :ToggleTerm 8<CR>
"tnoremap <C-8> <C-\><C-n>:ToggleTerm 8<CR>

"nmap <C-9> :ToggleTerm 9<CR>
"tnoremap <C-9> <C-\><C-n>:ToggleTerm 9<CR>
