#!/usr/bin/python3

import pynvim
import os

# use :echo v:servername in nvim to get the socket path
socket_path = '/run/user/1001/'
for file in os.listdir(socket_path):
    if file.startswith('nvim'):
        nvim = pynvim.attach('socket', path= socket_path + file)
        nvim.command('colorscheme pywal')
        nvim.command('highlight StatusLine guifg=#c0c0c0')
