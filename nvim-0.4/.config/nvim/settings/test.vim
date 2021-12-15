let test#javascript#lab#options = "-l -v"
let test#strategy = "dispatch"
"" Press this with terminal output to enter normal mode so you can scroll
"" through terminal output
"if has("nvim")
"  tmap <C-o> <C-\><C-n>
"endif


" In a test file runs the test nearest to the cursor, otherwise runs the last nearest test. In test frameworks that don"t support line numbers it will polyfill this functionality with regexes.
nmap <silent> <Space>tn :TestNearest<CR>

" TestFile
" In a test file runs all tests in the current file<leader> otherwise runs the last file tests.
nmap <silent> <Space>tf :TestFile<CR>

" TestSuite	
" Runs the whole test suite (if the current file is a test file<leader> runs that framework"s test suite<leader> otherwise determines the test framework from the last run test).
nmap <silent> <Space>t :TestSuite<CR>

"TestLast	Runs the last test.
"TestVisit	Visits the test file from which you last run your tests (useful when you"re trying to make a test pass<Space> and you dive deep into application code and close your test buffer to make more space<Space> and once you"ve made it pass you want to go back to the test file to write more tests).
nmap <silent> <Space><Space>l :TestLast<CR>



nmap <silent> <Space>tv :TestVisit<CR>

"press escape to get into normal mode
tnoremap <Esc> <C-\><C-n>  
"Enable to use scrolling in normal mode
if has("nvim")
  tmap <C-o> <C-\><C-n>
end


