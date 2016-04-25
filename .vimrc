"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins management
"	 :PluginInstall to automatically grab & install everything
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'                      " plugin manager
Plugin 'tomasr/molokai'                         " molokai colorscheme
Plugin 'tpope/vim-fugitive'                     " TODO
Plugin 'scrooloose/nerdtree'                    " tree explorer
Plugin 'scrooloose/nerdcommenter'               " commenting
Plugin 'SirVer/ultisnips'                       " snippets
Plugin 'honza/vim-snippets'                     " ultisnips dependency
Plugin 'Valloric/YouCompleteMe'                 " code-completion engine
Plugin 'scrooloose/syntastic'                   " syntax checking
Plugin 'sukima/xmledit'                         " fVim
Plugin 'jelera/vim-javascript-syntax'           " Enhanced JavaScript syntax
Plugin 'vim-scripts/JavaScript-Indent'          " javascript improved indentation
Plugin 'bling/vim-airline'                      " status/tabline
Plugin 'nathanaelkane/vim-indent-guides'        " visually display indent levels in code
Plugin 'elzr/vim-json'                          " better JSON highlighting
Plugin 'mxw/vim-jsx'                            " React.js syntax highlighting
Plugin 'kien/ctrlp.vim'                         " Fuzzy file, buffer, mru, tag etc finder
Plugin 'vim-scripts/DirDiff.vim'                " Recursive diff on directories
Plugin 'flazz/vim-colorschemes'                 " Choose from a variety of colorschemes
"Plugin 'octol/vim-cpp-enhanced-highlight'       " Better C/C++ highlighting
Plugin 'mkarmona/colorsbox'
Plugin 'jeaye/color_coded'
Plugin 'qpkorr/vim-bufkill'                     " Kill buffer with :BD without closing the window
Plugin 'maksimr/vim-jsbeautify'                 " Javascript prettifier
Plugin 'vim-scripts/AnsiEsc.vim'                " Interpret bash ansi characters

call vundle#end()

filetype plugin indent on

let g:color_coded_enabled = 1
let g:color_coded_filetypes = ['c', 'cpp', 'objc']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set fileformat=unix
set fileencoding=utf-8

" syntax highlighting
"
syntax on

" Use the system clipboard instead of vim's internal clipboard
" Makes it easier to c/p to other applications

set clipboard=unnamedplus

" Disable matchparen so syntax hl won't lag! (Especially for HTML with JS
" inside)

let loaded_matchparen = 1

" Disable color_coded in diff mode
if &diff
"  let g:color_coded_enabled = 0
endif

" Color theme

set t_Co=256
let g:solarized_termcolors=256
colorscheme awe
"colorscheme twilighted
"colorscheme monokai-chris
"awe

set guifont=Monospace\ 8

" Highlight the screen line of the cursor

set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40

" Automatically remove trailing whitespaces on save

if has("autocmd")
	autocmd BufWritePre * :%s/\s\+$//e
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
" set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

map <F3> 	:FufFile<CR>
map <F4> 	:NERDTree<CR>

set showcmd			" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden      	" Hide buffers when they are abandoned
set mouse=a			" Enable mouse usage (all modes)

set number
" set expandtab
set tabstop=4
set shiftwidth=4

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Snippets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:UltiSnipsExpandTrigger       = "<c-k>"
let g:UltiSnipsJumpForwardTrigger  = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-p>" " TODO doesn't work!
let g:UltiSnipsListSnippets        = "<c-l>"
let g:UltiSnipsEditSplit           = "vertical"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
:set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indent-guides - visually displaying indent levels in code
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" type \ig to enable/disable
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=235

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctrlp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-jsx - reactjs syntax highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:jsx_ext_required = 0 " Allow JSX in normal JS files

set tags+=~/.vim/tags/cpp
set tags+=./tags;,./TAGS;,tags,TAGS

" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q.<CR>

" OmniCppComplete
"let OmniCpp_NamespaceSearch = 1
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
"let OmniCpp_MayCompleteDot = 1 " autocomplete after .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
"let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
"au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menuone,menu,longest,preview

" Latex plugin
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" Continuation lines for C indenting

