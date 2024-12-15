#!/usr/bin/env bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>~/.local/state/update-git-backups.log 2>&1

echo "$(date -Ins) Running update-git-backups.sh"

if [ ! -d "${HOME}/Documents/git-backups" ]; then
    echo "Git repo backups dir doesn't exist."
    exit 1
fi

for d in "${HOME}/Documents/git-backups"/*; do
    cd "$d"
    git pull
    cd ..
done

echo "$(date -Ins) Done running update-git-backups.sh"
