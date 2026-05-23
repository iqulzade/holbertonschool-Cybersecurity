#!/bin/bash
python3 -c "import sys; n=int(sys.argv[1]); m=(0xffffffff << (32-n)) & 0xffffffff; print('.'.join(str((m>>i)&255) for i in (24,16,8,0)))" "$1"
