#!/bin/bash
echo "$1" | awk -F'.' '{for(i=1;i<=4;i++){n=$i;s="";for(b=7;b>=0;b--)s=s int(n/2^b)%2;printf "%s%s",(i>1?".":""),s};print""}'
