#!/usr/bin/env bash
# verify.sh — confirm index.html matches the reviewed artifact
# Usage: bash scripts/verify.sh

set -e

FILE="$(dirname "$0")/../index.html"

if [ ! -f "$FILE" ]; then
  echo "ERROR: index.html not found at $FILE"
  exit 1
fi

HASH=$(sha256sum "$FILE" | awk '{print $1}')
SIZE=$(wc -c < "$FILE" | tr -d ' ')
LINES=$(wc -l < "$FILE" | tr -d ' ')

echo ""
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  Continuity MVP — Integrity Check                           │"
echo "├─────────────────────────────────────────────────────────────┤"
printf "│  File:   %-52s│\n" "index.html"
printf "│  Lines:  %-52s│\n" "$LINES"
printf "│  Bytes:  %-52s│\n" "$SIZE"
echo "│  SHA-256:                                                   │"
printf "│  %-61s│\n" "$HASH"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""
echo "Artifact version reviewed: 1794137102-c936"
echo "Artifact URL: https://claude.ai/artifact/7qTFjWor4tbS6JPJJmSQya"
echo ""
echo "Store this hash in docs/CHECKSUMS.txt after your review to"
echo "verify future deployments haven't altered the file."
echo ""

# Save to CHECKSUMS.txt if not already there
CHECKSUMS="$(dirname "$0")/../docs/CHECKSUMS.txt"
if [ ! -f "$CHECKSUMS" ] || ! grep -q "$HASH" "$CHECKSUMS" 2>/dev/null; then
  {
    echo "# Continuity MVP — Checksums"
    echo "# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "# Artifact:  1794137102-c936"
    echo ""
    echo "SHA-256  index.html"
    echo "$HASH  index.html"
  } > "$CHECKSUMS"
  echo "✓ Saved to docs/CHECKSUMS.txt"
fi
