#!/usr/bin/env bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>~/.local/state/restic.log 2>&1

echo "$(date -Ins) Running run_restic.sh"

if [ "$(pgrep -l "^restic")" ]; then
	echo "$(date -Ins) restic is already running, stopping"
	exit 1
fi

echo "$(date -Ins) Sourcing environment variables"
. "${HOME}/.local/bin/my-restic_env.sh"

echo "$(date -Ins) Changing directory to \$HOME"
cd "${HOME}"

echo "$(date -Ins) Making a backup of \$HOME"
restic --verbose backup . --exclude-file="${HOME}/.config/restic_ignore.txt"

echo "$(date -Ins) Done running run_restic.sh"
