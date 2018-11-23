#!/bin/bash
file="$1"
grep -oE "^\s*\w+\s+\w+\(.*\)\s*{" "$file" | sed 's/[[:space:]]*{$/;/' | sed 's/^[[:space:]]*//'
# Issues: '{' must be in the same line as function declaration for proper working. In other case, please indent
# with this style your code before use this script
