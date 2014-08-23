runtime! debian.vim

if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif

"语法高亮开启
syntax enable

if has("syntax")
  syntax on
endif

"set mapleader
let mapleader=","

"""""""""""""""""""""""""""""""""""""""""""""
"normal set
"""""""""""""""""""""""""""""""""""""""""""""
"dont use the vi compatible
set nocompatible

"cursorline
"set cursorline

"set the colorscheme
if has("win32")
	set guifont=Courier_New:h10:cANSI
	"set guifontwide=YaHei\ Consolas\ Hybrid:h10
	colorscheme ansi_blows
elseif has("gui_running")
    	colorscheme ansi_blows
    	"set guifont=Droid\Sans\Mono\ 11 
		set guifont=Monospace\ 11
else
	colorscheme peachpuff
endif "has

"Toggle Menu and Toolbar use F2
set guioptions-=m
set guioptions-=T
map <silent> <F2> :if &guioptions =~# 'T'<Bar>
	\set guioptions-=T <Bar>
	\set guioptions-=m <Bar>
    \else <Bar>
	\set guioptions+=T <Bar>
	\set guioptions+=m <Bar>
    \endif<CR>

"encoding
set fileencodings=utf8,cp936,gb18030,big5

"filetype detect
filetype on
filetype plugin on
filetype indent on

autocmd FileType c,cpp set shiftwidth=4 | set expandtab

set number
set showmatch
set ignorecase
set smartcase
set incsearch
set hlsearch
set mouse=a

"设置退格键
set backspace=indent,eol,start

"share the outside clipbord
set clipboard+=unnamed

"no swap file
setlocal noswapfile

"indent 
set tabstop=4
set cindent shiftwidth=4
set autoindent shiftwidth=4
set cindent

"comments
set comments=://

set novisualbell

"折叠
set foldenable
nnoremap<space> @=((foldclosed(line('.'))<0)?'zc':'zo')<CR>

"Platform
function! MySys()
    if has("win32")
      return "windows"
    else
      return "linux"
    endif
endfunction

function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/","")
    "find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
	return
    else
        "find in each tab
        tabfirst
	let tab = 1
	while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
	    if bufwinnr != -1
	        exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
	    endif
	    tabnext
	    let tab = tab + 1
        endwhile
	"not exist, new tab
	exec "tabnew " . a:filename
    endif
endfunction

"Fast edit vimrc
if MySys() == 'linux'
    "Fast reloading of the .vimrc
    map <silent> <leader>ss :source ~/.vimrc<cr>
    "Fast editing of .vimrc
    map <silent> <leader>ee : call SwitchTobuf("~/.vimrc")<cr>
    "When .vimrc is edited, reload it
    autocmd! bufwritepost .vimrc sourc ~/.vimrc
elseif MySys() == 'windows'
    "Set helplang
    set helplang=cn
    "Fast reloading of the _vimrc
    map <silent> <leader>ss :source $VIMHOME/_vimrc<cr>
    "Fast editing of _vimrc
    map <silent> <leader>ee :call SwitchToBuf("$VIMHOME/_vimrc")<cr>
    "When _vimrc is edited, reload it
    autocmd! bufwritepost _vimrc source $VIMHOME/_vimrc
endif

"For windows version
if MySys() == 'windows'
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif
"注意：在windows中也定义一个"HOME"环境变量，然后把_vimrc放在"HOME"环境变量所指向的目录中。如果你打算在windows中使用上面的设定，也需要这样做！


