" ipython.vim: interact with ipython
" Author: Eric Xihui Lin
" Date: July 5, 2014
" Location: McDonald's@Toronto

au filetype python nmap <LocalLeader>l <Esc>V<C-c><C-c>'<
au filetype python vmap <LocalLeader>l <C-c><C-c>'>
au filetype python nmap <LocalLeader>pp vip<C-c><C-c>}
au filetype python nmap <LocalLeader>p vip<C-c><C-c>}

" au filetype python nmap <LocalLeader>l <Esc>V"+y:call Send_to_Tmux("%paste\n")<CR>
" au filetype python vmap <LocalLeader>l "+y:call Send_to_Tmux("%paste\n")<CR>'>
" au filetype python nmap <LocalLeader>pp vip"+y:call Send_to_Tmux("%paste\n")<CR>'>

" check class
au filetype python vmap <LocalLeader>cc "ry:call Send_to_Tmux(@r . ".__class__\n")<CR>
au filetype python nmap <LocalLeader>cc viw"ry:call Send_to_Tmux(@r . ".__class__\n")<CR>

" data insight, mainly for pandas.DataFrame
au filetype python vmap <LocalLeader>ds "ry:call Send_to_Tmux(@r . ".shape\n")<CR>
au filetype python vmap <LocalLeader>dh "ry:call Send_to_Tmux(@r . ".head()\n")<CR>
au filetype python vmap <LocalLeader>dt "ry:call Send_to_Tmux(@r . ".tail()\n")<CR>
au filetype python vmap <LocalLeader>dd "ry:call Send_to_Tmux(@r . ".describe()\n")<CR>
au filetype python vmap <LocalLeader>dc "ry:call Send_to_Tmux(@r . ".columns\n")<CR>
au filetype python vmap <LocalLeader>dr "ry:call Send_to_Tmux(@r . ".index\n")<CR>
au filetype python vmap <LocalLeader>dm "ry:call Send_to_Tmux(@r . ".mean()\n")<CR>
au filetype python nmap <LocalLeader>ds viw"ry:call Send_to_Tmux(@r . ".shape\n")<CR>
au filetype python nmap <LocalLeader>dh viw"ry:call Send_to_Tmux(@r . ".head()\n")<CR>
au filetype python nmap <LocalLeader>dt viw"ry:call Send_to_Tmux(@r . ".tail()\n")<CR>
au filetype python nmap <LocalLeader>dd viw"ry:call Send_to_Tmux(@r . ".describe()\n")<CR>
au filetype python nmap <LocalLeader>dc viw"ry:call Send_to_Tmux(@r . ".columns\n")<CR>
au filetype python nmap <LocalLeader>dr viw"ry:call Send_to_Tmux(@r . ".index\n")<CR>
au filetype python nmap <LocalLeader>dm viw"ry:call Send_to_Tmux(@r . ".mean()\n")<CR>
" send code to ipython
"au filetype python vmap <LocalLeader>m "ry:call Send_Input_to_Tmux(@r)<CR>
"au filetype python nmap <LocalLeader>m viw"ry:call Send_Input_to_Tmux(@r)<CR>
"au filetype python nmap <LocalLeader>n :call Send_Input_to_Tmux('')<CR>
au filetype python vmap <LocalLeader>m "ry:call Send_to_Tmux(@r . "\n")<CR>
au filetype python nmap <LocalLeader>m viw"ry:call Send_to_Tmux(@r . "\n")<CR>
au filetype python nmap <LocalLeader>n :call Send_to_Tmux('')<CR>

" Help, documentation
" -------------------
au filetype python vmap <LocalLeader>hh "ry:call Send_to_Tmux(@r . "?\n")<CR>
au filetype python vmap <LocalLeader>hp "ry:call Send_to_Tmux("help(" . @r . ")\n")<CR>
au filetype python nmap <LocalLeader>hh viw"ry:call Send_to_Tmux(@r . "?\n")<CR>
au filetype python nmap <LocalLeader>hp viw"ry:call Send_to_Tmux("help(" . @r . ")\n")<CR>
au filetype python nmap <LocalLeader>hq :call Send_Keys_to_Tmux("q")<CR>
" navigation in help-doc
au filetype python nmap <C-j> :call Send_Keys_to_Tmux("C-d")<CR>
au filetype python nmap <C-k> :call Send_Keys_to_Tmux("C-u")<CR>
" Tab in to see choice
au filetype python vmap <LocalLeader>t "ry:call Send_to_Tmux(@r . ".\t")<CR>:call Send_Keys_to_Tmux("C-u")<CR>
au filetype python nmap <LocalLeader>t viw"ry:call Send_to_Tmux(@r . ".\t")<CR>:call Send_Keys_to_Tmux("C-u")<CR>

" others
" ------
" clear console
au filetype python nmap <LocalLeader>cl "ry:call Send_Keys_to_Tmux("C-l")<CR>
au filetype python nmap <LocalLeader>cu "ry:call Send_Keys_to_Tmux("C-u")<CR>
" go to ipython panel
au filetype python nmap <LocalLeader>o Go_to_Tmux_Panel()<CR>
" start ipython: set %autoindent OFF
" au filetype python nmap <LocalLeader>ps :call system("tmux splitw -v -p 50 'ipython'")<CR>:call system("tmux selectp -t 0")<CR><C-c>v
au filetype python nmap <LocalLeader>ps :call system("tmux splitw -v -p 50 'ipython'")<CR>:call system("tmux selectp -t 0")<CR>:call Send_to_Tmux("%autoindent\n")<CR>
" quit ipython and close the panel
au filetype python nmap <LocalLeader>pq :call system("tmux send-keys -t 1 'exit' Enter")<CR>
