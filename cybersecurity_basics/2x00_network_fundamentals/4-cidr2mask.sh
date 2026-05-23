#!/bin/bash
python3 -c "n=$1;m=((0xFFFFFFFF<<(32-n))&0xFFFFFFFF);print('.'.join([str((m>>s)&0xFF) for s in [24,16,8,0]]))"
