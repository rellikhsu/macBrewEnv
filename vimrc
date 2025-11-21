syntax on
filetype plugin indent on

autocmd FileType c,cpp setlocal expandtab shiftwidth=4 tabstop=4

set encoding=utf-8
set fileencodings=utf-8
set fileformat=unix

set autoindent
set background=dark
set showmatch
set nomodeline
set nocompatible

if &t_Co < 256
  set t_Co=256
endif

