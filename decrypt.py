#!/usr/bin/env python

from glob import iglob
from subprocess import call
from os.path import isfile


def main():
    for fi in iglob("**/*.age", root_dir=".", recursive=True, include_hidden=True):
        if not isfile(fi) or fi == "key.txt.age":
            continue
        call(
            ["age", "--decrypt", "--identity", "key.txt", "--output", f"{fi[:-4]}", fi]
        )


if __name__ == "__main__":
    main()
