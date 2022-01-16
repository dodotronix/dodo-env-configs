"------------------------------------------------------------------------------"
" Neovim configuration
" dodotronix | CERN | 2019-10-23 Wed 23:19 PM

" Notes:
"   * if you want to view all keybindings write :help index
"------------------------------------------------------------------------------"

" Search down in subfolders
set path+=**

" Plugin install and update {{{ 
  call plug#begin('~/.config/nvim/plugged')
    Plug 'ayu-theme/ayu-vim' 
    Plug 'vimwiki/vimwiki'
    Plug 'morhetz/gruvbox'
    Plug 'https://github.com/vim-airline/vim-airline.git'
    Plug 'https://github.com/neomake/neomake.git'
    Plug 'https://github.com/jiangmiao/auto-pairs.git'
    Plug 'https://github.com/scrooloose/nerdcommenter.git'
    Plug 'https://github.com/godlygeek/tabular.git'
    Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
    Plug 'majutsushi/tagbar'
    Plug 'jacoborus/tender.vim'
    Plug 'junegunn/fzf'
    Plug 'https://github.com/vifm/vifm.vim.git'
    Plug 'https://github.com/freitass/todo.txt-vim.git'
  call plug#end()
"}}}

if &term =~ '256color'
    set t_ut=
endif

" Color Scheme {{{
" https://github.com/morhetz/gruvbox
    set termguicolors
    colorscheme gruvbox 
    set background=dark    " Setting dark mode
    let g:gruvbox_termcolors = 256
    let g:gruvbox_contrast_dark = 'hard'
    let g:gruvbox_invert_selection=0
"}}}

" User sets {{{
    set nobackup
    set nowritebackup
    set backupdir^=$TEMP
    set shiftwidth=2 "shift size in number of spaces

    set undofile " keep an undo file (undo changes after closing)
    set ruler " show the cursor position all the time
    set showcmd " display incomplete commands
    set number " dislpay line numbers

    set mouse=r
    set colorcolumn=81
    set nowrap

    " Required for operations modifying multiple buffers like rename.
    set hidden
    set inccommand=split
    set runtimepath^=~/.config/nvim/plugged/ctrlp.vim

    " Spaces & Tabs
    set tabstop=2 "number of visual spaces per TAB
    set softtabstop=2 "number of spaces in tab when editing
    set shiftwidth=2 "number of spaces to use for autoindent
    set expandtab "tabs are space
    set autoindent
    set copyindent " copy indent from the previous line

    " Switch syntax highlighting on
    syntax on

    " Enable file type detection.
    filetype plugin indent on 

    set encoding=utf-8
    set clipboard=unnamedplus
"}}} User sets
"

" Quick write session with F2
map <F2> :mksession! ~/vim_session <cr> 
" And load session with F3
map <F3> :source ~/vim_session <cr>     

"{{{ basic remapping
    "get from insertmode with "jk"
    inoremap jk <ESC> 
    let mapleader = " "
"}}}


" Don't use Ex mode, use Q for formatting
noremap Q gq
nnoremap <esc> :noh<return><esc>
nnoremap <leader>. :CtrlPTag<cr>

" " Copy to clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy

" put selected text to search
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" replace all variable occurencies with ne word
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" clear markers of the finded chars
"map <C-n> :NERDTreeToggle<CR>
"map <F8> :TagbarToggle<CR>

" date stamp
nmap <C-s> i<C-R>=strftime("%Y-%m-%d %a %H:%M %p")<CR><Esc>
imap <C-s> <C-R>=strftime("%Y-%m-%d %a %H:%M %p")<CR>

" for advanced testing
"imap <C-a> ;bwh <C-O>mzwhile [ $$$ ]; do<CR>  $$$<CR>done<CR><C-O>'z;;

"xdc comment apperance
"set ft=xdc
let g:NERDCustomDelimiters = { 'xdc': { 'left': '#','right': '' } }

" Automatically displays all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1
" format of buffer name
let g:airline#extensions#tabline#fnamemod = ':t' 
 let g:airline#extesions#tabline#show_tab_type = 1
"let g:airline#extensions#tabline#tab_nr_type= 2
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'" 
let g:sudo_askpass='/usr/lib/ssh/x11-ssh-askpass'
let g:tex_conceal = ""


"{{{ user mapping
    " move among buffers with CTRL
    map <C-J> :bnext<CR>
    map <C-K> :bprev<CR>

    " compile or execute files 
    map <F5> :! pdflatex "%"<CR><CR>
    map <F6> :! xdg-open "%<.pdf";<CR>
    map <F7> :! sh "%"<CR>
    map <F10> :! python "%"<CR>

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
              \ if line("'\"") >= 1 && line("'\"") <= line("$") |
              \ execute "normal! g`\"" |
              \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ 
                \ | diffthis | wincmd p | diffthis
endif

"" write TAB or complet a word {{{
    "function! Tab_Or_Complete()
        "if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
            "return "\<C-N>"
        "else
            "return "\<Tab>"
        "endif
    "endfunction

    "inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
    "set dictionary="/usr/dict/words"
""}}} 

