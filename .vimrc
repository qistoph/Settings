
" Configuration file for vim

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start	" more powerful backspacing

" Now we set some defaults for the editor 
set autoindent		" always set autoindenting on
set textwidth=0		" Don't wrap words by default
set nobackup		" Don't keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more than
			" 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set title
set scrolloff=5		" we want to see beyond the cursor when scrolling
set pastetoggle=<F2>
set wildmenu
set background=dark
set isfname-== " I don't want = in filenames when completing for example file=/var/log/sys<C-x><C-f>

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" We know xterm-debian is a color terminal
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

if &term =~ "xterm-256color"
  set t_Co=256
  colorscheme colorful256
endif

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" Debian uses compressed helpfiles. We must inform vim that the main
" helpfiles is compressed. Other helpfiles are stated in the tags-file.
set helpfile=$VIMRUNTIME/doc/help.txt

if has("autocmd")
 " Enabled file type detection
 " Use the default filetype settings. If you also want to load indent files
 " to automatically do language-dependent indenting add 'indent' as well.
 filetype plugin indent on

 autocmd bufwritepost .vimrc source $MYVIMRC

 " Commenting stuff out
 autocmd FileType vim				let b:comment_leader = '" '
 autocmd FileType c,cpp,java,php	let b:comment_leader = '// '
 autocmd FileType sh,make			let b:comment_leader = '# '
 autocmd FileType php				map <C-B> :!php -l %<CR>
 autocmd FileType php				map <F5> :!php -l %<CR>
 noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
 noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>

 autocmd FileType perl				set foldmethod=syntax
endif " has ("autocmd")

" Some Debian-specific things
augroup filetype
  au BufRead reportbug.*		set ft=mail
  au BufRead reportbug-*		set ft=mail
augroup END

" The following are commented out as they cause vim to behave a lot
" different from regular vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
set hidden      " Allow use of hidden buffers

if version >= 600
	set foldenable
	set foldmethod=marker
endif

set makeprg=gcc\ -Wall\ -o\ %<\ %
map <F4>  :make<CR>
map <F5>  :!./%<CR>
map <F10> :set list!<bar>set list?<CR>
map <F11> :set wrap!<bar>set wrap?<CR>
map <F12> :set number!<bar>set number?<CR>
nmap <C-up> <C-y>
imap <C-up> <C-o><C-y>
nmap <C-down> <C-e>
imap <C-down> <C-o><C-e>

set tabstop=4
set shiftwidth=4
set smartcase

let perl_fold = 1
let perl_extended_vars = 1

" Auto change spaces to tabs
"set softtabstop=4

" Auto change tabs to spaces
"set expandtab

map <F4> :TlistToggle<cr>

"Map Ctrl-Tab, C-shift-tab, Ctrl-T to NextTab, PrevTab, NewTab
"map <C-Tab> :tabn<CR>
"imap <C-Tab> <C-O>:tabn<CR>

"map <C-S-Tab> :tabp<CR>
"imap <C-S-Tab> <C-O>:tabp<CR>

"map <C-T> :tabnew<CR>
"imap <C-T> <C-O>:tabnew<CR>

"if has('persistent_undo')
	"set undofile
	"set undolevels=1000
	"set undoreload=10000
"endif

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
command! -complete=file -nargs=* Git call s:RunShellCommand('git '.<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

execute pathogen#infect()
