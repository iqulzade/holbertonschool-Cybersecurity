#!/bin/bash
tracepath -n $1 2>/dev/null | awk '/Resume:/{print $NF;exit} END{print NR-1}'
