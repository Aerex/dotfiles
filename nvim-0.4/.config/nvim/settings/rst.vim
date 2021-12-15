" Preview rst in fast or slow mode, default is 0. If your computer is a bit slow, set it to 1.
let g:instant_rst_slow = 0
" Web browser for preview. default is ''. And then firefox will be used.
let g:instant_rst_browser = "qutebrowser"

" Only use localhost, and disable lan ip
let g:instant_rst_localhost_only = 1

" It requires the absolute path of the directory, and the last directory name is used in the server.
" A request made to /images/cats/1.png will try to serve the file from /home/<my_user>/<my_rst_project>/images/cats/1.png
" Serve additional directories for previewing, default is an empty array [].

