packadd! onedark.vim

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
  " set termguicolors noshowmode
	colorscheme onedark
	" autocmd VimEnter * AirlineTheme
endif

