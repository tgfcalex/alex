﻿if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=m
     set t_Sf=m
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"
set paste
set laststatus=2
"set statusline=%<%f%m\ \[%{&ff}:%{&fenc}:%Y]\ %{getcwd()}\ \ \[%{strftime('%Y/%b/%d\ %a\ %I:%M\ %p')}\]\ %=\ Line:%l\/%L\ Column:%c%V\ %P
"set statusline=file:\ %t\ [type:\ %Y]\ format:\ %{&ff}\ %=[%c,\ %l:%L]
set statusline=
set statusline+=%1*\[%n]                                  "buffernr
set statusline+=%2*\ %<%F\                                "文件路径
set statusline+=%3*\ %y\                                  "文件类型
set statusline+=%4*\ %{''.(&fenc!=''?&fenc:&enc).''}      "编码1
set statusline+=%4*\ %{(&bomb?\",BOM\":\"\")}\            "编码2
set statusline+=%5*\ %{&ff}\                              "文件系统(dos/unix..)
set statusline+=%6*\ %{&spelllang}"\                      "语言
set statusline+=%6*\ %01(%{&hls?'H':''}%)\                "是否高亮，H表示高亮 
set statusline+=%5*\ %=\                                  "空行
set statusline+=%7*\ %=row:%l/%L\ (%03p%%)\               "光标所在行号/总行数 (百分比)
set statusline+=%8*\ col:%03c\                            "光标所在列
set statusline+=%9*\ %m%r%w\                              "Modified? Read only?
set statusline+=%#User10#\ %P\                            "Top/bottom

hi User1 ctermfg=darkred  ctermbg=white  cterm=bold
hi User2 ctermfg=white  ctermbg=red
hi User3 ctermfg=blue  ctermbg=black
hi User4 ctermfg=white  ctermbg=green
hi User5 ctermfg=cyan  ctermbg=black
hi User6 ctermfg=darkred  ctermbg=yellow
hi User7 ctermfg=white  ctermbg=darkgreen
hi User8 ctermfg=blue  ctermbg=black
hi User9 ctermfg=white  ctermbg=red
hi User10 ctermfg=darkgreen ctermbg=white
