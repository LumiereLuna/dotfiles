#!/usr/bin/env bash

cd "${HOME}/dotfiles/"
fd --hidden --type f --extension age --exclude key.txt.age --exec age --encrypt --armor --recipient age1ew8vjkz2qyt23yg9h4kwnesl9307ffspr05yyj6qwrwtaul9wp8q8emwrd --output "{}" "{.}"
