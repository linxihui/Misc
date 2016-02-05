au filetype sql nmap <LocalLeader>l <Esc>V<C-c><C-c>'<
au filetype sql nmap <LocalLeader>e :call Send_to_Tmux(";\n")<CR>
"au filetype sql vmap <LocalLeader>l <C-c><C-c>'>
au filetype sql vmap <LocalLeader>l "ry:call Send_to_Tmux(substitute(substitute(@r . ";;\n", "\n*;*\n*;;\n", ";\n", ""), "\t", "    ", "g"))<CR><CR>
au filetype sql nmap <LocalLeader>pp vip<C-c><C-c>}
au filetype sql nmap <LocalLeader>p vip<C-c><C-c>}
au filetype sql nmap <LocalLeader>cl "ry:call Send_Keys_to_Tmux("C-l")<CR>
au filetype sql nmap <LocalLeader>cu "ry:call Send_Keys_to_Tmux("C-u")<CR>
" go to isql panel
au filetype sql nmap <LocalLeader>o Go_to_Tmux_Panel()<CR>
" start isql
au filetype sql nmap <LocalLeader>ps :call system("tmux splitw -v -p 50 'mysql -u root --password=5324'")<CR>:call system("tmux selectp -t 0")<CR><C-c>v
" quit isql and close the panel
au filetype sql nmap <LocalLeader>pq :call system("tmux send-keys -t 1 'exit' Enter")<CR>
au filetype sql nmap <LocalLeader>d viw"ry:call Send_to_Tmux("DESCRIBE " . @r . ";\n")<CR>
au filetype sql nmap <LocalLeader>s viw"ry:call Send_to_Tmux("SELECT * FROM " . @r . " LIMIT 5;\n")<CR>
au filetype sql set expandtab
