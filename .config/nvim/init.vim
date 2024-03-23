let mapleader=" "

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'KabbAmine/zeavim.vim'  ",     {'on': ['Zeavim', 'ZeavimV', 'ZVVisSelection', 'ZVOperator', 'ZVKeyDocset']}
Plug 'neoclide/coc.nvim',        {'on': ['CocList', 'CocConfig'], 'branch': 'release'}
Plug 'ap/vim-css-color'  " color code highlighting
Plug 'xuhdev/vim-latex-live-preview', {'for': 'tex'}
Plug 'machakann/vim-verdin',     {'for': 'vim'}
Plug 'puremourning/vimspector',   {'for': 'python'}
" Plug 'powerman/vim-plugin-AnsiEsc'
" Plug 'junegunn/goyo.vim',        {'on': 'Goyo'}
" Plug 'jreybert/vimagit'
" Plug 'lukesmithxyz/vimling'
" Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline',  {'on': 'AirlineTheme'}
Plug 'vim-airline/vim-airline-themes',   {'on': 'AirlineTheme'}
Plug 'joshdick/onedark.vim'
call plug#end()

let g:Verdin#autocomplete = 1
let g:livepreview_previewer = 'zathura'

set title showmatch nowrap
set mouse=a
set tabstop=2 shiftwidth=0
set number relativenumber
set cursorline cursorcolumn
set cc=80
set scrolloff=5
set splitbelow splitright
set updatetime=500

syntax on
filetype plugin indent on
autocmd FileType text setlocal tabstop=8 shiftwidth=4
autocmd FileType html setlocal tabstop=2 shiftwidth=2
autocmd FileType sql  setlocal commentstring=--\ %s
autocmd BufEnter bm-files,bm-dirs setlocal tabstop=8 shiftwidth=8
autocmd BufWritePost bm-files,bm-dirs silent !shortcuts
autocmd BufWritePost config.h,config.def.h !cd "%:h"; sudo make clean install
autocmd BufWritePre  * %s/\s\+$//e
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