let g:tagbar_type_vhdl = {
    \ 'ctagstype': 'vhdl',
    \ 'kinds' : [
        \'d:prototypes',
        \'b:package bodies',
        \'e:entities',
        \'a:architectures',
        \'t:types',
        \'p:processes',
        \'f:functions',
        \'r:procedures',
        \'c:constants',
        \'n:commponets',
        \'s:signals',
        \'T:subtypes',
        \'r:records',
        \'C:components',
        \'P:packages',
        \'l:locals'
    \]
\}

" Google Calendar
"let g:calendar_google_calendar = 1
"let g:calendar_google_task = 1
"source $HOME/.cache/calendar.vim/credentials.vim

"vimwiki
let g:vimwiki_list = [{'path': '$HOME/Dropbox/TIN'}]
let g:vimwiki_folding='list'

vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'


"vhdl entity definition
function Vhdl_entity()
    let s:entity_name = getline('.') 
    exec "normal! S"
    let s:code_pattern = "library IEEE;\nuse IEEE.std_logic_1164.all;\nuse ieee.numeric_std.all;\n\n"
                \. "entity " 
                \. s:entity_name 
                \. " is\nport(\n\n);\n end "
                \. s:entity_name
                \. ";\narchitecture behavioral of " 
                \. s:entity_name
                \. " is\nbegin\n\nend architecture;"
    exe "normal! a" . s:code_pattern
endfunction

function Vhdl_port()
    let s:vport_name = expand('<cword>')

    "remove the old input string from the line
    exec "normal! daw"
    let s:flag = matchlist(s:vport_name, "\\_w\\+_\\(o\\|i\\|oi\\|io\\)\\(\\d*\\)")
    
    "type of port (in/out/inout)
    if len(s:flag) > 0 
        if s:flag[1] ==? "io" || s:flag[1] ==? "oi"
            let s:flag[1] = "inout "
        elseif s:flag[1] ==? "i"
            let s:flag[1] = "in "
        elseif s:flag[1] ==? "o"
            let s:flag[1] = "out "
        else
            let s:flag[1] = ""
        endif

        "is the port std_logic or std_logic_vector
        if s:flag[2]
            let s:flag[2] = string(str2nr(s:flag[2]) - 1)
            let s:flag[2] = "std_logic_vector(" . s:flag[2] ." downto 0);"
        else
            let s:flag[2] = "std_logic;"
        endif
        let s:vport_name = s:vport_name ." : " . s:flag[1] . s:flag[2] 
    else 
        let s:vport_name = s:vport_name . " : in std_logic;" 
    endif
    exe "normal! a" . s:vport_name ."\n" 
endfunction

function Vhdl_signal(updown)
let s:signal_name = getline('.') 
exec "normal! S"

"check if the data are either with or without initial value
let s:user_signal_custom = matchlist(s:signal_name, "\\(\\_w\\+\\)\\s\\+\\([a-zA-Z_]\\+\\).*") 
let s:user_vsignal = matchlist(s:signal_name, "\\(\\_w\\+\\)\\s\\+\\(\\d\\+\\)") 
let s:user_lsignal = matchlist(s:signal_name, "\\(\\_w\\+\\).*") 
let s:user_signal_with_init = matchlist(s:signal_name, "\\(\\_w\\+\\)\\s\\+\\(\\d\\+\\)\\s*\=\\s*\\(.*\\)") 
let s:signal = "signal "

if !empty(s:user_signal_custom)
    let s:signal = s:signal . s:user_signal_custom[1] . ": " . s:user_signal_custom[2]
elseif !empty(s:user_vsignal)
    let s:signal = s:signal . s:user_vsignal[1] . ": " . "std_logic_vector"  
    let s:user_vsignal[2] = string(str2nr(s:user_vsignal[2]) - 1)

    if a:updown ==? "up" 
        let s:signal = s:signal . "(0 to " . s:user_vsignal[2] . ")"  
    elseif a:updown ==? "down"
        let s:signal = s:signal . "(" . s:user_vsignal[2] . " downto 0)" 
    endif
elseif !empty(s:user_lsignal)
    let s:signal = s:signal . s:user_lsignal[1] . ": " . "std_logic"
endif

let s:ending = ";"
if !empty(s:user_signal_with_init)
    let s:ending = " := " . s:user_signal_with_init[3] . ";"
endif
let s:signal = s:signal . s:ending
exe "normal! a" . s:signal
endfunction

function Vhdl_process()
    let s:process_name = getline('.') 
    exe "normal! S"
    if s:process_name != ""
        let s:process_first_name = s:process_name . ": " 
    endif
    let s:code_pattern = s:process_first_name 
                \. "process() begin\n end process "
                \. s:process_name
                \. ";\n"
    exe "normal! a" . s:code_pattern
endfunction

