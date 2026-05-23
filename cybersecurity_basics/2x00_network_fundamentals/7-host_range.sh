#!/bin/bash
python3 -c "import sys;ip=list(map(int,sys.argv[1].split('.')));n=int(sys.argv[2]);m=((0xFFFFFFFF<<(32-n))&0xFFFFFFFF);net=sum((ip[i]&((m>>s)&0xFF))<<(8*(3-i)) for i,s in enumerate([24,16,8,0]));f='.'.join(str((net+1>>s)&0xFF) for s in [24,16,8,0]);l='.'.join(str((net+(1<<(32-n))-2>>s)&0xFF) for s in [24,16,8,0]);print(f+' - '+l)" $1 $2
