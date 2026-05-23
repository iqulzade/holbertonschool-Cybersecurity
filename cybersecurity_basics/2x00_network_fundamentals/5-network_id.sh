#!/bin/bash
python3 -c "import sys;ip,mk=[list(map(int,x.split('.'))) for x in sys.argv[1:3]];print('.'.join(str(ip[i]&mk[i]) for i in range(4)))" $1 $2
