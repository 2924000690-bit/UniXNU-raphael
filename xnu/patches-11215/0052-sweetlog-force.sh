#!/bin/sh
set -eu
d=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
p="$d/sweet-0047-sweet-persistent-console-log.patch"
if [ -f "$p" ]; then
  python3 - "$p" <<'PY'
import sys
p = sys.argv[1]
lines = open(p).read().splitlines(True)
changed = False
for i, line in enumerate(lines):
    if line.startswith("-\tif (!on") and "!su.writable" in line:
        lines[i] = line.replace("!su.writable || ", "", 1)
        changed = True
open(p, "w").writelines(lines)
print("sweetlog: 0047 condition changed", changed)
PY
fi
rm -f "$d/sweet-0052-sweetlog-force.patch"
