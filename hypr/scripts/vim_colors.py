#!/usr/bin/python3

import pynvim
import os

for file in os.listdir('/run/user/1000'):
    if file.startswith('nvim'):
        nvim = pynvim.attach('socket', path='/run/user/1000/' + file)
        nvim.command('colorscheme pywal')
        nvim.command('highlight StatusLine guifg=#c0c0c0')
