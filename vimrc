call plug#begin('~/.vim/plugged')
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'vim-scripts/indentpython.vim'
" Plug 'scrooloose/syntastic'
Plug 'altercation/vim-colors-solarized'
Plug 'jnurmine/Zenburn'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
Plug 'tmhedberg/SimpylFold'
Plug 'nvie/vim-flake8'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar'
" Plug 'Chiel92/vim-autoformat'
Plug 'sbdchd/neoformat'
"Plug 'w0rp/ale'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'rking/ag.vim'
Plug 'junegunn/vim-easy-align'
Plug 'ryanoasis/vim-devicons'

" theme
Plug 'w0ng/vim-hybrid'
Plug 'sjl/badwolf'
Plug 'jpo/vim-railscasts-theme'
Plug 'arcticicestudio/nord-vim'
Plug 'joshdick/onedark.vim'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'zchee/deoplete-jedi'
"Plug 'Shougo/deoplete-clangx'
call plug#end()

" leaderF
let g:Lf_ShortcutF = '<c-p>'
noremap <Leader>p :LeaderfFunction<cr>

" python
let g:python3_host_skip_check=1
let g:python3_host_prog='/usr/local/bin/python3'


" global
let mapleader=','
let python_highlight_all=1
set noshowmode
set ts=4
"set expandtab
set autoindent
set noundofile
set rnu
set nu
set mouse=a
set updatetime=100 " 更新时间, 目前用于gitgutter
set shiftwidth=4
" 设置不可见字符样式
set list
set listchars=tab:→\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨

"highlight LineNr cterm=bold ctermfg=white
"highlight pythonFunction cterm=bold ctermfg=blue
"highlight pythonString cterm=bold ctermfg=green 


" 使用 jj  进入 normal 模式
inoremap jj <Esc>`^
" 使用 leader+q 直接退出
inoremap <leader>q <Esc>:q<cr>
noremap <leader>q :q<cr>
" 使用 leader+w 直接保存
inoremap <leader>w <Esc>:w<cr>
noremap <leader>w :w<cr>
" 使用cdc 进入当前文件的目录
cnoremap cdc cd %:h
" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null
" 使用tab键切换tab
nnoremap <tab> gt
nnoremap <S-tab> gT

set encoding=UTF-8
set cursorline
set nobackup
set noswapfile
syntax on
syntax enable
set background=dark
" https://github.com/w0ng/vim-hybrid
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
colorscheme hybrid
filetype on

" 特定格式 文件下使用两个空格
"autocmd BufNewFile,BufRead *.(sh|json|html|yaml) set noexpandtab tabstop=2 shiftwidth=2
autocmd Filetype html setl ts=2 sw=2 expandtab
autocmd Filetype sh setl ts=2 sw=2 expandtab
autocmd Filetype json setl ts=2 sw=2 expandtab
autocmd Filetype yaml setl ts=2 sw=2 expandtab

" fast copy
:map <Leader>c "+y

" window move
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>


" remember last postion
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" multiple cursor 
" 解决deoplete会自动插入<Plug>的bug
function g:Multiple_cursors_before()
	call deoplete#custom#buffer_option('auto_complete', v:false)
endfunction
function g:Multiple_cursors_after()
	call deoplete#custom#buffer_option('auto_complete', v:true)
endfunction

" nerdtree
map <leader>n :NERDTreeToggle<CR>
map <leader>v :NERDTreeFind<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc','\~$','\.swp','\.git']
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }
" NERDTress File highlighting
"function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 "exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 "exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
"endfunction

"call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
"call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
"call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
"call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" lightline
"set laststatus=2
"let g:lightline = {
      "\ 'colorscheme': 'wombat',
      "\ }


" easymotion
let g:EasyMotion_do_mapping = 0

let g:EasyMotion_smartcase = 1
"let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
map <Leader><Leader>f <Plug>(easymotion-overwin-f)
map <Leader><Leader>w <Plug>(easymotion-bd-w)
map <Leader><leader>h <Plug>(easymotion-linebackward)
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><leader>l <Plug>(easymotion-lineforward)
" 重复上一次操作, 类似repeat插件, 很强大
map <Leader><leader>. <Plug>(easymotion-repeat)


" ag
let g:ackprg = 'ag --vimgrep'
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" fzf
nnoremap <silent> <Leader>ag :Ag
nnoremap <silent> <Leader>f :Files<CR>


" folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za
let g:SimpylFold_docstring_preview=1

" indentLine 
" json文件展示双引号
let g:indentLine_setConceal = 0

" airline
let g:airline_theme="bubblegum"
let g:airline_powerline_fonts = 1

" ale
" . /home/mopip77/.vim/ale/plugin/ale.vim
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
map <Leader>s :ALEToggle<CR>
" 只有保存时检查
" let g:ale_lint_on_text_changed = 'never'
" 默认关闭
let g:ale_lint_on_enter = 0
let g:ale_fixers = {
\ 'python': ['add_blank_lines_for_python_control_statements','autopep8','isort','yapf','remove_trailing_lines']
\}


" vim-gitgutter
let g:gitgutter_max_signs = 500  " default value
highlight GitGutterAdd ctermfg=2 
highlight GitGutterChange ctermfg=3 
highlight GitGutterDelete ctermfg=1 

" tagbar
" 打开tagbar后光标自动进入tagbar
let g:tagbar_autofocus = 1
nnoremap <Leader>t :TagbarToggle<CR>

" Neoformat
let g:formatter_yapf_style = 'pep8'
noremap <F3> :Neoformat<CR>:w<CR>

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" deoplete 
set rtp+=${HOME}/.vim/plugged/deoplete.nvim/
let g:deoplete#enable_at_startup = 1
" 使用tab替换候选
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>" 
" Change clang binary path
" call deoplete#custom#var('clangx', 'clang_binary', '/usr/bin/clang')
"
"

" 当新建 .h .c .hpp .cpp .mk .sh等文件时自动调用SetTitle 函数
autocmd BufNewFile *.py exec ":call SetTitle()" 
" 加入注释 
func SetTitle()
call setline(1, "#-*- coding:utf-8 -*-") 
call append(line("."), "\"\"\"") 
call append(line(".")+1, "@file  : ".expand("%:t")) 
call append(line(".")+2, "@author: Mopip77")
call append(line(".")+3, "@mail  : mopip77@qq.com")
call append(line(".")+4, "@time  : ".strftime("%Y-%m-%d %H:%M:%S")) 
call append(line(".")+5, "\"\"\"") 
call append(line(".")+6, "") 
    normal G
endfunc

