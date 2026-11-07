#!/system/bin/sh
here="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
sh "$here/tools/inspect.sh" | tee "$here/last-report.txt"
echo 'Read-only: system package installer was not modified.'
