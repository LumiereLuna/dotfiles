#!/usr/bin/env bash

cd "${HOME}/dotfiles/"
fd --hidden --type f --extension age --exclude key.txt.age --exec age --decrypt --identity key.txt --output "{.}" "{}"
