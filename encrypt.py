#!/usr/bin/env python

from glob import iglob
from subprocess import call
from os.path import isfile


def main():
    for fi in iglob("**/*.age", root_dir=".", recursive=True, include_hidden=True):
        decrypted_file = fi[:-4]
        if not isfile(decrypted_file) or fi == "key.txt.age":
            continue
        call(
            [
                "age",
                "--encrypt",
                "--armor",
                "--recipient",
                "age1ew8vjkz2qyt23yg9h4kwnesl9307ffspr05yyj6qwrwtaul9wp8q8emwrd",
                "--output",
                fi,
                decrypted_file,
            ]
        )


if __name__ == "__main__":
    main()
