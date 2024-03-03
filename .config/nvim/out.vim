" capture (dump) the (somewhat long) ouput of the commands like `:digraph`, `:map', `:highlight`, `:scripnames` etc.

function! s:dump(cmd) abort

    " Start a new split or maybe a buffer or a tab
    " enew | " open a new buffer
    10split | enew | " open a new split (with 10% height (?))
    " tabnew | " open a new tab

    " Make it a scratch buffer ( `:help special-buffers`)
    setlocal
                \ bufhidden=wipe
                \ buftype=nofile
                \ nobuflisted
                \ nolist
                \ noswapfile
                \ norelativenumber
                \ nonumber

    " Write the cmd output to the buffer
    put =execute(a:cmd)
    " There are 2 empty line at the beginning of the buffer before the ouput of
    " the cmd. Not sure from where they are comning from. Anyhow I will delete
    " them.
    norm gg2dd

    " No modifications to this buffer
    setlocal readonly nomodifiable nomodified

    " Press escape to close when you're done
    nnoremap <buffer><silent> <Esc> :bd<CR>

endfunction

" Define a command to use the function easier
command! -nargs=1 Dump execute "call s:dump(" string(<q-args>) ")"
