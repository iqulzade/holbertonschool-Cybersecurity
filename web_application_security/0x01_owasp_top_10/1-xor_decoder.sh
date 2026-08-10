#!/bin/bash

input="$1"
encoded="${input#\{xor\}}"

echo -n "$encoded" | base64 -d | python3 -c '
import sys
data = sys.stdin.buffer.read()
key = b"{xor}"
decoded = bytes(b ^ key[i % len(key)] for i, b in enumerate(data))
sys.stdout.buffer.write(decoded)
'
echo