"result of this function is in clipboard
function Vhdl_component()
    let s:whole_entity = join(getline(1, line('$')), "\n")
    let s:entity_name = []
    let s:entity_end = []
    let s:entity_port = ""

    let s:entity_name = matchlist(s:whole_entity, "entity\\_s\\+\\(\\_w\\+\\)"
                                                  \."\\_s\\+is.*")

    let s:entity_generic = matchlist(s:whole_entity, ".*\\(generic\\_s*(.*);\\)"
                                                  \. "\\_s*port\\_s*(.*")
    
    let s:entity_port = matchlist(s:whole_entity, ".*\\(port\\_s*(.*);\\)\\_s*"
                                                  \. "end\\_s\\+.*"
                                                  \. s:entity_name[1] . ";.*")
    let s:generic = ""
    if !empty(s:entity_generic)
      let s:generic = s:entity_generic[1] . "\n"
    endif

    let s:component = "component " 
                      \. s:entity_name[1] 
                      \. "\n" 
                      \. s:generic
                      \. s:entity_port[1] ."\n" 
                      \. "end component;\n"
    let @+ = s:component
endfunction

function Vhdl_portmap()
    let s:input_data = split(@+, "\n")
    let s:portmap_id = getline('.') 
    let s:portmap_name = matchlist(s:input_data, "\\c^\\s*component\\_s\\+\\(\\w\\+\\).*")
    
    exe "normal! S"

    " TODO match port and generic part and then iterate through each of them

    let s:portmap = s:portmap_id . ": " . s:portmap_name[1] . "\nport map(" 

    for i in s:input_data[1:len(s:input_data)-1]

        let s:port_vmap = matchlist(i, "\\c^\\s*\\(port(\\|\\s*\\)\\s*\\([a-zA-Z0-9_]\\+\\)"
                                    \."\\s*:\\s*\\_a\\+\\s\\+"
                                    \."std_logic_vector\\+"
                                    \."\\(([a-zA-Z0-9 ]\\+)\\).*") 

        let s:port_lmap = matchlist(i, "\\c^\\s*\\(port(\\|\\s*\\)\\s*\\([a-zA-Z0-9_]\\+\\)"
                                    \."\\s*:\\s*\\(\\_a\\+\\)"
                                    \."\\s\\+std_logic\\s*.*") 

        if !empty(s:port_vmap)
          let s:portmap = s:portmap . s:port_vmap[2] . s:port_vmap[3] 
                                   \. " => " . "_" . s:port_vmap[2] . ",\n" 
        elseif !empty(s:port_lmap)
          let s:portmap = s:portmap . s:port_lmap[2] . " => " 
                                   \. "_" . s:port_lmap[2] . ",\n"  
        endif
    endfor

    " have to subtract the last comma before closing the brackets (len-3) 
    exe "normal! a" . s:portmap[0:len(s:portmap)-3] . ");\n"
endfunction

function Signal_from_portmap()
    let s:lines = getline(getpos("'<")[1], getpos("'>")[1])
    let s:output_block = ""
    for i in s:lines
        let s:pattern_logic = matchlist(i, "^[\s\nport map(]*\\s*" 
                                         \."[a-zA-z0-9_]\\+"
                                         \."\\s*=>\\s*"
                                         \."\\([a-zA-z0-9_]\\+\\).*")

        let s:pattern_vector = matchlist(i, "^[\s\nport map(]*\\s*"
                                         \."[a-zA-z0-9_]\\+"
                                         \."\\(([a-zA-Z0-9 ]\\+)\\)"
                                         \."\\a*\\s*=>\\s*"
                                         \."\\([a-zA-z0-9_]\\+\\).*")

        if !empty(s:pattern_vector)
            let s:output_block = s:output_block . "signal " 
                        \. s:pattern_vector[2] . ": " . "std_logic_vector" 
                        \. s:pattern_vector[1] . ";\n"
        elseif !empty(s:pattern_logic)
            let s:output_block = s:output_block . "signal " 
                              \. s:pattern_logic[1] . ": " . "std_logic;\n"
        endif
    endfor
    let @+ = s:output_block
endfunction

function Clock_generator_tb()
    let s:line = getline('.')
    exe "normal! S"
    let s:matched = matchlist(s:line, "^\\([a-zA-Z0-9_]\\+\\)\\s\\+\\([0-9]*.*\\)")
    let s:period = "constant PERIOD: time := " . s:matched[2] . ";\n"
    let s:clock = s:matched[1] . " <= not " . s:matched[1] . " after PERIOD/2;\n"
    exe "normal! a" . s:period . s:clock
endfunction

" call the function 
noremap mme :call Vhdl_entity()<CR> 
noremap mmp :call Vhdl_port()<CR> 
noremap mmu :call Vhdl_signal("up")<CR> 
noremap mmd :call Vhdl_signal("down")<CR> 
noremap mss :call Vhdl_process()<CR>
noremap mcm :call Vhdl_component()<CR>
noremap mpm :call Vhdl_portmap()<CR>
noremap mnm :call Signal_from_portmap()<CR>
noremap mmc :call Clock_generator_tb()<CR> 

inoremap m, <C-R>\ <= 
inoremap ,m <C-R>\ => 
