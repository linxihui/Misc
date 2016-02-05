aut filetype juila set expandtab
" check class
au filetype julia vmap <LocalLeader>cc "ry:call Send_to_Tmux("typeof(" . @r . ")\n")<CR>
au filetype julia nmap <LocalLeader>cc viw"ry:call Send_to_Tmux("typeof(" . @r . ")\n")<CR>
au filetype julia nmap <LocalLeader>rt viw"ry:call Send_to_Tmux("dump(" . @r . ")\n")<CR>

" data insight, mainly for pandas.DataFrame
au filetype julia vmap <LocalLeader>ds "ry:call Send_to_Tmux(@r . ".shape\n")<CR>
au filetype julia vmap <LocalLeader>dh "ry:call Send_to_Tmux(@r . ".head()\n")<CR>
au filetype julia vmap <LocalLeader>dt "ry:call Send_to_Tmux(@r . ".tail()\n")<CR>
au filetype julia vmap <LocalLeader>dd "ry:call Send_to_Tmux(@r . ".describe()\n")<CR>
au filetype julia vmap <LocalLeader>dc "ry:call Send_to_Tmux(@r . ".columns\n")<CR>
au filetype julia vmap <LocalLeader>dr "ry:call Send_to_Tmux(@r . ".index\n")<CR>
au filetype julia vmap <LocalLeader>dm "ry:call Send_to_Tmux(@r . ".mean()\n")<CR>
au filetype julia nmap <LocalLeader>ds viw"ry:call Send_to_Tmux(@r . ".shape\n")<CR>
au filetype julia nmap <LocalLeader>dh viw"ry:call Send_to_Tmux(@r . ".head()\n")<CR>
au filetype julia nmap <LocalLeader>dt viw"ry:call Send_to_Tmux(@r . ".tail()\n")<CR>
au filetype julia nmap <LocalLeader>dd viw"ry:call Send_to_Tmux(@r . ".describe()\n")<CR>
au filetype julia nmap <LocalLeader>dc viw"ry:call Send_to_Tmux(@r . ".columns\n")<CR>
au filetype julia nmap <LocalLeader>dr viw"ry:call Send_to_Tmux(@r . ".index\n")<CR>
au filetype julia nmap <LocalLeader>dm viw"ry:call Send_to_Tmux(@r . ".mean()\n")<CR>
" send code to ijulia
au filetype julia vmap <LocalLeader>m "ry:call Send_Input_to_Tmux(@r)<CR>
au filetype julia nmap <LocalLeader>m viw"ry:call Send_Input_to_Tmux(@r)<CR>
au filetype julia nmap <LocalLeader>n :call Send_Input_to_Tmux('')<CR>
