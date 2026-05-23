#!/bin/bash
python3 -c "import sys; ip=[int(x) for x in sys.argv[1].split('.')]; m=[int(x) for x in sys.argv[2].split('.')]; ipn=(ip[0]<<24)|(ip[1]<<16)|(ip[2]<<8)|ip[3]; mn=(m[0]<<24)|(m[1]<<16)|(m[2]<<8)|m[3]; b=(ipn | (~mn & 0xffffffff)); print('.'.join(str((b>>i)&255) for i in (24,16,8,0)))" "$1" "$2"
