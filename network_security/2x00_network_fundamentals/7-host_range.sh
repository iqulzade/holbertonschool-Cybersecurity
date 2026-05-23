#!/bin/bash
python3 -c "import sys; ip=[int(x) for x in sys.argv[1].split('.')]; c=int(sys.argv[2]); ipn=(ip[0]<<24)|(ip[1]<<16)|(ip[2]<<8)|ip[3]; mask=(0xffffffff << (32-c)) & 0xffffffff; net=ipn & mask; bcast=net | (~mask & 0xffffffff); first=net+1; last=bcast-1; fmt=lambda x: '.'.join(str((x>>i)&255) for i in (24,16,8,0)); print(f'{fmt(first)} - {fmt(last)}')" "$1" "$2"
