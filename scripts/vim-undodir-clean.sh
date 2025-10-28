#!/bin/bash
# clean undo files beyond 30 days
find ~/.vim/undodir -type f -mtime +30 -delete