set noet sts=0 sw=4 ts=4
set cindent
set cinoptions=(0,u0,U0

" ctab
" let g:ctab_filetype_maps

" Assign F9 to make
:map <f9> :make

"if has("cscope")
"set csprg=/usr/bin/cscope
"set csto=0
"set cst
"set nocsverb
"" add any database in current directory
"if filereadable("cscope.out")
"cs add cscope.out
"" else add database pointed to by environment
"elseif $CSCOPE_DB != ""
"cs add $CSCOPE_DB
"endif
"set csverb
"endif
"
"nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" Using 'CTRL-spacebar' then a search type makes the vim window
" split horizontally, with search result displayed in
" the new window.

"nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

" Hitting CTRL-space *twice* before the search type does a vertical
" split instead of a horizontal one

"nmap <C-Space><C-Space>s
"\:vert scs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>g
"\:vert scs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>c
"\:vert scs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>t
"\:vert scs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>e
"\:vert scs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>i
"\:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-Space><C-Space>d
"\:vert scs find d <C-R>=expand("<cword>")<CR><CR>

" CCTree configuration

"let g:CCTreeMinVisibleDepth = 1
"let g:CCTreeKeyTraceForwardTree = '<C-\>>'
"let g:CCTreeKeyTraceReverseTree = '<C-\><'
"let g:CCTreeKeyHilightTree = '<C-l>'        " Static highlighting
"let g:CCTreeKeySaveWindow = '<C-\>y'
"let g:CCTreeKeyToggleWindow = '<C-\>w'
"let g:CCTreeKeyCompressTree = 'zs'     " Compress call-tree
"let g:CCTreeKeyDepthPlus = '<C-\>='
"let g:CCTreeKeyDepthMinus = '<C-\>-'
"let g:CCTreeUseUTF8Symbols = 1

function! DoPrettyXML()
	let l:origft = &ft
	set ft=
	" delete the xml header if it exists. This will
	" permit us to surround the document with fake tags
	" without creating invalid xml.
	1s/<?xml .*?>//e
	" insert fake tags around the entire document.
	" This will permit us to pretty-format excerpts of
	" XML that may contain multiple top-level elements.
	0put ='<PrettyXML>'
	$put ='</PrettyXML>'
	silent %!xmllint --format -
	" xmllint will insert an <?xml?> header. it's easy enough to delete
	" if you don't want it.
	" delete the fake tags
	2d
	$d
	" restore the 'normal' indentation, which is one extra level
	" too deep due to the extra tags we wrapped around the document.
	silent %<
	" back to home
	1
	" restore the filetype
	exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

command -range=% PrettyJS :call JsBeautify()<cr>
command -range=% PrettyJSON %!python -mjson.tool

"map :session_save :mksession! ~/.vim_session <cr> " Quick write session with F2
"map :session_load :source ~/.vim_session <cr>     " And load session with F3
"
"au FileType javascript call JavaScriptFold()

" visual indicator to keep lines short
"if exists('+colorcolumn')
" highlight the 80th column (only in 7.3+)
"set colorcolumn=80
"else
" highlight any text that goes over 80 characters
"  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
"endif

" Open splits below / right
set splitbelow
set splitright

" Turn off auto-commenting (i.e. type a comment, press return, the new line is
" no longer automatically commented)
autocmd FileType * setlocal formatoptions-=ro

" NERDTree
map <C-n> :NERDTreeToggle <CR>
let NERDTreeHijackNetrw=1 " Use instead of Netrw when doing an edit /foobar
let NERDTreeMouseMode=1 " Single click for everything
" Open NERDTree by default if no files are specified
autocmd StdinReadPre * let s:std_in=1
function! StartNERDTree()
	if argc() == 0 && !exists("s:std_in")
		execute ":NERDTree"
		wincmd p
	endif
endfunction
autocmd VimEnter * :call StartNERDTree()
" Close vim if NERDTree is the only window left open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

set nobackup
set nowritebackup

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
	let l:currentBufNum = bufnr("%")
	let l:alternateBufNum = bufnr("#")

	if buflisted(l:alternateBufNum)
		buffer #
	else
		bnext
	endif

	if bufnr("%") == l:currentBufNum
		new
	endif

	if buflisted(l:currentBufNum)
		execute("bdelete! ".l:currentBufNum)
	endif
endfunction