"""""""""""""""""""""""""""""""""""""""""""""
"Tag list (ctags)
""""""""""""""""""""""""""""""""""""""""""""
if MySys() == "windows"
    let Tlist_Ctags_Cmd = 'ctags'
elseif MySys() == "linux"
    let Tlist_Ctags_Cmd = '/usr/bin/ctags'
endif
let Tlist_Use_Right_Window=1 			"让窗口在右边，0表示在左边
let Tlist_File_Fold_Auto_Close=1	    "非当前文件自动折叠函数列表
let Tlist_Show_One_File=0       	 	"让taglist可以同时显示多个文件的列表，如果享有一个就设置为1
let Tlist_Exit_OnlyWindow=1   			"当taglist是最后一个窗口，退出vim
let Tlist_Process_File_Always=0 		"是否一直处理tags。 1处理0 不处理

map <silent> <F9> :TlistToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""
" netrw setting 查看目录
"""""""""""""""""""""""""""""""""""""""""""
let g:netrw_winsize = 30
nmap <silent> <leader>fe :Sexplore!<cr>

""""""""""""""""""""""""""""""""""""""""""
" BufExplorer
""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp = 0 "Do not show default help
let g:bufExplorerShowRelativePath = 1 "show relative paths
let g:bufExplorerSortBy='mru' "sort by most recently used
let g:bufExplorerSplitRight = 0 "Split left
let g:bufExplorerSplitVertical=1 "Split vertically
let g:bufExplorerSplitVertSize = 30 "Split width
let g:bufExplorerUseCurrentWindow = 1 "Open in new window
autocmd BufWinEnter \[Buf\ List\] setl nonumber
nmap <silent> <leader>be :BufExplorerVerticalSplit<cr>

"""""""""""""""""""""""""""""""""""""""""""
"winManager setting
""""""""""""""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = "FileExplorer,BufExplorer"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWinsow<cr>
nmap <silent> <leader>wm :WMToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""
"Lookupfile
""""""""""""""""""""""""""""""""""""""""""
"':let g:LookupFile_TagExpr = '"./filenametags"'
let g:LookupFile_MinPatLength = 2  "输入两个字符开始查找
let g:LookupFile_PreserveLastPattern = 0 "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1  "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1 "回车打开第一个匹配项目
let g:LookupFile_AllowNewFile = 0  "不容许创建不存在的文件
if filereadable("./filenametags")
    let g:LookupFile_TagExpr = '"./filenametags"'
endif

nmap <silent> <leader>lk :LUTags<cr>
nmap <silent> <leader>ll :LUBufs<cr>
nmap <silent> <leader>lw :LUWalk<cr>

"lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
	let &tags = eval(g:LookupFile_TagExpr)
	let newpattern = '\c' . a:pattern
	let tags = taglist(newpattern)
    catch
	echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
	return ""
    finally
	let &tags = _tags
    endtry

    "show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'

""""""""""""""""""""""""""""""""""""""""""""""""""
"mark setting
""""""""""""""""""""""""""""""""""""""""""""""""""
",hl 光标下的单词高亮
",hh 清除高亮
",hh 在非高亮单词下，清除所有高亮
" 你也可以使用virsual模式选中一段文本，然后按”,hl“，会高亮你所选中的文本；或者你可以用”,hr“来输入一个正则表达式，这会高亮所有符合这个正则表达式的文本。
"你可以在高亮文本上使用”,#“或”,*“来上下搜索高亮文本。在使用了”,#“或”,*“后，就可以直接输入”#“或”*“来继续查找该高亮文本，直到你又用”#“或”*“查找了其它文本。

nmap <silent> <leader>hl <Plug>MarkSet
vmap <silent> <leader>hl <Plug>MarkSet
nmap <silent> <leader>hh <Plug>MarkClear
vmap <silent> <leader>hh <Plug>MarkClear
nmap <silent> <leader>hr <Plug>MarkRegex
vmap <silent> <leader>hr <Plug>MarkRegex

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
  set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  endif
  set csverb
endif

nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""''
" quickfix
""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw 10<cr>
nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr> 
"利用,lv快速查找光标下的单词

"tags
":set tags+=./tags
":set tags+=~/ctags
":set tags+=~/.vim/tags
":set tags+=/usr/include/tags

if MySys() == "windows"
	set tags+=tags
	set tags+=D:\tags
elseif MySys() == "linux"
endi


"Omni Completetion
set completeopt=longest,menu
nnoremap <silent> <F1> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>


"omnicppcomplete
set nocp
filetype plugin on
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteScope = 1

" mapping
inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <C-J>      pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K>      pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
inoremap <expr> <C-U>      pumvisible()?"\<C-E>":"\<C-U>" 


 "   如果下拉菜单弹出，回车映射为接受当前所选项目，否则，仍映射为回车；
 "   如果下拉菜单弹出，CTRL-J映射为在下拉菜单中向下翻页。否则映射为CTRL-X CTRL-O；
 "   如果下拉菜单弹出，CTRL-K映射为在下拉菜单中向上翻页，否则仍映射为CTRL-K；
 "   如果下拉菜单弹出，CTRL-U映射为CTRL-E，即停止补全，否则，仍映射为CTRL-U；


 """"""""""""""""""""""""""""""""""""""""""""""""""""
 "supertab
 """""""""""""""""""""""""""""""""""""""""""""""""""
 "let g:SuperTabRetainCompletionType = 1 
 "let g:SuperTabDefaultCompletionType = "<C-P>"  "<C-X><C-O>

"""""""""""""""""""""""""""""""""""""""""""""""""""
"auto complop
""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:AutoComplPop_Behavior = {
"\ 'c': [ {'command' : "\<C-x>\<C-o>",
"\ 'pattern' : ".",
"\ 'repeat' : 0}
"\ ]
"\}

"layout
nnoremap <silent> <F3> :CodeLayout<CR>
nnoremap <silent> <F4> :CodeLayoutClose<CR>


function CodeMode()
	setlocal cindent
	setlocal sm 
	setlocal ai
	setlocal tw=78
	setlocal nospell
endfunction
command -nargs=0 CodeMode call CodeMode()

function CodeLayout()
	silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
	call CodeMode()
	Tlist 
	WManager
endfunction
command -nargs=0 CodeLayout call CodeLayout()

function CodeLayoutClose()
	call CodeMode()
	TlistClose
	WMClose
endfunction
command -nargs=0 CodeLayoutClose call CodeLayoutClose()

"一些括号的自动完成
":inoremap ( ()<ESC>i
":inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
":inoremap < <><ESC>i
":inoremap > <c-r>=ClosePair('>')<CR>


:imap <A-/> <C-X><C-O>
:imap <C-i> <C-X><C-O>

