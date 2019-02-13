" Use 80 columns to display fold text.
let g:ledger_maxwidth = 80

" Use a · to connect the account name to the amount in fold text.
let g:ledger_fillstring = '·'

" Set default commodity
let g:ledger_default_commodity = 'USD'

" Align decimal separators at column 53
let g:ledger_align_at = 53


" Flag that tells whether the commodity should be prepended or appended to the amount
let g:ledger_commodity_before = 0

au BufEnter *.ldg,*.journal,*.ledger setlocal ft=ledger fp=ledger\ -f\ -\ -S\ d\ print
au BufNewFile,BufRead *.ldg,*.journal,*.ledger setf ledger | comp ledger
let g:ledger_maxwidth = 120
let g:ledger_fold_blanks = 1
function LedgerSort()
    :%! ledger -f - print --sort 'date, amount' | sed -i '1s/^/;default commodity\nD 1,000.00 USD\n\n'>/dev/null
    :%LedgerAlign
endfunction

command LedgerSort call LedgerSort()


if exists('g:ycm_filetype_blacklist')
    call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif
autocmd FileType ledger nnoremap <leader>c :call ledger#transaction_state_toggle(line('.'), ' *?!')<CR>
autocmd FileType ledger nnoremap <leader>S :LedgerSort<CR>

function! LedgerMode()
  if exists('g:ledger_mode') && len(g:ledger_mode)
    let $LEDGER_MODE = g:ledger_mode 
  end
endfunction