autocmd BufWritePost */Documents/Notes/*.md silent !pandoc % -o "$HOME/Documents/Notes/.out/$(basename % .md).html"
autocmd BufWritePost .Xresources silent !xrdb "%"
autocmd BufRead,BufNewFile *.yt* set filetype=conf

autocmd TermOpen * startinsert
command! -nargs=* T  split  | terminal <args>

" --> Scratch buffer
if exists('g:loaded_scratch')
  finish
endif
let g:loaded_scratch = 1
command! -nargs=1 -complete=command D call scratch#open(<q-args>, <q-mods>)

" --> Zeal docs
let g:zv_disable_mapping = 1
nmap <leader>z <Plug>Zeavim
vmap <leader>z <Plug>ZVVisSelection
nmap gz <Plug>ZVOperator
nmap <leader><leader>z <Plug>ZVKeyDocset

" --> COC
autocmd! User coc.nvim source $HOME/.config/nvim/coc/coc-onload.vim
let g:coc_config_home = '$HOME/.config/nvim/coc'
let g:coc_data_home = '$HOME/.local/share/nvim/site/coc'
let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-marketplace',
            \ 'coc-css',
            \ 'coc-tsserver',
            \ 'coc-pyright',
            \ 'coc-java',
            \ 'coc-sh',
            \ ]
nnoremap <silent><nowait> <leader>ca  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader>ce  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <leader>cc  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <leader>co  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>cs  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <leader>cj  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <leader>ck  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <leader>cp  :<C-u>CocListResume<CR>
nnoremap <leader>cm :CocList marketplace<CR>

" --> Vimspector
let g:vimspector_base_dir = expand('$HOME/.local/share/nvim/vimspector')
let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <leader>dc  <Plug>VimspectorContinue
nnoremap <leader>ds  <Plug>VimspectorStop
nnoremap <leader>dr  <Plug>VimspectorRestart
nnoremap <leader>dp  <Plug>VimspectorPause
nnoremap <leader>dl  <Plug>VimspectorBreakpoints
nnoremap <leader>dd  <Plug>VimspectorToggleBreakpoint
nnoremap <leader>db  <Plug>VimspectorToggleConditionalBreakpoint
nnoremap <leader>df  <Plug>VimspectorAddFunctionBreakpoint
nnoremap <leader>dg  <Plug>VimspectorGoToCurrentLine
nnoremap <leader>dx  :call vimspector#ClearBreakpoints()<CR>
nnoremap <leader>dq  :VimspectorReset<CR>
nnoremap <A-C>       <Plug>VimspectorContinue
nnoremap <A-n>       <Plug>VimspectorStepOver
nnoremap <A-i>       <Plug>VimspectorStepInto
nnoremap <A-o>       <Plug>VimspectorStepOut
nnoremap <A-b>       <Plug>VimspectorToggleBreakpoint
nnoremap <A-c>       <Plug>VimspectorRunToCursor

" --> Lf
" let g:lf_command_override = 'lf -command ...'
let g:NERDTreeHijackNetrw = 0
" let g:lf_replace_netrw = 1
let g:lf_width = 1.0
let g:lf_height = 1.0
let g:lf_map_keys = 0
nnoremap <Esc>o     :LfCurrentFile<CR>
nnoremap <Esc>l     :LfWorkingDirectory<CR>
nnoremap <leader>o  :LfCurrentFileNewTab<CR>
nnoremap <leader>l  :LfWorkingDirectoryExistingOrNewTab<CR>

" --> onedark theme
if exists('+termguicolors')
	let g:airline_theme = 'onedark'
	let g:onedark_terminal_italics = 1
	let g:onedark_color_overrides = {
      \ "foreground": { "gui": "#BBC2CF", "cterm": "145", "cterm16": "NONE" },
      \ "background": { "gui": "#181C24", "cterm": "235", "cterm16": "NONE" },
      \ "comment_grey": { "gui": "#6C7380", "cterm": "59", "cterm16": "7" },
      \ "gutter_fg_grey": { "gui": "#6272A4", "cterm": "238", "cterm16": "8" },
      \ "special_grey": { "gui": "#5Ba078", "cterm": "238", "cterm16": "7" },
			\ }
      " \ "background": { "gui": "#202426", "cterm": "235", "cterm16": "NONE" },
			"
      " \ "red": { "gui": "#E06C75", "cterm": "204", "cterm16": "1" },
      " \ "dark_red": { "gui": "#BE5046", "cterm": "196", "cterm16": "9" },
      " \ "green": { "gui": "#98C379", "cterm": "114", "cterm16": "2" },
      " \ "yellow": { "gui": "#E5C07B", "cterm": "180", "cterm16": "3" },
      " \ "dark_yellow": { "gui": "#D19A66", "cterm": "173", "cterm16": "11" },
      " \ "blue": { "gui": "#61AFEF", "cterm": "39", "cterm16": "4" },
      " \ "purple": { "gui": "#C678DD", "cterm": "170", "cterm16": "5" },
      " \ "cyan": { "gui": "#56B6C2", "cterm": "38", "cterm16": "6" },
      " \ "black": { "gui": "#282C34", "cterm": "235", "cterm16": "0" },
      " \ "white": { "gui": "#ABB2BF", "cterm": "145", "cterm16": "15" },
      " \ "cursor_grey": { "gui": "#2C323C", "cterm": "236", "cterm16": "0" },
      " \ "visual_grey": { "gui": "#3E4452", "cterm": "237", "cterm16": "8" },
      " \ "menu_grey": { "gui": "#3E4452", "cterm": "237", "cterm16": "7" },
      " \ "vertsplit": { "gui": "#3E4452", "cterm": "59", "cterm16": "7" },

	" autocmd ColorScheme * call onedark#extend_highlight("LineNr", {
	" 			\ "fg": { "gui": "#6272A4", "cterm": "238", "cterm16": "8" },
	" 			\ })
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors noshowmode
	colorscheme onedark
	autocmd VimEnter * AirlineTheme
endif

if !exists('g:lasttab')
  let g:lasttab = 1
endif
nmap g; :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
nnoremap g1 1gt
nnoremap g2 2gt
nnoremap g3 3gt
nnoremap g4 4gt
nnoremap g5 5gt
nnoremap g6 6gt
nnoremap g7 7gt
nnoremap g8 8gt
nnoremap g9 :tablast<CR>

vnoremap <C-c> "*y :let @+=@*<CR>
vnoremap <C-A-c> "*d :let @+=@*<CR>
noremap <C-p> "+p
noremap <C-A-p> "+P

nnoremap c "_c
inoremap jk <Esc>
" map ;n /<++><Enter>c4l
imap ;n <Esc>/<++><Enter>c4l

autocmd FileType html,markdown inoremap ;s ><Esc>bi<<Esc>ea
autocmd FileType html,markdown inoremap ;c ><Esc>bi</<Esc>ea
autocmd FileType html,markdown inoremap ;i <Esc>b"tywi<<Esc>ea><++></><CR><++><Esc>k$P2F>i
autocmd FileType html,markdown inoremap ;l <Esc>b"tywi<<Esc>ea></><CR><++><Esc>k$PF<i
autocmd FileType html,markdown inoremap ;b <Esc>b"tywi<<Esc>ea><CR><++><CR></><CR><++><Esc>k$P2k$i
autocmd FileType html,markdown inoremap ;ap <p><CR><++><CR></p><CR><++><Esc>3k$i
autocmd FileType html,markdown inoremap ;aa <a href=""><CR><++><CR></a><CR><++><Esc>3k$hi

nnoremap <leader>fl :w<CR>:!dev lint "%"<CR>
nnoremap <leader>fm :w<CR>:!dev format "%"<CR>
nnoremap <leader>fc :w<CR>:!dev compile "%"<CR>
nnoremap <leader>fr :w<CR>:!dev run "%"<CR>
nnoremap <leader>ft :w<CR>:!dev test "%"<CR>

autocmd BufEnter * nmap <leader>t :w<CR>:se nornu<CR>:!dev test "%"<CR>:se rnu<CR>
autocmd BufEnter * nmap <leader>T :w<CR>:se nornu<CR>:T dev test "%"<CR>
autocmd BufEnter * imap <F5> <Esc>:w<CR>:se nornu<CR>:T dev test "%"<CR>

nnoremap <leader>w :set wrap!<CR>
nnoremap <leader>p :!opout "%:p"<CR>
nnoremap <leader>F :Goyo<CR>
nnoremap <leader>O :T mimeopen --ask %<CR>
nnoremap <leader>ec :tabnew ~/.config/nvim/init.vim<CR>
nnoremap <leader><C-r> :source ~/.config/nvim/init.vim<CR>
nnoremap <leader>s :%s//gc<Left><Left><Left>
nnoremap <leader>r :w<CR>:!%:p<CR>
nnoremap <leader>R :w<CR>:T %:p<CR>

nnoremap <leader>gc :T git add --all && git commit<CR>

source ~/.config/nvim/shortcuts.vim
