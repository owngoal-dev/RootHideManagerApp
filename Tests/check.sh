#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
check_dir=$(mktemp -d "${TMPDIR:-/tmp}/roothide-check.XXXXXX")
trap 'rm -rf "$check_dir"' EXIT
xcrun clang -fobjc-arc -DROOTHIDE_USE_STUB -I RootHide -framework Foundation \
    RootHide/RHCleaner.m Tests/CleanerRulesCheck.m -o "$check_dir/cleaner-rules"
"$check_dir/cleaner-rules"
python3 - <<'PY'
from pathlib import Path
import re
import zlib

expected = int(re.search(r"VARCLEANRULESHASH\s+(\d+)", Path("RootHide/VarCleanRules.h").read_text())[1])
assert zlib.crc32(Path("RootHide/VarCleanRules.json").read_bytes()) == expected
print("Bundled cleanup rules: CRC matches.")
PY
